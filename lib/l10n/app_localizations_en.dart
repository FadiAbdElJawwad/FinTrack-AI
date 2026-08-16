// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FinTrack AI';

  @override
  String get splashBody => 'Smart Financial Tracking';

  @override
  String get onboardingTitle1 => 'Smart Financial Tracking';

  @override
  String get onboardingBody1 =>
      'Connect your accounts and let our AI categorize every transaction automatically.';

  @override
  String get onboardingTitle2 => 'AI-Powered Insights';

  @override
  String get onboardingBody2 =>
      'Scan receipts and get personalized advice to optimize your spending habits.';

  @override
  String get onboardingTitle3 => 'Grow Your Wealth';

  @override
  String get onboardingBody3 =>
      'Set smart budgets and watch your savings grow with predictive financial planning.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get email => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get signupTitle => 'Create an Account';

  @override
  String get loginBody => 'Log in to manage your portfolio';

  @override
  String get fingerPrintLogin => 'Log in with Fingerprint/FaceID';

  @override
  String get signupBody => 'Enter your details to get started.';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordBody =>
      'Enter your email to receive a password reset link';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get resetPasswordSuccess =>
      'If this email is registered, a reset link has been sent.';

  @override
  String get fieldCannotBeEmpty => 'This field cannot be empty';

  @override
  String get emptyName => 'Name cannot be empty';

  @override
  String get emptyEmail => 'Email cannot be empty';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get emptyPassword => 'Password cannot be empty';

  @override
  String get invalidPassword => 'Password must be at least 6 characters long';

  @override
  String get passwordSameAsCurrent =>
      'New password cannot be the same as the current password';

  @override
  String get emptyConfirmPassword => 'Confirm Password cannot be empty';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get userNotFound => 'No user found with this email.';

  @override
  String get wrongPassword => 'Incorrect password.';

  @override
  String get invalidCredential => 'Invalid email or password.';

  @override
  String get emailAlreadyInUse => 'Email is already registered.';

  @override
  String get invalidEmailAuth => 'The email address is invalid.';

  @override
  String get weakPasswordAuth => 'The password is too weak.';

  @override
  String get userDisabled => 'This user account has been disabled.';

  @override
  String get tooManyRequests => 'Too many attempts. Please try again later.';

  @override
  String get networkRequestFailed =>
      'Network error. Please check your connection.';

  @override
  String get databaseError => 'A database error occurred.';

  @override
  String get unknownError => 'An unexpected error occurred.';

  @override
  String get biometricDenied => 'Biometric authentication denied or cancelled.';

  @override
  String get noSavedCredentials =>
      'No saved credentials found. Please log in with your email first.';

  @override
  String get enableBiometricLogin => 'Enable Biometric Login';

  @override
  String get or => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get signInWithAnotherAccount => 'Sign in with another account';

  @override
  String get unlock => 'Unlock';

  @override
  String get googleSignInCanceled => 'Google Sign-In was canceled.';
}
