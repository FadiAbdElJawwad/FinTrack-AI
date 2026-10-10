import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

extension AppSizes on BuildContext {
  double get getWidth => MediaQuery.sizeOf(this).width;
  double get getHeight => MediaQuery.sizeOf(this).height;

  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;

  double wp(double percentage) => width * (percentage / 100);
  double hp(double percentage) => height * (percentage / 100);

  AppLocalizations get loc => AppLocalizations.of(this);

  bool get isSmallScreen => MediaQuery.sizeOf(this).height < 690;

  SizedBox addHorizontalSpace(double value) {
    return SizedBox(width: MediaQuery.sizeOf(this).width * (value / 360));
  }

  SizedBox addVerticalSpace(double value) {
    return SizedBox(height: MediaQuery.sizeOf(this).height * (value / 800));
  }

  double screenWidth(double value) {
    return MediaQuery.sizeOf(this).width * (value / 360);
  }

  double screenHeight(double value) {
    return MediaQuery.sizeOf(this).height * (value / 800);
  }

  EdgeInsets spaceAroundAll(double value) {
    return EdgeInsets.all(value);
  }

  EdgeInsets spaceHorizontal(double value) {
    return EdgeInsets.symmetric(
      horizontal: MediaQuery.sizeOf(this).width * (value / 360),
    );
  }

  EdgeInsets spaceVertical(double value) {
    return EdgeInsets.symmetric(
      vertical: MediaQuery.sizeOf(this).height * (value / 800),
    );
  }

  EdgeInsets spaceSymmetric({
    required double vertical,
    required double horizontal,
  }) {
    return EdgeInsets.symmetric(
      horizontal: MediaQuery.sizeOf(this).width * (horizontal / 360),
      vertical: MediaQuery.sizeOf(this).height * (vertical / 800),
    );
  }

  EdgeInsetsDirectional spaceTop(double value) {
    return EdgeInsetsDirectional.only(
      top: MediaQuery.sizeOf(this).height * (value / 800),
    );
  }

  EdgeInsetsDirectional spaceBottom(double value) {
    return EdgeInsetsDirectional.only(
      bottom: MediaQuery.sizeOf(this).height * (value / 800),
    );
  }

  EdgeInsetsDirectional spaceStart(double value) {
    return EdgeInsetsDirectional.only(
      start: MediaQuery.sizeOf(this).width * (value / 360),
    );
  }

  EdgeInsetsDirectional spaceEnd(double value) {
    return EdgeInsetsDirectional.only(
      end: MediaQuery.sizeOf(this).width * (value / 360),
    );
  }

  BorderRadius circularRadius(double value) {
    return BorderRadius.circular(value);
  }

  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;
}

extension LayoutExtensions on Widget {
  Widget pad([double value = 8.0]) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget padTop([double value = 8.0]) => Padding(
    padding: EdgeInsets.only(top: value),
    child: this,
  );
  Widget padStart([double value = 8.0]) => Padding(
    padding: EdgeInsetsDirectional.only(start: value),
    child: this,
  );

  Widget padEnd([double value = 20]) => Padding(
    padding: EdgeInsetsDirectional.only(end: value),
    child: this,
  );
  Widget padBottom([double value = 8.0]) => Padding(
    padding: EdgeInsets.only(bottom: value),
    child: this,
  );
  Widget center() => Center(child: this);

  Widget padSymmetric(double value) => Padding(
    padding: EdgeInsetsDirectional.symmetric(horizontal: value),
    child: this,
  );
  Widget padVerticalSymmetric(double value) => Padding(
    padding: EdgeInsetsDirectional.symmetric(vertical: value),
    child: this,
  );
}
