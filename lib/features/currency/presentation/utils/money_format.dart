import 'package:intl/intl.dart';

import '../../domain/models/app_currency.dart';

/// Formats [minor] units of [currency] with its symbol and exactly
/// [AppCurrency.decimals] fraction digits.
///
/// The single division to a double is display-only; amounts are bounded by
/// `maxMinorUnits`, well within double precision.
String formatMoney(int minor, AppCurrency currency) {
  return NumberFormat.currency(
    symbol: currency.symbol,
    decimalDigits: currency.decimals,
  ).format(minor / currency.minorFactor);
}
