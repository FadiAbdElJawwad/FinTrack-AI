import 'package:fin_track_ai/features/currency/domain/models/app_currency.dart';
import 'package:fin_track_ai/features/transactions/domain/models/transaction_model.dart';
import 'package:fin_track_ai/features/transactions/presentation/screens/transaction_details.dart';
import 'package:fin_track_ai/features/transactions/presentation/state/transaction_controller.dart';
import 'package:fin_track_ai/features/wallets/domain/models/wallet_model.dart';
import 'package:fin_track_ai/features/wallets/presentation/state/wallet_controller.dart';
import 'package:fin_track_ai/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

class TestTransactionController extends TransactionController {
  final List<TransactionModel> transactions;
  TestTransactionController(this.transactions);

  @override
  Stream<List<TransactionModel>> build() => Stream.value(transactions);
}

class TestWalletController extends WalletController {
  final List<WalletModel> wallets;
  TestWalletController(this.wallets);

  @override
  Stream<List<WalletModel>> build() => Stream.value(wallets);
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar', null);
    await initializeDateFormatting('en', null);
  });

  group('TransactionDetails wallet localization test', () {
    testWidgets(
      '13. TransactionDetails: seeded wallet shows localized name in Arabic',
      (tester) async {
        final sampleTx = TransactionModel(
          id: 'tx1',
          amountMinor: 1000,
          currency: AppCurrency.usd,
          type: TransactionType.expense,
          category: TransactionCategory.food,
          title: 'Dinner',
          date: DateTime(2026, 10, 14, 15, 30),
          walletId: 'cash',
        );
        const seededWallets = [
          WalletModel(id: 'cash', name: 'Cash', icon: 'payments'),
        ];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              transactionControllerProvider.overrideWith(
                () => TestTransactionController([sampleTx]),
              ),
              walletControllerProvider.overrideWith(
                () => TestWalletController(seededWallets),
              ),
            ],
            child: const MaterialApp(
              locale: Locale('ar'),
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: TransactionDetails(transactionId: 'tx1'),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(Duration.zero);

        expect(find.text('نقدي'), findsOneWidget);
      },
    );
  });
}
