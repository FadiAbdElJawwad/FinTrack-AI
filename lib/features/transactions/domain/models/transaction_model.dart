import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/timestamp_converter.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

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
    return [
      TransactionCategory.salary,
      TransactionCategory.other,
    ];
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
    required double amount,
    required TransactionType type,
    required TransactionCategory category,
    required String title,
    @TimestampConverter() required DateTime date,
  }) = _TransactionModel;

  const TransactionModel._();

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}
