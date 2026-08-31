import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fin_track_ai/main.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: FinTrackApp()));

    // Basic check to see if the app loads
    expect(find.byType(FinTrackApp), findsOneWidget);
  });
}
