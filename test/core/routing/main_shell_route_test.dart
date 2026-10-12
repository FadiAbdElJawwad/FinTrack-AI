import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fin_track_ai/l10n/app_localizations.dart';

import 'package:fin_track_ai/core/routing/main_shell_route.dart';
import 'package:fin_track_ai/core/routing/app_routes.dart';
import 'package:fin_track_ai/core/theme/app_theme.dart';
import 'package:fin_track_ai/features/shell/presentation/widgets/main_bottom_nav_bar.dart';

void main() {
  Widget buildTestApp({
    Locale locale = const Locale('en'),
    Widget Function(BuildContext, GoRouterState)? homeBuilder,
  }) {
    final router = GoRouter(
      initialLocation: AppRoutes.homeScreen,
      routes: [
        buildMainShellRoute(
          homeBuilder: homeBuilder ??
              (context, state) => const Scaffold(body: Text('Home Content')),
        ),
        GoRoute(
          path: '/testDetails',
          builder: (context, state) => const Scaffold(
            body: Text('Details View'),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: AppTheme.lightTheme(locale.languageCode),
    );
  }

  testWidgets('1. Initial state: four English labels are visible and Home is shown',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Home Content'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Wallets'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('2. Tapping Analytics, Wallets, Settings shows each placeholder (its AppBar title)',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Tap Analytics
    await tester.tap(find.text('Analytics'));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Analytics')), findsOneWidget);

    // Tap Wallets
    await tester.tap(find.text('Wallets'));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Wallets')), findsOneWidget);

    // Tap Settings
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Settings')), findsOneWidget);
  });

  testWidgets('3. State is preserved: increment Home counter, go to Wallets, return to Home',
      (WidgetTester tester) async {
    int counter = 0;
    await tester.pumpWidget(
      buildTestApp(
        homeBuilder: (context, state) => StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Column(
              children: [
                Text('Counter: $counter'),
                ElevatedButton(
                  onPressed: () => setState(() => counter++),
                  child: const Text('Increment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Counter: 0'), findsOneWidget);
    await tester.tap(find.text('Increment'));
    await tester.pump();
    expect(find.text('Counter: 1'), findsOneWidget);

    // Go to Wallets
    await tester.tap(find.text('Wallets'));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Wallets')), findsOneWidget);

    // Return to Home
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Counter: 1'), findsOneWidget);
  });

  testWidgets('4. Back from a non-Home tab returns to Home; a second back from Home pops',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Go to Settings
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Settings')), findsOneWidget);

    // Trigger system back
    final dynamic widgetsBinding = tester.binding;
    bool didPop = await widgetsBinding.handlePopRoute();
    await tester.pumpAndSettle();

    // Should return true (handled) and show Home
    expect(didPop, true);
    expect(find.text('Home Content'), findsOneWidget);

    // Second back
    didPop = await widgetsBinding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(didPop, false); // Not handled, would exit app
  });

  testWidgets('5. A top-level route pushed from the shell is shown WITHOUT MainBottomNavBar',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestApp(
        homeBuilder: (context, state) => Scaffold(
          body: ElevatedButton(
            onPressed: () => context.push('/testDetails'),
            child: const Text('Push Details'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MainBottomNavBar), findsOneWidget);

    // Push details
    await tester.tap(find.text('Push Details'));
    await tester.pumpAndSettle();

    expect(find.text('Details View'), findsOneWidget);
    expect(find.byType(MainBottomNavBar), findsNothing);

    // Pop back
    final dynamic widgetsBinding = tester.binding;
    await widgetsBinding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(MainBottomNavBar), findsOneWidget);
  });

  testWidgets('6. Arabic: with locale: Locale("ar") the four Arabic labels are shown',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('التحليلات'), findsOneWidget);
    expect(find.text('المحافظ'), findsOneWidget);
    expect(find.text('الإعدادات'), findsOneWidget);
  });

  testWidgets('7. The active tab is exposed via Semantics selected state',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    Semantics getSemanticsWidget(String label) {
      return tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == label,
        ).first,
      );
    }

    expect(getSemanticsWidget('Home').properties.selected, isTrue);
    expect(getSemanticsWidget('Analytics').properties.selected, isFalse);

    // Tap Analytics
    await tester.tap(find.text('Analytics'));
    await tester.pumpAndSettle();

    expect(getSemanticsWidget('Home').properties.selected, isFalse);
    expect(getSemanticsWidget('Analytics').properties.selected, isTrue);
  });
}
