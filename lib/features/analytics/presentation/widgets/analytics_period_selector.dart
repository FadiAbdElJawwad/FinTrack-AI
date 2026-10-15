import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/extension/app_sizes.dart';
import '../../../../core/widgets/app_chip_selector.dart';
import '../../../transactions/domain/transaction_limits.dart';
import '../../domain/models/analytics_period.dart';
import '../state/analytics_providers.dart';

class AnalyticsPeriodSelector extends ConsumerWidget {
  const AnalyticsPeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(analyticsPeriodProvider);

    return AppChipSelector<AnalyticsPeriod>(
      items: AnalyticsPeriod.values,
      isSelected: (period) => period == selectedPeriod,
      labelBuilder: (period) {
        switch (period) {
          case AnalyticsPeriod.week:
            return context.loc.analyticsPeriodWeek;
          case AnalyticsPeriod.month:
            return context.loc.analyticsPeriodMonth;
          case AnalyticsPeriod.year:
            return context.loc.analyticsPeriodYear(transactionWindowMonths);
        }
      },
      onSelect: (period) {
        ref.read(analyticsPeriodProvider.notifier).state = period;
      },
    );
  }
}
