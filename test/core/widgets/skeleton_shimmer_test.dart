import 'package:fin_track_ai/core/widgets/skeleton_block.dart';
import 'package:fin_track_ai/core/widgets/skeleton_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('skeleton_shimmer and skeleton_block tests', () {
    testWidgets('SkeletonBlock renders with given width, height and radius', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonBlock(width: 150, height: 40, radius: 8),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      final container = tester.widget<Container>(containerFinder);
      expect(container.constraints?.minWidth, equals(150));
      expect(container.constraints?.minHeight, equals(40));
    });

    testWidgets(
      'SkeletonShimmer builds under light and dark themes without exception',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(
              body: SkeletonShimmer(
                child: SkeletonBlock(width: 100, height: 20),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(SkeletonShimmer), findsOneWidget);

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: const Scaffold(
              body: SkeletonShimmer(
                child: SkeletonBlock(width: 100, height: 20),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(SkeletonShimmer), findsOneWidget);
      },
    );
  });
}
