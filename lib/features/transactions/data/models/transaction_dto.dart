import '../../../currency/domain/models/app_currency.dart';
import '../../domain/models/transaction_model.dart';

/// Firestore wire representation of a transaction.
///
/// Wire format: `id` (String?), `amountMinor` (int), `currency` (ISO code),
/// `type` and `category` (enum names), `title`, `date` (ISO-8601 String),
/// `walletId` (String, defaults to ''). The legacy double `amount` field is
/// neither read nor written.
///
/// [TransactionDto.fromMap] is strict and throws a [FormatException] for a
/// malformed document; the repository skips such documents.
class TransactionDto {
  const TransactionDto({
    required this.id,
    required this.amountMinor,
    required this.currency,
    required this.type,
    required this.category,
    required this.title,
    required this.date,
    required this.walletId,
  });

  final String? id;
  final int amountMinor;
  final AppCurrency currency;
  final TransactionType type;
  final TransactionCategory category;
  final String title;
  final DateTime date;
  final String walletId;

  factory TransactionDto.fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    if (id != null && id is! String) {
      throw const FormatException('id is not a String');
    }

    final amountMinor = map['amountMinor'];
    if (amountMinor is! int) {
      throw FormatException(
        map.containsKey('amount') && !map.containsKey('amountMinor')
            ? 'legacy double amount without amountMinor'
            : 'amountMinor missing or not an int',
      );
    }

    final currencyCode = map['currency'];
    final currency = currencyCode is String
        ? appCurrencyTryFromCode(currencyCode)
        : null;
    if (currency == null) {
      throw FormatException('unknown currency: $currencyCode');
    }

    final type = _enumByName(TransactionType.values, map['type']);
    if (type == null) {
      throw FormatException('unknown type: ${map['type']}');
    }

    final category =
        _enumByName(TransactionCategory.values, map['category']) ??
        TransactionCategory.other;

    final title = map['title'];
    if (title is! String) {
      throw const FormatException('title missing or not a String');
    }

    final rawDate = map['date'];
    final date = rawDate is String ? DateTime.tryParse(rawDate) : null;
    if (date == null) {
      throw FormatException('date is not an ISO-8601 String: $rawDate');
    }

    final walletId = map['walletId'] ?? '';
    if (walletId is! String) {
      throw const FormatException('walletId is not a String');
    }

    return TransactionDto(
      id: id as String?,
      amountMinor: amountMinor,
      currency: currency,
      type: type,
      category: category,
      title: title,
      date: date,
      walletId: walletId,
    );
  }

  factory TransactionDto.fromModel(TransactionModel model) => TransactionDto(
    id: model.id,
    amountMinor: model.amountMinor,
    currency: model.currency,
    type: model.type,
    category: model.category,
    title: model.title,
    date: model.date,
    walletId: model.walletId,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'amountMinor': amountMinor,
    'currency': currency.code,
    'type': type.name,
    'category': category.name,
    'title': title,
    'date': date.toIso8601String(),
    'walletId': walletId,
  };

  TransactionModel toModel() => TransactionModel(
    id: id,
    amountMinor: amountMinor,
    currency: currency,
    type: type,
    category: category,
    title: title,
    date: date,
    walletId: walletId,
  );
}

T? _enumByName<T extends Enum>(List<T> values, Object? name) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}
