import 'package:flutter/material.dart';
import '../../../../core/extension/app_sizes.dart';
import '../../domain/models/transaction_model.dart';

extension TransactionCategoryExtension on TransactionCategory {
  IconData get icon {
    switch (this) {
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

  String getLocalizedName(BuildContext context) {
    switch (this) {
      case TransactionCategory.food:
        return context.loc.catFood;
      case TransactionCategory.transport:
        return context.loc.catTransport;
      case TransactionCategory.shopping:
        return context.loc.catShopping;
      case TransactionCategory.salary:
        return context.loc.catSalary;
      case TransactionCategory.entertainment:
        return context.loc.catEntertainment;
      case TransactionCategory.other:
        return context.loc.catOther;
    }
  }
}
