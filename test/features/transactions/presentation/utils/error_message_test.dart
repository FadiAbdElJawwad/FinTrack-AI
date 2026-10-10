import 'package:fin_track_ai/core/error/currency_exception.dart';
import 'package:fin_track_ai/core/error/transaction_exception.dart';
import 'package:fin_track_ai/core/error/wallet_exception.dart';
import 'package:fin_track_ai/l10n/app_localizations.dart';
import 'package:fin_track_ai/features/transactions/presentation/utils/error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Future<BuildContext> pumpContext(WidgetTester tester) async {
  late BuildContext captured;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          captured = context;
          return const SizedBox();
        },
      ),
    ),
  );
  return captured;
}

void main() {
  testWidgets('TransactionException types map to localized messages', (
    tester,
  ) async {
    final context = await pumpContext(tester);
    final loc = AppLocalizations.of(context);
    final expected = {
      TransactionErrorType.networkError: loc.networkRequestFailed,
      TransactionErrorType.permissionDenied: loc.databaseError,
      TransactionErrorType.notFound: loc.databaseError,
      TransactionErrorType.invalidData: loc.databaseError,
      TransactionErrorType.notAuthenticated: loc.sessionExpired,
      TransactionErrorType.unknown: loc.unknownError,
    };
    expect(expected.keys.toSet(), TransactionErrorType.values.toSet());
    for (final entry in expected.entries) {
      expect(
        errorMessage(context, TransactionException(entry.key)),
        entry.value,
      );
    }
  });

  testWidgets('WalletException types map to localized messages', (
    tester,
  ) async {
    final context = await pumpContext(tester);
    final loc = AppLocalizations.of(context);
    final expected = {
      WalletErrorType.networkError: loc.networkRequestFailed,
      WalletErrorType.permissionDenied: loc.databaseError,
      WalletErrorType.notFound: loc.databaseError,
      WalletErrorType.invalidData: loc.databaseError,
      WalletErrorType.notAuthenticated: loc.sessionExpired,
      WalletErrorType.unknown: loc.unknownError,
    };
    expect(expected.keys.toSet(), WalletErrorType.values.toSet());
    for (final entry in expected.entries) {
      expect(errorMessage(context, WalletException(entry.key)), entry.value);
    }
  });

  testWidgets('exchange rate errors use the service error message', (
    tester,
  ) async {
    final context = await pumpContext(tester);
    final loc = AppLocalizations.of(context);
    expect(
      errorMessage(context, NoExchangeRatesAvailableException()),
      loc.exchangeRateServiceError,
    );
    expect(
      errorMessage(context, const ExchangeRateServiceException('HTTP 500')),
      loc.exchangeRateServiceError,
    );
  });

  testWidgets('unknown errors never leak their text', (tester) async {
    final context = await pumpContext(tester);
    final loc = AppLocalizations.of(context);
    final secret = StateError('secret-details');
    expect(errorMessage(context, secret), loc.unknownError);
    expect(
      errorMessage(
        context,
        TransactionException(
          TransactionErrorType.unknown,
          message: 'secret-details',
        ),
      ),
      loc.unknownError,
    );
  });
}
