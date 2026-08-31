// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DashboardState {
  Map<String, List<TransactionModel>> get groupedTransactions =>
      throw _privateConstructorUsedError;
  double get totalIncome => throw _privateConstructorUsedError;
  double get totalExpense => throw _privateConstructorUsedError;
  double get currentBalance => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DashboardStateCopyWith<DashboardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStateCopyWith<$Res> {
  factory $DashboardStateCopyWith(
    DashboardState value,
    $Res Function(DashboardState) then,
  ) = _$DashboardStateCopyWithImpl<$Res, DashboardState>;
  @useResult
  $Res call({
    Map<String, List<TransactionModel>> groupedTransactions,
    double totalIncome,
    double totalExpense,
    double currentBalance,
  });
}

/// @nodoc
class _$DashboardStateCopyWithImpl<$Res, $Val extends DashboardState>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupedTransactions = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? currentBalance = null,
  }) {
    return _then(
      _value.copyWith(
            groupedTransactions: null == groupedTransactions
                ? _value.groupedTransactions
                : groupedTransactions // ignore: cast_nullable_to_non_nullable
                      as Map<String, List<TransactionModel>>,
            totalIncome: null == totalIncome
                ? _value.totalIncome
                : totalIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            totalExpense: null == totalExpense
                ? _value.totalExpense
                : totalExpense // ignore: cast_nullable_to_non_nullable
                      as double,
            currentBalance: null == currentBalance
                ? _value.currentBalance
                : currentBalance // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardStateImplCopyWith<$Res>
    implements $DashboardStateCopyWith<$Res> {
  factory _$$DashboardStateImplCopyWith(
    _$DashboardStateImpl value,
    $Res Function(_$DashboardStateImpl) then,
  ) = __$$DashboardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Map<String, List<TransactionModel>> groupedTransactions,
    double totalIncome,
    double totalExpense,
    double currentBalance,
  });
}

/// @nodoc
class __$$DashboardStateImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardStateImpl>
    implements _$$DashboardStateImplCopyWith<$Res> {
  __$$DashboardStateImplCopyWithImpl(
    _$DashboardStateImpl _value,
    $Res Function(_$DashboardStateImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupedTransactions = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? currentBalance = null,
  }) {
    return _then(
      _$DashboardStateImpl(
        groupedTransactions: null == groupedTransactions
            ? _value._groupedTransactions
            : groupedTransactions // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<TransactionModel>>,
        totalIncome: null == totalIncome
            ? _value.totalIncome
            : totalIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        totalExpense: null == totalExpense
            ? _value.totalExpense
            : totalExpense // ignore: cast_nullable_to_non_nullable
                  as double,
        currentBalance: null == currentBalance
            ? _value.currentBalance
            : currentBalance // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$DashboardStateImpl implements _DashboardState {
  const _$DashboardStateImpl({
    final Map<String, List<TransactionModel>> groupedTransactions = const {},
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.currentBalance = 0.0,
  }) : _groupedTransactions = groupedTransactions;

  final Map<String, List<TransactionModel>> _groupedTransactions;
  @override
  @JsonKey()
  Map<String, List<TransactionModel>> get groupedTransactions {
    if (_groupedTransactions is EqualUnmodifiableMapView)
      return _groupedTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_groupedTransactions);
  }

  @override
  @JsonKey()
  final double totalIncome;
  @override
  @JsonKey()
  final double totalExpense;
  @override
  @JsonKey()
  final double currentBalance;

  @override
  String toString() {
    return 'DashboardState(groupedTransactions: $groupedTransactions, totalIncome: $totalIncome, totalExpense: $totalExpense, currentBalance: $currentBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStateImpl &&
            const DeepCollectionEquality().equals(
              other._groupedTransactions,
              _groupedTransactions,
            ) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.currentBalance, currentBalance) ||
                other.currentBalance == currentBalance));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_groupedTransactions),
    totalIncome,
    totalExpense,
    currentBalance,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStateImplCopyWith<_$DashboardStateImpl> get copyWith =>
      __$$DashboardStateImplCopyWithImpl<_$DashboardStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DashboardState implements DashboardState {
  const factory _DashboardState({
    final Map<String, List<TransactionModel>> groupedTransactions,
    final double totalIncome,
    final double totalExpense,
    final double currentBalance,
  }) = _$DashboardStateImpl;

  @override
  Map<String, List<TransactionModel>> get groupedTransactions;
  @override
  double get totalIncome;
  @override
  double get totalExpense;
  @override
  double get currentBalance;
  @override
  @JsonKey(ignore: true)
  _$$DashboardStateImplCopyWith<_$DashboardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
