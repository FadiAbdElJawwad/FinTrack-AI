import 'package:fin_track_ai/l10n/app_localizations.dart';
import 'package:fin_track_ai/features/transactions/domain/usecases/group_transactions_usecase.dart';
import 'package:fin_track_ai/features/transactions/presentation/utils/transaction_group_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Future<BuildContext> pumpContext(WidgetTester tester, Locale locale) async {
  late BuildContext captured;
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
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
  for (final locale in const [Locale('en'), Locale('ar')]) {
    testWidgets(
      'TransactionGroup labels are localized and distinct for ${locale.languageCode}',
      (tester) async {
        final context = await pumpContext(tester, locale);
        final loc = AppLocalizations.of(context);

        final labels = <String>{};
        for (final group in TransactionGroup.values) {
          final label = group.label(loc);
          expect(label.trim(), isNotEmpty);
          labels.add(label);
        }

        expect(labels.length, TransactionGroup.values.length);
      },
    );
  }
}
