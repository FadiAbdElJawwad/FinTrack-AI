import 'package:flutter/material.dart';

import '../../../../core/extension/app_sizes.dart';
import '../../../../core/widgets/skeleton_block.dart';
import '../../../../core/widgets/skeleton_shimmer.dart';

class WalletsSkeleton extends StatelessWidget {
  const WalletsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.addVerticalSpace(16),
            const SkeletonBlock(height: 110, radius: 24),
            context.addVerticalSpace(16),
            const SkeletonBlock(width: 200, height: 14, radius: 4),
            context.addVerticalSpace(24),
            const SkeletonBlock(width: 120, height: 18, radius: 4),
            context.addVerticalSpace(12),
            ...List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const SkeletonBlock(width: 48, height: 48, radius: 24),
                    context.addHorizontalSpace(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SkeletonBlock(
                            width: 100,
                            height: 14,
                            radius: 4,
                          ),
                          context.addVerticalSpace(6),
                          const SkeletonBlock(width: 60, height: 10, radius: 4),
                        ],
                      ),
                    ),
                    const SkeletonBlock(width: 60, height: 16, radius: 4),
                  ],
                ),
              ),
            ),
            context.addVerticalSpace(80),
          ],
        ).padSymmetric(20),
      ),
    );
  }
}
