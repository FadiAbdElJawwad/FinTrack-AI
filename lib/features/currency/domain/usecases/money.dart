import '../models/app_currency.dart';

/// Largest accepted amount, in minor units.
const int maxMinorUnits = 1000000000000;

final RegExp _amountPattern = RegExp(r'^(\d*)(?:\.(\d*))?$');

/// Parses user input into minor units of [currency], without floating point.
///
/// Accepts ASCII digits with at most one `.`. `".5"` and `"1."` are accepted
/// (an empty side counts as zero), but a lone `"."` is not. Rejects empty
/// input, signs, exponents, `NaN`/`Infinity`, grouping separators, more
/// fraction digits than [AppCurrency.decimals] (never rounds), and values
/// above [maxMinorUnits]. Returns `null` when invalid.
int? parseMinorUnits(String text, AppCurrency currency) {
  final match = _amountPattern.firstMatch(text.trim());
  if (match == null) return null;

  final whole = match.group(1)!;
  final fraction = match.group(2) ?? '';
  if (whole.isEmpty && fraction.isEmpty) return null;
  if (fraction.length > currency.decimals) return null;

  final trimmedWhole = whole.replaceFirst(RegExp(r'^0+'), '');
  // 13 digits already exceed the cap for every currency; avoids overflow.
  if (trimmedWhole.length > 13) return null;

  final wholeValue = trimmedWhole.isEmpty ? 0 : int.parse(trimmedWhole);
  final fractionValue = int.parse(fraction.padRight(currency.decimals, '0'));
  final minor = wholeValue * currency.minorFactor + fractionValue;

  return minor > maxMinorUnits ? null : minor;
}

/// Exact decimal text of [minor] in [currency], without grouping or symbol.
///
/// Always prints [AppCurrency.decimals] fraction digits, so the result
/// round-trips through [parseMinorUnits].
String minorToPlainText(int minor, AppCurrency currency) {
  final sign = minor < 0 ? '-' : '';
  final absolute = minor.abs();
  final whole = absolute ~/ currency.minorFactor;
  final fraction = (absolute % currency.minorFactor).toString().padLeft(
    currency.decimals,
    '0',
  );
  return '$sign$whole.$fraction';
}

/// Converts [minor] units of [from] into minor units of [to] using [rate]
/// (one unit of [from] = [rate] units of [to]).
///
/// Rounds half away from zero to the target minor unit. When [from] equals
/// [to] the amount is returned unchanged and [rate] is ignored. Uses double
/// arithmetic, so it is meant for display-time conversion only.
int convertMinorUnits(
  int minor,
  AppCurrency from,
  AppCurrency to,
  double rate,
) {
  if (from == to) return minor;
  final converted = minor * rate * to.minorFactor / from.minorFactor;
  if (!converted.isFinite) {
    throw ArgumentError.value(rate, 'rate', 'conversion is not finite');
  }
  // double.round() rounds half away from zero.
  return converted.round();
}
