// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `FinTrack AI`
  String get appTitle {
    return Intl.message('FinTrack AI', name: 'appTitle', desc: '', args: []);
  }

  /// `Smart Financial Tracking`
  String get splashBody {
    return Intl.message(
      'Smart Financial Tracking',
      name: 'splashBody',
      desc: '',
      args: [],
    );
  }

  /// `Smart Financial Tracking`
  String get onboardingTitle1 {
    return Intl.message(
      'Smart Financial Tracking',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Connect your accounts and let our AI categorize every transaction automatically.`
  String get onboardingBody1 {
    return Intl.message(
      'Connect your accounts and let our AI categorize every transaction automatically.',
      name: 'onboardingBody1',
      desc: '',
      args: [],
    );
  }

  /// `AI-Powered Insights`
  String get onboardingTitle2 {
    return Intl.message(
      'AI-Powered Insights',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Scan receipts and get personalized advice to optimize your spending habits.`
  String get onboardingBody2 {
    return Intl.message(
      'Scan receipts and get personalized advice to optimize your spending habits.',
      name: 'onboardingBody2',
      desc: '',
      args: [],
    );
  }

  /// `Grow Your Wealth`
  String get onboardingTitle3 {
    return Intl.message(
      'Grow Your Wealth',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Set smart budgets and watch your savings grow with predictive financial planning.`
  String get onboardingBody3 {
    return Intl.message(
      'Set smart budgets and watch your savings grow with predictive financial planning.',
      name: 'onboardingBody3',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Sign Up`
  String get signup {
    return Intl.message('Sign Up', name: 'signup', desc: '', args: []);
  }

  /// `Forgot Password`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get email {
    return Intl.message('Email Address', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Welcome Back`
  String get loginTitle {
    return Intl.message('Welcome Back', name: 'loginTitle', desc: '', args: []);
  }

  /// `Create an Account`
  String get signupTitle {
    return Intl.message(
      'Create an Account',
      name: 'signupTitle',
      desc: '',
      args: [],
    );
  }

  /// `Log in to manage your portfolio`
  String get loginBody {
    return Intl.message(
      'Log in to manage your portfolio',
      name: 'loginBody',
      desc: '',
      args: [],
    );
  }

  /// `Log in with Fingerprint/FaceID`
  String get fingerPrintLogin {
    return Intl.message(
      'Log in with Fingerprint/FaceID',
      name: 'fingerPrintLogin',
      desc: '',
      args: [],
    );
  }

  /// `Enter your details to get started.`
  String get signupBody {
    return Intl.message(
      'Enter your details to get started.',
      name: 'signupBody',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get haveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email to receive a password reset link`
  String get resetPasswordBody {
    return Intl.message(
      'Enter your email to receive a password reset link',
      name: 'resetPasswordBody',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `Back to Login`
  String get backToLogin {
    return Intl.message(
      'Back to Login',
      name: 'backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `If this email is registered, a reset link has been sent.`
  String get resetPasswordSuccess {
    return Intl.message(
      'If this email is registered, a reset link has been sent.',
      name: 'resetPasswordSuccess',
      desc: '',
      args: [],
    );
  }

  /// `This field cannot be empty`
  String get fieldCannotBeEmpty {
    return Intl.message(
      'This field cannot be empty',
      name: 'fieldCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Name cannot be empty`
  String get emptyName {
    return Intl.message(
      'Name cannot be empty',
      name: 'emptyName',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty`
  String get emptyEmail {
    return Intl.message(
      'Email cannot be empty',
      name: 'emptyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email address',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get emptyPassword {
    return Intl.message(
      'Password cannot be empty',
      name: 'emptyPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long`
  String get invalidPassword {
    return Intl.message(
      'Password must be at least 6 characters long',
      name: 'invalidPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password cannot be the same as the current password`
  String get passwordSameAsCurrent {
    return Intl.message(
      'New password cannot be the same as the current password',
      name: 'passwordSameAsCurrent',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password cannot be empty`
  String get emptyConfirmPassword {
    return Intl.message(
      'Confirm Password cannot be empty',
      name: 'emptyConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `No user found with this email.`
  String get userNotFound {
    return Intl.message(
      'No user found with this email.',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password.`
  String get wrongPassword {
    return Intl.message(
      'Incorrect password.',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password.`
  String get invalidCredential {
    return Intl.message(
      'Invalid email or password.',
      name: 'invalidCredential',
      desc: '',
      args: [],
    );
  }

  /// `Email is already registered.`
  String get emailAlreadyInUse {
    return Intl.message(
      'Email is already registered.',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `The email address is invalid.`
  String get invalidEmailAuth {
    return Intl.message(
      'The email address is invalid.',
      name: 'invalidEmailAuth',
      desc: '',
      args: [],
    );
  }

  /// `The password is too weak.`
  String get weakPasswordAuth {
    return Intl.message(
      'The password is too weak.',
      name: 'weakPasswordAuth',
      desc: '',
      args: [],
    );
  }

  /// `This user account has been disabled.`
  String get userDisabled {
    return Intl.message(
      'This user account has been disabled.',
      name: 'userDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Too many attempts. Please try again later.`
  String get tooManyRequests {
    return Intl.message(
      'Too many attempts. Please try again later.',
      name: 'tooManyRequests',
      desc: '',
      args: [],
    );
  }

  /// `Network error. Please check your connection.`
  String get networkRequestFailed {
    return Intl.message(
      'Network error. Please check your connection.',
      name: 'networkRequestFailed',
      desc: '',
      args: [],
    );
  }

  /// `A database error occurred.`
  String get databaseError {
    return Intl.message(
      'A database error occurred.',
      name: 'databaseError',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred.`
  String get unknownError {
    return Intl.message(
      'An unexpected error occurred.',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication denied or cancelled.`
  String get biometricDenied {
    return Intl.message(
      'Biometric authentication denied or cancelled.',
      name: 'biometricDenied',
      desc: '',
      args: [],
    );
  }

  /// `No saved credentials found. Please log in with your email first.`
  String get noSavedCredentials {
    return Intl.message(
      'No saved credentials found. Please log in with your email first.',
      name: 'noSavedCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Enable Biometric Login`
  String get enableBiometricLogin {
    return Intl.message(
      'Enable Biometric Login',
      name: 'enableBiometricLogin',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get or {
    return Intl.message('OR', name: 'or', desc: '', args: []);
  }

  /// `Continue with Google`
  String get continueWithGoogle {
    return Intl.message(
      'Continue with Google',
      name: 'continueWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with another account`
  String get signInWithAnotherAccount {
    return Intl.message(
      'Sign in with another account',
      name: 'signInWithAnotherAccount',
      desc: '',
      args: [],
    );
  }

  /// `Unlock`
  String get unlock {
    return Intl.message('Unlock', name: 'unlock', desc: '', args: []);
  }

  /// `Google Sign-In was canceled.`
  String get googleSignInCanceled {
    return Intl.message(
      'Google Sign-In was canceled.',
      name: 'googleSignInCanceled',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
