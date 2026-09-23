// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionModel {

 String? get id; double get amount; TransactionType get type; TransactionCategory get category; String get title;@JsonKey(fromJson: dateFromJson, toJson: dateToJson) DateTime get date;@JsonKey(defaultValue: '') String get walletId;
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionModelCopyWith<TransactionModel> get copyWith => _$TransactionModelCopyWithImpl<TransactionModel>(this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransactionModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.walletId, _this.walletId) || other.walletId == _this.walletId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransactionModel;
  return Object.hash(runtimeType,_this.id,_this.amount,_this.type,_this.category,_this.title,_this.date,_this.walletId);
}

@override
String toString() {
  final _this = this as TransactionModel;
  return 'TransactionModel(id: ${_this.id}, amount: ${_this.amount}, type: ${_this.type}, category: ${_this.category}, title: ${_this.title}, date: ${_this.date}, walletId: ${_this.walletId})';
}


}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res>  {
  factory $TransactionModelCopyWith(TransactionModel value, $Res Function(TransactionModel) _then) = _$TransactionModelCopyWithImpl;
@useResult
$Res call({
 String? id, double amount, TransactionType type, TransactionCategory category, String title,@JsonKey(fromJson: dateFromJson, toJson: dateToJson) DateTime date,@JsonKey(defaultValue: '') String walletId
});




}
/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? amount = null,Object? type = null,Object? category = null,Object? title = null,Object? date = null,Object? walletId = null,}) {
  return _then(TransactionModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionModel].
extension TransactionModelPatterns on TransactionModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  double amount,  TransactionType type,  TransactionCategory category,  String title, @JsonKey(fromJson: dateFromJson, toJson: dateToJson)  DateTime date, @JsonKey(defaultValue: '')  String walletId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.amount,_that.type,_that.category,_that.title,_that.date,_that.walletId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  double amount,  TransactionType type,  TransactionCategory category,  String title, @JsonKey(fromJson: dateFromJson, toJson: dateToJson)  DateTime date, @JsonKey(defaultValue: '')  String walletId)  $default,) {final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that.id,_that.amount,_that.type,_that.category,_that.title,_that.date,_that.walletId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  double amount,  TransactionType type,  TransactionCategory category,  String title, @JsonKey(fromJson: dateFromJson, toJson: dateToJson)  DateTime date, @JsonKey(defaultValue: '')  String walletId)?  $default,) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.amount,_that.type,_that.category,_that.title,_that.date,_that.walletId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionModel extends TransactionModel {
  const _TransactionModel({this.id, required this.amount, required this.type, required this.category, required this.title, @JsonKey(fromJson: dateFromJson, toJson: dateToJson) required this.date, @JsonKey(defaultValue: '') required this.walletId}): super._();
  factory _TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

@override final  String? id;
@override final  double amount;
@override final  TransactionType type;
@override final  TransactionCategory category;
@override final  String title;
@override@JsonKey(fromJson: dateFromJson, toJson: dateToJson) final  DateTime date;
@override@JsonKey(defaultValue: '') final  String walletId;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionModelCopyWith<_TransactionModel> get copyWith => __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.walletId, walletId) || other.walletId == walletId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,amount,type,category,title,date,walletId);
}

@override
String toString() {
    return 'TransactionModel(id: $id, amount: $amount, type: $type, category: $category, title: $title, date: $date, walletId: $walletId)';
}


}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res> implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(_TransactionModel value, $Res Function(_TransactionModel) _then) = __$TransactionModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, double amount, TransactionType type, TransactionCategory category, String title,@JsonKey(fromJson: dateFromJson, toJson: dateToJson) DateTime date,@JsonKey(defaultValue: '') String walletId
});




}
/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? amount = null,Object? type = null,Object? category = null,Object? title = null,Object? date = null,Object? walletId = null,}) {
  return _then(_TransactionModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
