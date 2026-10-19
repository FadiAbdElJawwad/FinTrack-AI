import 'package:fin_track_ai/features/transactions/presentation/widgets/wallet_selector.dart';
import 'package:fin_track_ai/features/wallets/domain/models/wallet_model.dart';
import 'package:fin_track_ai/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestWidget({
  required List<WalletModel> wallets,
  String? selectedWalletId,
  required Function(String) onSelect,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: WalletSelector(
        wallets: wallets,
        selectedWalletId: selectedWalletId,
        onSelect: onSelect,
      ),
    ),
  );
}

void main() {
  const seededWallets = [
    WalletModel(id: 'cash', name: 'Cash', icon: 'payments'),
    WalletModel(id: 'bank', name: 'Bank Account', icon: 'account_balance'),
    WalletModel(id: 'paypal', name: 'PayPal', icon: 'account_balance_wallet'),
    WalletModel(id: 'other', name: 'Other', icon: 'more_horiz'),
  ];

  group('WalletSelector localization tests', () {
    testWidgets('9. Arabic: seeded wallets show localized names', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(
          wallets: seededWallets,
          onSelect: (_) {},
          locale: const Locale('ar'),
        ),
      );

      expect(find.text('نقدي'), findsOneWidget);
      expect(find.text('حساب بنكي'), findsOneWidget);
      expect(find.text('PayPal'), findsOneWidget);
      expect(find.text('أخرى'), findsOneWidget);
    });

    testWidgets('10. English: seeded wallets show English names', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(
          wallets: seededWallets,
          onSelect: (_) {},
          locale: const Locale('en'),
        ),
      );

      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('Bank Account'), findsOneWidget);
      expect(find.text('PayPal'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
    });

    testWidgets(
      '11. In Arabic, renamed seeded wallet and user wallet show stored names',
      (tester) async {
        const customWallets = [
          WalletModel(id: 'cash', name: 'My Cash', icon: 'payments'),
          WalletModel(id: 'w1', name: 'Savings', icon: 'savings'),
        ];

        await tester.pumpWidget(
          _buildTestWidget(
            wallets: customWallets,
            onSelect: (_) {},
            locale: const Locale('ar'),
          ),
        );

        expect(find.text('My Cash'), findsOneWidget);
        expect(find.text('Savings'), findsOneWidget);
      },
    );

    testWidgets('12. Tapping a chip calls onSelect with wallet id', (
      tester,
    ) async {
      String? selectedId;
      await tester.pumpWidget(
        _buildTestWidget(
          wallets: seededWallets,
          onSelect: (id) => selectedId = id,
          locale: const Locale('ar'),
        ),
      );

      await tester.tap(find.text('نقدي'));
      await tester.pump();

      expect(selectedId, equals('cash'));
    });
  });
}
