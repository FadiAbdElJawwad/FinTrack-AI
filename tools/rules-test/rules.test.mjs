// Firestore security rules tests. Runs only against the local emulator with
// the demo project id `demo-fintrack-rules-test` (see package.json).
import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, test } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import { doc, serverTimestamp, setDoc, updateDoc } from 'firebase/firestore';

const PROJECT_ID = 'demo-fintrack-rules-test';
let env;

const validTx = (id = 'tx1') => ({
  id,
  amountMinor: 1234,
  currency: 'USD',
  type: 'expense',
  category: 'food',
  title: 'Lunch',
  date: '2026-10-03T12:30:00.000',
  walletId: 'cash',
});

const validWallet = (id = 'cash') => ({
  id,
  name: 'Cash',
  icon: 'payments',
  isDefault: true,
});

const asAlice = () => env.authenticatedContext('alice').firestore();
const txRef = (db, id = 'tx1', uid = 'alice') =>
  doc(db, `users/${uid}/transactions/${id}`);

before(async () => {
  env = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: {
      rules: readFileSync(new URL('../../firestore.rules', import.meta.url), 'utf8'),
      host: '127.0.0.1',
      port: 8080,
    },
  });
});

beforeEach(async () => env.clearFirestore());
after(async () => env.cleanup());

describe('transactions', () => {
  test('owner can create a valid transaction', async () => {
    await assertSucceeds(setDoc(txRef(asAlice()), validTx()));
  });

  test('owner can update a valid transaction (full map, like the app)', async () => {
    const db = asAlice();
    await assertSucceeds(setDoc(txRef(db), validTx()));
    await assertSucceeds(updateDoc(txRef(db), { ...validTx(), amountMinor: 999 }));
  });

  test('JOD with three-decimal minor units is allowed', async () => {
    await assertSucceeds(
      setDoc(txRef(asAlice()), { ...validTx(), currency: 'JOD', amountMinor: 1005 }),
    );
  });

  test('another user is denied', async () => {
    const bob = env.authenticatedContext('bob').firestore();
    await assertFails(setDoc(txRef(bob), validTx()));
  });

  test('another user cannot read', async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(txRef(ctx.firestore()), validTx());
    });
    const bob = env.authenticatedContext('bob').firestore();
    const { getDoc } = await import('firebase/firestore');
    await assertFails(getDoc(txRef(bob)));
  });

  test('unauthenticated is denied', async () => {
    const anon = env.unauthenticatedContext().firestore();
    await assertFails(setDoc(txRef(anon), validTx()));
  });

  test('zero amount is denied', async () => {
    await assertFails(setDoc(txRef(asAlice()), { ...validTx(), amountMinor: 0 }));
  });

  test('negative amount is denied', async () => {
    await assertFails(setDoc(txRef(asAlice()), { ...validTx(), amountMinor: -5 }));
  });

  test('amount above the cap is denied', async () => {
    await assertFails(
      setDoc(txRef(asAlice()), { ...validTx(), amountMinor: 1000000000001 }),
    );
  });

  test('amountMinor as a double is denied', async () => {
    await assertFails(setDoc(txRef(asAlice()), { ...validTx(), amountMinor: 12.5 }));
  });

  test('unknown currency is denied', async () => {
    await assertFails(setDoc(txRef(asAlice()), { ...validTx(), currency: 'EUR' }));
  });

  test('unknown type is denied', async () => {
    await assertFails(setDoc(txRef(asAlice()), { ...validTx(), type: 'transfer' }));
  });

  test('unknown category is denied', async () => {
    await assertFails(setDoc(txRef(asAlice()), { ...validTx(), category: 'crypto' }));
  });

  test('extra field is denied (including the legacy amount)', async () => {
    await assertFails(setDoc(txRef(asAlice()), { ...validTx(), amount: 12.34 }));
  });

  test('missing field is denied', async () => {
    const { walletId, ...withoutWallet } = validTx();
    await assertFails(setDoc(txRef(asAlice()), withoutWallet));
  });

  test('id different from the document id is denied', async () => {
    await assertFails(setDoc(txRef(asAlice(), 'tx1'), validTx('other')));
  });

  test('title longer than 500 characters is denied', async () => {
    await assertFails(
      setDoc(txRef(asAlice()), { ...validTx(), title: 'x'.repeat(501) }),
    );
  });

  test('owner can delete', async () => {
    const db = asAlice();
    await assertSucceeds(setDoc(txRef(db), validTx()));
    const { deleteDoc } = await import('firebase/firestore');
    await assertSucceeds(deleteDoc(txRef(db)));
  });
});

describe('wallets', () => {
  const walletRef = (db, id = 'cash') => doc(db, `users/alice/wallets/${id}`);

  test('valid wallet is allowed', async () => {
    await assertSucceeds(setDoc(walletRef(asAlice()), validWallet()));
  });

  test('wallet with an empty name is denied', async () => {
    await assertFails(setDoc(walletRef(asAlice()), { ...validWallet(), name: '' }));
  });

  test('wallet with a non-bool isDefault is denied', async () => {
    await assertFails(
      setDoc(walletRef(asAlice()), { ...validWallet(), isDefault: 'yes' }),
    );
  });

  test('wallet with an extra field is denied', async () => {
    await assertFails(
      setDoc(walletRef(asAlice()), { ...validWallet(), balance: 10 }),
    );
  });

  test('wallet id different from the document id is denied', async () => {
    await assertFails(setDoc(walletRef(asAlice(), 'cash'), validWallet('bank')));
  });
});

describe('users', () => {
  const userRef = (db, uid = 'alice') => doc(db, `users/${uid}`);

  test('baseCurrency EUR is denied', async () => {
    await assertFails(
      setDoc(userRef(asAlice()), { baseCurrency: 'EUR' }, { merge: true }),
    );
  });

  test('baseCurrency USD is allowed (merge write, like the app)', async () => {
    await assertSucceeds(
      setDoc(userRef(asAlice()), { baseCurrency: 'USD' }, { merge: true }),
    );
  });

  test('email sign-up document (no baseCurrency) is allowed', async () => {
    await assertSucceeds(
      setDoc(userRef(asAlice()), {
        fullName: 'Alice',
        email: 'alice@example.com',
        createdAt: serverTimestamp(),
        uid: 'alice',
      }),
    );
  });

  test('Google sign-in document is allowed', async () => {
    await assertSucceeds(
      setDoc(userRef(asAlice()), {
        fullName: 'Alice',
        email: 'alice@example.com',
        createdAt: serverTimestamp(),
        photoUrl: null,
        uid: 'alice',
        baseCurrency: 'USD',
      }),
    );
  });

  test('another user cannot write the user document', async () => {
    const bob = env.authenticatedContext('bob').firestore();
    await assertFails(setDoc(userRef(bob, 'alice'), { baseCurrency: 'USD' }));
  });

  test('client delete of the user document is denied', async () => {
    const db = asAlice();
    await assertSucceeds(setDoc(userRef(db), { baseCurrency: 'USD' }));
    const { deleteDoc } = await import('firebase/firestore');
    await assertFails(deleteDoc(userRef(db)));
  });
});

describe('default deny', () => {
  test('unknown top-level collection is denied', async () => {
    await assertFails(setDoc(doc(asAlice(), 'other/x'), { a: 1 }));
  });

  test('unknown user subcollection is denied', async () => {
    await assertFails(setDoc(doc(asAlice(), 'users/alice/secrets/x'), { a: 1 }));
  });
});
