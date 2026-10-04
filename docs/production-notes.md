# Production notes

Concise notes on the Firestore read-cost and security design, written for the
Spark (free) plan. Read alongside `firestore.rules` and the Data layer.

## Why the transactions listener is windowed

`FirestoreTransactionRepository` streams only transactions whose `date` is on
or after the first day of the month `windowMonths - 1` months ago (default:
the current month plus the 11 before it), newest first, capped at
`maxDocuments` (default 1000).

What that means for users:

- Dashboard balance, income, expense and the transactions list cover **only
  the window**. Older transactions still exist in Firestore but are not
  loaded, so they are excluded from totals and filters.
- If a user has more than `maxDocuments` transactions inside the window, the
  oldest ones in the window are dropped as well (a debug log reports the cap).
- The window is fixed when the listener is created; it moves forward the next
  time the listener is rebuilt (for example on app restart or sign-in).

Totals stay client-side on purpose: they work offline from the local cache
and need no extra documents or server logic.

## How I would do it in production

| Option | How | Why not here |
|---|---|---|
| Summary document per user and currency | Each write also increments `income`/`expense` counters in `users/{uid}/summaries/{currency}` (same batch or transaction); a "recompute" action rebuilds it from the transactions. | Increments in a client batch can drift (partial failures, edits of old rows, deleted rows, rule bypass bugs) and need a recompute path. Offline, transactions spanning two docs complicate conflict handling. More moving parts than the window for a portfolio app. |
| Server-side aggregation | `count()`/`sum()` aggregation queries over the full collection, cached per screen. | Aggregations do not work offline and do not stream; they are billed per index entries scanned, and the UI would need a second code path for live updates. |
| Server logic | Cloud Functions maintaining summaries. | Requires the Blaze plan (forbidden by the project constraints). |

A production system would most likely combine a summary document (for the
headline balance over all time) with the windowed listener (for the list).

## Read-cost notes

- A listener costs one read per document in its initial result, then one read
  per added/changed/removed document. The window and cap bound the initial
  cost to at most `maxDocuments` reads per listener start.
- If a listener has been disconnected for more than 30 minutes (for example
  the app was closed), re-attaching it is billed like a new query: assume a
  full re-read of the window on cold start.
- Wallet reads are limited to 50 documents. Default-wallet seeding reads the
  wallet list once per user per app process and writes at most four documents.
- The old wallet migration read the **entire** transactions collection on the
  first launch of every new device session; that backfill is removed.
- Security rules use no `get()`/`exists()`, so rule evaluation costs no reads.

## Late server rejection after the write timeout

Transaction writes wait at most `writeTimeout` (3 s) for the server
acknowledgement, then report success because the write is queued in the local
cache. If the server later rejects it (for example the rules deny an invalid
document, or permissions changed), the SDK silently rolls the local change
back: the transaction disappears from the list without an error message.
The schema in `firestore.rules` mirrors the client validation, so this should
only happen for clients with bugs or tampered data.

## Deployment order

1. Deploy indexes first, if `firestore.indexes.json` changed
   (`firebase deploy --only firestore:indexes`) and wait until they are built.
   This change needs none: the transactions query is a range plus `orderBy` on
   the single field `date`, served by the automatic single-field index.
2. Deploy rules (`firebase deploy --only firestore:rules`) **before** shipping
   a client that relies on them, and before testing on a device.
3. Ship the client.

Run `tools/rules-test` against the emulator before every rules deploy.

## Known open items

- Wallet writes and the seeding still await server acknowledgement: offline,
  they hang like transactions did before the write timeout.
- The listener window does not advance while the app stays open across a
  month boundary.
- Transactions older than the window are invisible in the app; there is no
  "load older" action yet.
- Firestore rules cap `title` at 500 characters, but the client does not
  limit the notes field: a longer title would be accepted locally and later
  rolled back by the server (see "Late server rejection").
- `WalletRepository.addWallet` still creates auto-id wallets; nothing in the
  UI calls it today.
