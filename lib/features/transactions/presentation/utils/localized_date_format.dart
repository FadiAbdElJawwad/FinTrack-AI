import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Maps Arabic-Indic digits (U+0660..U+0669) and Persian digits (U+06F0..U+06F9)
/// to Western Latin digits ('0'..'9').
String toWesternDigits(String input) {
  final buffer = StringBuffer();
  for (final char in input.runes) {
    if (char >= 0x0660 && char <= 0x0669) {
      buffer.writeCharCode(0x0030 + (char - 0x0660));
    } else if (char >= 0x06F0 && char <= 0x06F9) {
      buffer.writeCharCode(0x0030 + (char - 0x06F0));
    } else {
      buffer.writeCharCode(char);
    }
  }
  return buffer.toString();
}

/// Formats a date using [pattern] in the current [context] locale (or default locale
/// if no [Localizations] ancestor exists), then converts all digits to Western digits.
String formatLocalizedDate(
  BuildContext context,
  String pattern,
  DateTime date,
) {
  final locale = Localizations.maybeLocaleOf(context)?.toString();
  return toWesternDigits(DateFormat(pattern, locale).format(date));
}
