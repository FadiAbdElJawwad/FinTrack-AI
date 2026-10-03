// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardState {

 Map<String, List<TransactionModel>> get groupedTransactions; AppCurrency get currency;/// Income in minor units of [currency]; `null` when a foreign-currency
/// part could not be converted because rates are unavailable.
 int? get incomeMinor;/// Expense in minor units of [currency]; `null` as for [incomeMinor].
 int? get expenseMinor;
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStateCopyWith<DashboardState> get copyWith => _$DashboardStateCopyWithImpl<DashboardState>(this as DashboardState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardState&&const DeepCollectionEquality().equals(other.groupedTransactions, _this.groupedTransactions)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.incomeMinor, _this.incomeMinor) || other.incomeMinor == _this.incomeMinor)&&(identical(other.expenseMinor, _this.expenseMinor) || other.expenseMinor == _this.expenseMinor));
}


@override
int get hashCode {
  final _this = this as DashboardState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.groupedTransactions),_this.currency,_this.incomeMinor,_this.expenseMinor);
}

@override
String toString() {
  final _this = this as DashboardState;
  return 'DashboardState(groupedTransactions: ${_this.groupedTransactions}, currency: ${_this.currency}, incomeMinor: ${_this.incomeMinor}, expenseMinor: ${_this.expenseMinor})';
}


}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res>  {
  factory $DashboardStateCopyWith(DashboardState value, $Res Function(DashboardState) _then) = _$DashboardStateCopyWithImpl;
@useResult
$Res call({
 Map<String, List<TransactionModel>> groupedTransactions, AppCurrency currency, int? incomeMinor, int? expenseMinor
});




}
/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupedTransactions = null,Object? currency = null,Object? incomeMinor = freezed,Object? expenseMinor = freezed,}) {
  return _then(DashboardState(
groupedTransactions: null == groupedTransactions ? _self.groupedTransactions : groupedTransactions // ignore: cast_nullable_to_non_nullable
as Map<String, List<TransactionModel>>,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as AppCurrency,incomeMinor: freezed == incomeMinor ? _self.incomeMinor : incomeMinor // ignore: cast_nullable_to_non_nullable
as int?,expenseMinor: freezed == expenseMinor ? _self.expenseMinor : expenseMinor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, List<TransactionModel>> groupedTransactions,  AppCurrency currency,  int? incomeMinor,  int? expenseMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.groupedTransactions,_that.currency,_that.incomeMinor,_that.expenseMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, List<TransactionModel>> groupedTransactions,  AppCurrency currency,  int? incomeMinor,  int? expenseMinor)  $default,) {final _that = this;
switch (_that) {
case _DashboardState():
return $default(_that.groupedTransactions,_that.currency,_that.incomeMinor,_that.expenseMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, List<TransactionModel>> groupedTransactions,  AppCurrency currency,  int? incomeMinor,  int? expenseMinor)?  $default,) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.groupedTransactions,_that.currency,_that.incomeMinor,_that.expenseMinor);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardState extends DashboardState {
  const _DashboardState({ Map<String, List<TransactionModel>> groupedTransactions = const {}, this.currency = AppCurrency.usd, this.incomeMinor, this.expenseMinor}): _groupedTransactions = groupedTransactions,super._();
  

 final  Map<String, List<TransactionModel>> _groupedTransactions;
@override@JsonKey() Map<String, List<TransactionModel>> get groupedTransactions {
  if (_groupedTransactions is EqualUnmodifiableMapView) return _groupedTransactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_groupedTransactions);
}

@override@JsonKey() final  AppCurrency currency;
/// Income in minor units of [currency]; `null` when a foreign-currency
/// part could not be converted because rates are unavailable.
@override final  int? incomeMinor;
/// Expense in minor units of [currency]; `null` as for [incomeMinor].
@override final  int? expenseMinor;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStateCopyWith<_DashboardState> get copyWith => __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardState&&const DeepCollectionEquality().equals(other.groupedTransactions, _groupedTransactions)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.incomeMinor, incomeMinor) || other.incomeMinor == incomeMinor)&&(identical(other.expenseMinor, expenseMinor) || other.expenseMinor == expenseMinor));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_groupedTransactions),currency,incomeMinor,expenseMinor);
}

@override
String toString() {
    return 'DashboardState(groupedTransactions: $groupedTransactions, currency: $currency, incomeMinor: $incomeMinor, expenseMinor: $expenseMinor)';
}


}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(_DashboardState value, $Res Function(_DashboardState) _then) = __$DashboardStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, List<TransactionModel>> groupedTransactions, AppCurrency currency, int? incomeMinor, int? expenseMinor
});




}
/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupedTransactions = null,Object? currency = null,Object? incomeMinor = freezed,Object? expenseMinor = freezed,}) {
  return _then(_DashboardState(
groupedTransactions: null == groupedTransactions ? _self._groupedTransactions : groupedTransactions // ignore: cast_nullable_to_non_nullable
as Map<String, List<TransactionModel>>,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as AppCurrency,incomeMinor: freezed == incomeMinor ? _self.incomeMinor : incomeMinor // ignore: cast_nullable_to_non_nullable
as int?,expenseMinor: freezed == expenseMinor ? _self.expenseMinor : expenseMinor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
