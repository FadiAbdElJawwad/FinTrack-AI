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

 Map<String, List<TransactionModel>> get groupedTransactions; double get totalIncome; double get totalExpense; double get currentBalance;
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStateCopyWith<DashboardState> get copyWith => _$DashboardStateCopyWithImpl<DashboardState>(this as DashboardState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardState&&const DeepCollectionEquality().equals(other.groupedTransactions, _this.groupedTransactions)&&(identical(other.totalIncome, _this.totalIncome) || other.totalIncome == _this.totalIncome)&&(identical(other.totalExpense, _this.totalExpense) || other.totalExpense == _this.totalExpense)&&(identical(other.currentBalance, _this.currentBalance) || other.currentBalance == _this.currentBalance));
}


@override
int get hashCode {
  final _this = this as DashboardState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.groupedTransactions),_this.totalIncome,_this.totalExpense,_this.currentBalance);
}

@override
String toString() {
  final _this = this as DashboardState;
  return 'DashboardState(groupedTransactions: ${_this.groupedTransactions}, totalIncome: ${_this.totalIncome}, totalExpense: ${_this.totalExpense}, currentBalance: ${_this.currentBalance})';
}


}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res>  {
  factory $DashboardStateCopyWith(DashboardState value, $Res Function(DashboardState) _then) = _$DashboardStateCopyWithImpl;
@useResult
$Res call({
 Map<String, List<TransactionModel>> groupedTransactions, double totalIncome, double totalExpense, double currentBalance
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
@pragma('vm:prefer-inline') @override $Res call({Object? groupedTransactions = null,Object? totalIncome = null,Object? totalExpense = null,Object? currentBalance = null,}) {
  return _then(DashboardState(
groupedTransactions: null == groupedTransactions ? _self.groupedTransactions : groupedTransactions // ignore: cast_nullable_to_non_nullable
as Map<String, List<TransactionModel>>,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as double,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, List<TransactionModel>> groupedTransactions,  double totalIncome,  double totalExpense,  double currentBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.groupedTransactions,_that.totalIncome,_that.totalExpense,_that.currentBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, List<TransactionModel>> groupedTransactions,  double totalIncome,  double totalExpense,  double currentBalance)  $default,) {final _that = this;
switch (_that) {
case _DashboardState():
return $default(_that.groupedTransactions,_that.totalIncome,_that.totalExpense,_that.currentBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, List<TransactionModel>> groupedTransactions,  double totalIncome,  double totalExpense,  double currentBalance)?  $default,) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.groupedTransactions,_that.totalIncome,_that.totalExpense,_that.currentBalance);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardState extends DashboardState {
  const _DashboardState({ Map<String, List<TransactionModel>> groupedTransactions = const {}, this.totalIncome = 0.0, this.totalExpense = 0.0, this.currentBalance = 0.0}): _groupedTransactions = groupedTransactions,super._();
  

 final  Map<String, List<TransactionModel>> _groupedTransactions;
@override@JsonKey() Map<String, List<TransactionModel>> get groupedTransactions {
  if (_groupedTransactions is EqualUnmodifiableMapView) return _groupedTransactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_groupedTransactions);
}

@override@JsonKey() final  double totalIncome;
@override@JsonKey() final  double totalExpense;
@override@JsonKey() final  double currentBalance;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStateCopyWith<_DashboardState> get copyWith => __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardState&&const DeepCollectionEquality().equals(other.groupedTransactions, _groupedTransactions)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_groupedTransactions),totalIncome,totalExpense,currentBalance);
}

@override
String toString() {
    return 'DashboardState(groupedTransactions: $groupedTransactions, totalIncome: $totalIncome, totalExpense: $totalExpense, currentBalance: $currentBalance)';
}


}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(_DashboardState value, $Res Function(_DashboardState) _then) = __$DashboardStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, List<TransactionModel>> groupedTransactions, double totalIncome, double totalExpense, double currentBalance
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
@override @pragma('vm:prefer-inline') $Res call({Object? groupedTransactions = null,Object? totalIncome = null,Object? totalExpense = null,Object? currentBalance = null,}) {
  return _then(_DashboardState(
groupedTransactions: null == groupedTransactions ? _self._groupedTransactions : groupedTransactions // ignore: cast_nullable_to_non_nullable
as Map<String, List<TransactionModel>>,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
