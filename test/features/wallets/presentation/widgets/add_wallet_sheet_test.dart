import 'package:fin_track_ai/core/error/wallet_exception.dart';
import 'package:fin_track_ai/features/wallets/domain/models/wallet_model.dart';
import 'package:fin_track_ai/features/wallets/presentation/state/wallet_controller.dart';
import 'package:fin_track_ai/features/wallets/presentation/widgets/add_wallet_sheet.dart';
import 'package:fin_track_ai/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TestWalletController extends WalletController {
  TestWalletController(this.initialWallets, {this.onAddWallet});

  final List<WalletModel> initialWallets;
  final Future<void> Function(WalletModel wallet)? onAddWallet;

  @override
  Stream<List<WalletModel>> build() async* {
    yield initialWallets;
  }

  @override
  Future<void> addWallet(WalletModel wallet) async {
    if (onAddWallet != null) {
      await onAddWallet!(wallet);
    }
  }
}

Widget createTestApp({
  required List<WalletModel> wallets,
  Future<void> Function(WalletModel wallet)? onAddWallet,
}) {
  return ProviderScope(
    overrides: [
      walletControllerProvider.overrideWith(
        () => TestWalletController(wallets, onAddWallet: onAddWallet),
      ),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showAddWalletSheet(context),
            child: const Text('Open Sheet'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('AddWalletSheet', () {
    testWidgets(
        '14. Create button is disabled while name is empty or whitespace only',
        (tester) async {
      await tester.pumpWidget(createTestApp(wallets: []));
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Create Wallet');
      expect(buttonFinder, findsOneWidget);

      final buttonWidgetInitial = tester.widget<ElevatedButton>(buttonFinder);
      expect(buttonWidgetInitial.onPressed, isNull);

      await tester.enterText(find.byType(TextField), '   ');
      await tester.pumpAndSettle();

      final buttonWidgetWhitespace =
          tester.widget<ElevatedButton>(buttonFinder);
      expect(buttonWidgetWhitespace.onPressed, isNull);
    });

    testWidgets(
        '15. duplicate name (case-insensitive, trimmed) shows walletNameExists and keeps Create disabled',
        (tester) async {
      final existingWallets = [
        const WalletModel(
          id: 'cash',
          name: 'Cash',
          icon: 'payments',
          isDefault: true,
        ),
      ];

      await tester.pumpWidget(createTestApp(wallets: existingWallets));
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '   cAsH  ');
      await tester.pumpAndSettle();

      expect(
        find.text('A wallet with this name already exists.'),
        findsOneWidget,
      );

      final buttonWidget = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Create Wallet'),
      );
      expect(buttonWidget.onPressed, isNull);
    });

    testWidgets(
        '16. valid name and icon calls addWallet once with trimmed name and closes sheet',
        (tester) async {
      WalletModel? addedWallet;
      int addCallCount = 0;

      await tester.pumpWidget(
        createTestApp(
          wallets: [],
          onAddWallet: (wallet) async {
            addCallCount++;
            addedWallet = wallet;
          },
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '  Vacation Fund  ');
      await tester.pumpAndSettle();

      // Tap 'savings' icon in the selector
      await tester.tap(find.byIcon(Icons.savings));
      await tester.pumpAndSettle();

      final createButton = find.widgetWithText(ElevatedButton, 'Create Wallet');
      await tester.tap(createButton);
      await tester.pumpAndSettle();

      expect(addCallCount, 1);
      expect(addedWallet, isNotNull);
      expect(addedWallet!.name, 'Vacation Fund');
      expect(addedWallet!.icon, 'savings');
      expect(addedWallet!.isDefault, false);

      // Sheet is closed
      expect(find.byType(AddWalletSheet), findsNothing);
    });

    testWidgets('17. when addWallet throws, sheet stays open and error SnackBar is shown',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(
          wallets: [],
          onAddWallet: (wallet) async {
            throw WalletException(
              WalletErrorType.networkError,
              message: 'Network failed',
            );
          },
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Emergency Fund');
      await tester.pumpAndSettle();

      final createButton = find.widgetWithText(ElevatedButton, 'Create Wallet');
      await tester.tap(createButton);
      await tester.pumpAndSettle();

      // Sheet stays open
      expect(find.byType(AddWalletSheet), findsOneWidget);

      // SnackBar shown with translated error message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Network error. Please check your connection.'),
        findsOneWidget,
      );
    });
  });
}
