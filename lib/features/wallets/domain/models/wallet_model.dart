import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
abstract class WalletModel with _$WalletModel {
  const factory WalletModel({
    String? id,
    required String name,
    required String icon,
    @Default(false) bool isDefault,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);
}
