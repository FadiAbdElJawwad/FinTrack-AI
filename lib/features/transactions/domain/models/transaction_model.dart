import 'package:freezed_annotation/freezed_annotation.dart';
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

/// Pure-Dart JSON codec for [TransactionModel.date].
///
/// Wire format is an ISO-8601 `String`, byte-for-byte identical to the
/// previously generated codec. Firestore `Timestamp` coercion is a Data-layer
/// concern and never leaks into Domain models.
DateTime dateFromJson(Object? json) {
  if (json is String) return DateTime.parse(json);
  if (json is DateTime) return json;
  throw FormatException('Expected date to be an ISO-8601 string, got: $json');
}

String dateToJson(DateTime date) => date.toIso8601String();

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    String? id,
    required double amount,
    required TransactionType type,
    required TransactionCategory category,
    required String title,
    @JsonKey(fromJson: dateFromJson, toJson: dateToJson) required DateTime date,
    @JsonKey(defaultValue: '') required String walletId,
  }) = _TransactionModel;

  const TransactionModel._();

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}
