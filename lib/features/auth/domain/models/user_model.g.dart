// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String,
  photoUrl: json['photoUrl'] as String?,
  baseCurrency: json['baseCurrency'] as String? ?? 'USD',
  createdAt: createdAtFromJson(json['createdAt']),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'fullName': instance.fullName,
      'photoUrl': instance.photoUrl,
      'baseCurrency': instance.baseCurrency,
      'createdAt': createdAtToJson(instance.createdAt),
    };
