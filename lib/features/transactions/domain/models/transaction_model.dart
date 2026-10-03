import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../currency/domain/models/app_currency.dart';

part 'transaction_model.freezed.dart';

enum TransactionType { income, expense }

enum TransactionCategory {
  food,
  transport,
  shopping,
  salary,
  entertainment,
  other,
}

List<TransactionCategory> categoriesForType(TransactionType type) {
  if (type == TransactionType.expense) {
    return [
      TransactionCategory.food,
      TransactionCategory.transport,
      TransactionCategory.shopping,
      TransactionCategory.entertainment,
      TransactionCategory.other,
    ];
  } else {
    return [TransactionCategory.salary, TransactionCategory.other];
  }
}

class TransactionDraft {
  final double amount;
  final String title;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime? date;

  const TransactionDraft({
    required this.amount,
    required this.title,
    required this.type,
    required this.category,
    this.date,
  });
}

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    String? id,

    /// Amount in minor units of [currency] (for example cents).
    required int amountMinor,

    /// Currency the amount was entered in; never converted when stored.
    required AppCurrency currency,
    required TransactionType type,
    required TransactionCategory category,
    required String title,
    required DateTime date,
    required String walletId,
  }) = _TransactionModel;

  const TransactionModel._();
}
