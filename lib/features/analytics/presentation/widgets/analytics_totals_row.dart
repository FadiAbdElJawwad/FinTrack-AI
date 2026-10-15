import 'package:flutter/material.dart';

import '../../../../core/constant/color_manager.dart';
import '../../../../core/extension/app_sizes.dart';
import '../../../currency/domain/models/app_currency.dart';
import 'analytics_amount_card.dart';

class AnalyticsTotalsRow extends StatelessWidget {
  final int? incomeMinor;
  final int? expenseMinor;
  final AppCurrency currency;

  const AnalyticsTotalsRow({
    super.key,
    required this.incomeMinor,
    required this.expenseMinor,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnalyticsAmountCard(
            label: context.loc.income,
            amountMinor: incomeMinor,
            currency: currency,
            sign: '+',
            color: ColorManager.successColor,
          ),
        ),
        context.addHorizontalSpace(12),
        Expanded(
          child: AnalyticsAmountCard(
            label: context.loc.expense,
            amountMinor: expenseMinor,
            currency: currency,
            sign: '-',
            color: ColorManager.errorColor,
          ),
        ),
      ],
    );
  }
}
