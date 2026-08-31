// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      photoUrl: json['photoUrl'] as String?,
      totalBalance: (json['totalBalance'] as num?)?.toDouble() ?? 0.0,
      baseCurrency: json['baseCurrency'] as String? ?? 'USD',
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'fullName': instance.fullName,
      'photoUrl': instance.photoUrl,
      'totalBalance': instance.totalBalance,
      'baseCurrency': instance.baseCurrency,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
