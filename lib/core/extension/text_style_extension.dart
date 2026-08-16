import 'package:flutter/material.dart';

extension TextStyleExtension on BuildContext {
  double get textScaleFactor {
    final width = MediaQuery
        .sizeOf(this)
        .width;
    return (width / 390).clamp(
      1.0,
      1.4,
    );
  }

  TextStyle _responsive(TextStyle style) {
    return style.copyWith(fontSize: style.fontSize! * textScaleFactor);
  }

  TextStyle get displayLarge =>
      _responsive(Theme
          .of(this)
          .textTheme
          .displayLarge!);

  TextStyle get headlineMedium =>
      _responsive(Theme
          .of(this)
          .textTheme
          .headlineMedium!);

  TextStyle get bodyMedium =>
      _responsive(Theme
          .of(this)
          .textTheme
          .bodyMedium!);

  TextStyle get labelLarge =>
      _responsive(Theme
          .of(this)
          .textTheme
          .labelLarge!);

// // H1 styles
// TextStyle get h1Bold34 => _responsive(Theme.of(this).textTheme.displayLarge!);
// TextStyle get h1Regular34 =>
//     _responsive(Theme.of(this).textTheme.displayMedium!);
// TextStyle get h1Bold28 => _responsive(Theme.of(this).textTheme.displaySmall!);
// TextStyle get h1Regular28 =>
//     _responsive(Theme.of(this).textTheme.headlineLarge!);
//
// // H2 styles
// TextStyle get h2Bold26 =>
//     _responsive(Theme.of(this).textTheme.headlineMedium!);
// TextStyle get h2Bold22 =>
//     _responsive(Theme.of(this).textTheme.headlineSmall!);
// TextStyle get h2Regular26 =>
//     _responsive(Theme.of(this).textTheme.titleLarge!);
// TextStyle get h2Regular22 =>
//     _responsive(Theme.of(this).textTheme.titleMedium!);
//
// // Title styles
// TextStyle get titleBold18 =>
//     _responsive(Theme.of(this).textTheme.titleSmall!);
// TextStyle get titleRegular18 =>
//     _responsive(Theme.of(this).textTheme.bodyLarge!);
//
// // Button styles
// TextStyle get buttonBold => _responsive(Theme.of(this).textTheme.labelLarge!);
// TextStyle get buttonRegular =>
//     _responsive(Theme.of(this).textTheme.labelMedium!);
//
// // Input styles
// TextStyle get inputBold16 =>
//     _responsive(Theme.of(this).textTheme.labelLarge!);
// TextStyle get inputRegular16 =>
//     _responsive(Theme.of(this).textTheme.labelMedium!);
// TextStyle get inputBold14 =>
//     _responsive(Theme.of(this).textTheme.labelSmall!);
// TextStyle get inputRegular14 =>
//     _responsive(Theme.of(this).textTheme.bodySmall!);
//
// TextStyle get inputBold12 => _responsive(
//   Theme.of(
//     this,
//   ).textTheme.bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.bold,),
// );
// TextStyle get inputRegular12 => _responsive(
//   Theme.of(this).textTheme.bodySmall!.copyWith(
//     fontSize: 12,
//     fontWeight: FontWeight.normal,
//   ),
// );
//
// // Body styles
// TextStyle get bodyBold => _responsive(Theme.of(this).textTheme.bodyMedium!);
// TextStyle get bodyRegular => _responsive(Theme.of(this).textTheme.bodySmall!);
}
