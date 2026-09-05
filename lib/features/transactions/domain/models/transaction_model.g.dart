// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: json['id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      category: $enumDecode(_$TransactionCategoryEnumMap, json['category']),
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'category': _$TransactionCategoryEnumMap[instance.category]!,
      'title': instance.title,
      'date': instance.date.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};

const _$TransactionCategoryEnumMap = {
  TransactionCategory.food: 'food',
  TransactionCategory.transport: 'transport',
  TransactionCategory.shopping: 'shopping',
  TransactionCategory.salary: 'salary',
  TransactionCategory.entertainment: 'entertainment',
  TransactionCategory.other: 'other',
};
