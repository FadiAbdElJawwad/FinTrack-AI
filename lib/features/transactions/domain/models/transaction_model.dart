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
