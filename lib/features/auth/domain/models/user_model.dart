import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Pure-Dart JSON codec for [UserModel.createdAt].
///
/// Accepts the scalar forms previously served by the Firestore-aware
/// converter (`String`, `num`, `DateTime`). Firestore `Timestamp` values must
/// be normalized in the Data layer before this codec runs.
DateTime? createdAtFromJson(Object? json) {
  if (json == null) return null;
  if (json is DateTime) return json;
  if (json is String) return DateTime.tryParse(json);
  if (json is num) return DateTime.fromMillisecondsSinceEpoch(json.toInt());
  return null;
}

Object? createdAtToJson(DateTime? date) => date;

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    required String fullName,
    String? photoUrl,
    @Default('USD') String baseCurrency,
    @JsonKey(fromJson: createdAtFromJson, toJson: createdAtToJson)
    DateTime? createdAt,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
