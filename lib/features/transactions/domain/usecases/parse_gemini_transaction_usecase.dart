import '../../../../core/error/ai_parsing_exception.dart';
import '../models/transaction_model.dart';

TransactionDraft parseGeminiTransaction(Map<String, dynamic> result) {
  final rawAmount = result['amount'];
  double? amount;
  if (rawAmount is num) {
    amount = rawAmount.toDouble();
  } else if (rawAmount is String) {
    amount = double.tryParse(rawAmount);
  }

  if (amount == null || amount <= 0) {
    throw AiParsingException(
      AiParsingErrorType.schemaValidationFailed,
      message: 'Invalid or missing amount',
    );
  }

  final typeStr = result['type']?.toString().toLowerCase();
  final type = (typeStr == 'income')
      ? TransactionType.income
      : TransactionType.expense;

  final categoryStr = result['category']?.toString().toLowerCase();
  var category = TransactionCategory.values.firstWhere(
    (c) => c.name.toLowerCase() == categoryStr,
    orElse: () => TransactionCategory.other,
  );

  if (!categoriesForType(type).contains(category)) {
    category = TransactionCategory.other;
  }

  final title = result['title']?.toString() ?? '';

  final dateStr = result['date']?.toString();
  DateTime? date;
  if (dateStr != null && dateStr.isNotEmpty) {
    date = DateTime.tryParse(dateStr);
  }
  date ??= DateTime.now();

  return TransactionDraft(
    amount: amount,
    title: title,
    type: type,
    category: category,
    date: date,
  );
}