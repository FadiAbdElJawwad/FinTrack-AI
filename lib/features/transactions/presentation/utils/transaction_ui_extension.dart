import 'package:fin_track_ai/core/constant/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/transaction_model.dart';

extension TransactionUIExtension on TransactionModel {
  Color get amountColor => type == TransactionType.income
      ? ColorManager.successColor
      : ColorManager.errorColor;

  String get formattedAmount {
    final currency = NumberFormat.currency(symbol: '\$').format(amount);
    return type == TransactionType.income ? '+ $currency' : '- $currency';
  }

  String get formattedDate => DateFormat('MMM dd, hh:mm a').format(date);

  IconData get categoryIcon {
    switch (category) {
      case TransactionCategory.food:
        return Icons.restaurant;
      case TransactionCategory.transport:
        return Icons.directions_car;
      case TransactionCategory.shopping:
        return Icons.shopping_bag;
      case TransactionCategory.salary:
        return Icons.attach_money;
      case TransactionCategory.entertainment:
        return Icons.movie;
      case TransactionCategory.other:
        return Icons.category;
    }
  }
}
