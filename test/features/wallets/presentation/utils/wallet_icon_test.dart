import 'package:fin_track_ai/features/wallets/presentation/utils/wallet_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('walletIconData', () {
    test('every entry in walletIconChoices maps to a non-fallback icon', () {
      const fallback = Icons.account_balance_wallet_outlined;
      expect(walletIconChoices.length, 8);

      for (final choice in walletIconChoices) {
        final icon = walletIconData(choice);
        expect(
          icon,
          isNot(equals(fallback)),
          reason: 'Choice $choice returned fallback',
        );
      }
    });

    test('unknown icon name returns fallback icon', () {
      const fallback = Icons.account_balance_wallet_outlined;
      expect(walletIconData('non_existent_icon'), equals(fallback));
    });
  });
}
