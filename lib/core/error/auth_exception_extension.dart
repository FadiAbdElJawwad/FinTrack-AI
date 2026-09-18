import 'package:flutter/material.dart';
import '../extension/app_sizes.dart';
import 'auth_exception.dart';

extension AuthExceptionExtension on AppAuthException {
  String getLocalizedMessage(BuildContext context) {
    switch (type) {
      case AuthErrorType.userNotFound:
        return context.loc.userNotFound;
      case AuthErrorType.wrongPassword:
        return context.loc.wrongPassword;
      case AuthErrorType.invalidCredential:
        return context.loc.invalidCredential;
      case AuthErrorType.emailAlreadyInUse:
        return context.loc.emailAlreadyInUse;
      case AuthErrorType.invalidEmail:
        return context.loc.invalidEmailAuth;
      case AuthErrorType.weakPassword:
        return context.loc.weakPasswordAuth;
      case AuthErrorType.userDisabled:
        return context.loc.userDisabled;
      case AuthErrorType.tooManyRequests:
        return context.loc.tooManyRequests;
      case AuthErrorType.networkRequestFailed:
        return context.loc.networkRequestFailed;
      case AuthErrorType.databaseError:
        return context.loc.databaseError;
      case AuthErrorType.biometricDenied:
        return context.loc.biometricDenied;
      case AuthErrorType.noSavedCredentials:
        return context.loc.noSavedCredentials;
      case AuthErrorType.googleSignInCanceled:
        return context.loc.googleSignInCanceled;
      case AuthErrorType.sessionExpired:
        return context.loc.sessionExpired;
      case AuthErrorType.unknown:
        return context.loc.unknownError;
    }
  }
}
