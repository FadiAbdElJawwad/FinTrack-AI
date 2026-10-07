// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "addNote": MessageLookupByLibrary.simpleMessage("Add note..."),
    "addTransaction": MessageLookupByLibrary.simpleMessage("Add Transaction"),
    "aiInvalidInput": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t understand that input. Try rephrasing.",
    ),
    "aiNetworkError": MessageLookupByLibrary.simpleMessage(
      "Network error. Check your connection.",
    ),
    "aiNotConfigured": MessageLookupByLibrary.simpleMessage(
      "AI features are not configured.",
    ),
    "aiSchemaValidationFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t extract transaction details. Try again.",
    ),
    "aiServiceUnavailable": MessageLookupByLibrary.simpleMessage(
      "AI service is temporarily unavailable.",
    ),
    "aiUnauthorized": MessageLookupByLibrary.simpleMessage(
      "Unable to verify request. Please try again.",
    ),
    "aiUnknown": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again.",
    ),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "appTitle": MessageLookupByLibrary.simpleMessage("FinTrack AI"),
    "applyFilter": MessageLookupByLibrary.simpleMessage("Apply Filter"),
    "backToLogin": MessageLookupByLibrary.simpleMessage("Back to Login"),
    "biometricDenied": MessageLookupByLibrary.simpleMessage(
      "Biometric authentication denied or cancelled.",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "catEntertainment": MessageLookupByLibrary.simpleMessage("Entertainment"),
    "catFood": MessageLookupByLibrary.simpleMessage("Food"),
    "catOther": MessageLookupByLibrary.simpleMessage("Other"),
    "catSalary": MessageLookupByLibrary.simpleMessage("Salary"),
    "catShopping": MessageLookupByLibrary.simpleMessage("Shopping"),
    "catTransport": MessageLookupByLibrary.simpleMessage("Transport"),
    "category": MessageLookupByLibrary.simpleMessage("CATEGORY"),
    "completed": MessageLookupByLibrary.simpleMessage("Completed"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Continue with Google",
    ),
    "currencyChangeFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to update currency:",
    ),
    "currencyChangeSuccess": MessageLookupByLibrary.simpleMessage(
      "Currency updated successfully.",
    ),
    "customRange": MessageLookupByLibrary.simpleMessage("CUSTOM RANGE"),
    "databaseError": MessageLookupByLibrary.simpleMessage(
      "A database error occurred.",
    ),
    "date": MessageLookupByLibrary.simpleMessage("DATE"),
    "dateRange": MessageLookupByLibrary.simpleMessage("Date Range"),
    "defaultWalletName": MessageLookupByLibrary.simpleMessage("Cash"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteConfirm": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this transaction?",
    ),
    "deleteTransaction": MessageLookupByLibrary.simpleMessage(
      "Delete Transaction",
    ),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "editTransaction": MessageLookupByLibrary.simpleMessage("Edit Transaction"),
    "email": MessageLookupByLibrary.simpleMessage("Email Address"),
    "emailAlreadyInUse": MessageLookupByLibrary.simpleMessage(
      "Email is already registered.",
    ),
    "emptyEmail": MessageLookupByLibrary.simpleMessage("Email cannot be empty"),
    "emptyName": MessageLookupByLibrary.simpleMessage("Name cannot be empty"),
    "emptyPassword": MessageLookupByLibrary.simpleMessage(
      "Password cannot be empty",
    ),
    "emptyTransactions": MessageLookupByLibrary.simpleMessage(
      "No transactions found.",
    ),
    "enableBiometricLogin": MessageLookupByLibrary.simpleMessage(
      "Enable Biometric Login",
    ),
    "endDate": MessageLookupByLibrary.simpleMessage("End Date"),
    "exchangeRateServiceError": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t load exchange rates right now. Please try again.",
    ),
    "expense": MessageLookupByLibrary.simpleMessage("Expense"),
    "fieldCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "This field cannot be empty",
    ),
    "fingerPrintLogin": MessageLookupByLibrary.simpleMessage(
      "Log in with Fingerprint/FaceID",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot Password"),
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "getStarted": MessageLookupByLibrary.simpleMessage("Get Started"),
    "goodAfternoon": MessageLookupByLibrary.simpleMessage("Good afternoon"),
    "goodEvening": MessageLookupByLibrary.simpleMessage("Good evening"),
    "goodMorning": MessageLookupByLibrary.simpleMessage("Good morning"),
    "googleSignInCanceled": MessageLookupByLibrary.simpleMessage(
      "Google Sign-In was canceled.",
    ),
    "haveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "income": MessageLookupByLibrary.simpleMessage("Income"),
    "internetRequiredFirstLaunch": MessageLookupByLibrary.simpleMessage(
      "This app requires an internet connection on first launch.",
    ),
    "invalidCredential": MessageLookupByLibrary.simpleMessage(
      "Invalid email or password.",
    ),
    "invalidEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address",
    ),
    "invalidEmailAuth": MessageLookupByLibrary.simpleMessage(
      "The email address is invalid.",
    ),
    "invalidPassword": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters long",
    ),
    "lastMonth": MessageLookupByLibrary.simpleMessage("Last Month"),
    "listeningStatus": MessageLookupByLibrary.simpleMessage("Listening..."),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginBody": MessageLookupByLibrary.simpleMessage(
      "Log in to manage your portfolio",
    ),
    "loginTitle": MessageLookupByLibrary.simpleMessage("Welcome Back"),
    "manual": MessageLookupByLibrary.simpleMessage("Manual"),
    "micPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Microphone permission is required to use Voice Entry.",
    ),
    "more": MessageLookupByLibrary.simpleMessage("+ More"),
    "networkRequestFailed": MessageLookupByLibrary.simpleMessage(
      "Network error. Please check your connection.",
    ),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "noSavedCredentials": MessageLookupByLibrary.simpleMessage(
      "No saved credentials found. Please log in with your email first.",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("NOTES"),
    "onboardingBody1": MessageLookupByLibrary.simpleMessage(
      "Connect your accounts and let our AI categorize every transaction automatically.",
    ),
    "onboardingBody2": MessageLookupByLibrary.simpleMessage(
      "Scan receipts and get personalized advice to optimize your spending habits.",
    ),
    "onboardingBody3": MessageLookupByLibrary.simpleMessage(
      "Set smart budgets and watch your savings grow with predictive financial planning.",
    ),
    "onboardingTitle1": MessageLookupByLibrary.simpleMessage(
      "Smart Financial Tracking",
    ),
    "onboardingTitle2": MessageLookupByLibrary.simpleMessage(
      "AI-Powered Insights",
    ),
    "onboardingTitle3": MessageLookupByLibrary.simpleMessage(
      "Grow Your Wealth",
    ),
    "or": MessageLookupByLibrary.simpleMessage("OR"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordSameAsCurrent": MessageLookupByLibrary.simpleMessage(
      "New password cannot be the same as the current password",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "paymentMethod": MessageLookupByLibrary.simpleMessage("Payment Method"),
    "processingButton": MessageLookupByLibrary.simpleMessage("Processing..."),
    "processingStatus": MessageLookupByLibrary.simpleMessage("Processing..."),
    "quickPresets": MessageLookupByLibrary.simpleMessage("QUICK PRESETS"),
    "rangeError": MessageLookupByLibrary.simpleMessage(
      "Date range cannot exceed one month",
    ),
    "recentTransactions": MessageLookupByLibrary.simpleMessage(
      "Recent Transactions",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "resetPasswordBody": MessageLookupByLibrary.simpleMessage(
      "Enter your email to receive a password reset link",
    ),
    "resetPasswordSuccess": MessageLookupByLibrary.simpleMessage(
      "If this email is registered, a reset link has been sent.",
    ),
    "saveTransaction": MessageLookupByLibrary.simpleMessage("Save Transaction"),
    "scan": MessageLookupByLibrary.simpleMessage("Scan"),
    "seeAll": MessageLookupByLibrary.simpleMessage("See All"),
    "selectCurrency": MessageLookupByLibrary.simpleMessage("Select Currency"),
    "selectDateRange": MessageLookupByLibrary.simpleMessage(
      "Select Date Range",
    ),
    "selectWallet": MessageLookupByLibrary.simpleMessage("SELECT WALLET"),
    "sendResetLink": MessageLookupByLibrary.simpleMessage("Send Reset Link"),
    "sessionExpired": MessageLookupByLibrary.simpleMessage(
      "Your session has expired. Please log in again.",
    ),
    "signInWithAnotherAccount": MessageLookupByLibrary.simpleMessage(
      "Sign in with another account",
    ),
    "signup": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "signupBody": MessageLookupByLibrary.simpleMessage(
      "Enter your details to get started.",
    ),
    "signupTitle": MessageLookupByLibrary.simpleMessage("Create an Account"),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "speechTimeout": MessageLookupByLibrary.simpleMessage(
      "No speech detected. Try again.",
    ),
    "splashBody": MessageLookupByLibrary.simpleMessage(
      "Smart Financial Tracking",
    ),
    "startDate": MessageLookupByLibrary.simpleMessage("Start Date"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "stopAndProcess": MessageLookupByLibrary.simpleMessage("Stop & Process"),
    "tapToSpeak": MessageLookupByLibrary.simpleMessage("Tap to speak"),
    "thisMonth": MessageLookupByLibrary.simpleMessage("This Month"),
    "thisWeek": MessageLookupByLibrary.simpleMessage("This Week"),
    "tooManyRequests": MessageLookupByLibrary.simpleMessage(
      "Too many attempts. Please try again later.",
    ),
    "totalBalance": MessageLookupByLibrary.simpleMessage("Total Balance"),
    "totalExpense": MessageLookupByLibrary.simpleMessage("Total Expense"),
    "totalIncome": MessageLookupByLibrary.simpleMessage("Total Income"),
    "transactionDeleted": MessageLookupByLibrary.simpleMessage(
      "Transaction deleted.",
    ),
    "transactionDetails": MessageLookupByLibrary.simpleMessage(
      "Transaction Details",
    ),
    "transactions": MessageLookupByLibrary.simpleMessage("Transactions"),
    "tryAgainButton": MessageLookupByLibrary.simpleMessage("Try Again"),
    "tryAgainVoice": MessageLookupByLibrary.simpleMessage("Please try again."),
    "type": MessageLookupByLibrary.simpleMessage("Type"),
    "unknownError": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred.",
    ),
    "unknownWallet": MessageLookupByLibrary.simpleMessage("Unknown"),
    "userDisabled": MessageLookupByLibrary.simpleMessage(
      "This user account has been disabled.",
    ),
    "userNotFound": MessageLookupByLibrary.simpleMessage(
      "No user found with this email.",
    ),
    "voice": MessageLookupByLibrary.simpleMessage("Voice"),
    "voiceEntryTitle": MessageLookupByLibrary.simpleMessage("Voice Entry"),
    "weakPasswordAuth": MessageLookupByLibrary.simpleMessage(
      "The password is too weak.",
    ),
    "wrongPassword": MessageLookupByLibrary.simpleMessage(
      "Incorrect password.",
    ),
  };
}
