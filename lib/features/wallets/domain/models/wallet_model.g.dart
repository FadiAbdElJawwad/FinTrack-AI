// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => _WalletModel(
  id: json['id'] as String?,
  name: json['name'] as String,
  icon: json['icon'] as String,
  isDefault: json['isDefault'] as bool? ?? false,
);

Map<String, dynamic> _$WalletModelToJson(_WalletModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'isDefault': instance.isDefault,
    };
