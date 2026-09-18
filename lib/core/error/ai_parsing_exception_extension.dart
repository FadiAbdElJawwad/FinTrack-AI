import 'package:flutter/material.dart';
import '../extension/app_sizes.dart';
import 'ai_parsing_exception.dart';

extension AiParsingExceptionExtension on AiParsingException {
  String getLocalizedMessage(BuildContext context) {
    switch (type) {
      case AiParsingErrorType.unauthorized:
        return context.loc.aiUnauthorized;
      case AiParsingErrorType.invalidInput:
        return context.loc.aiInvalidInput;
      case AiParsingErrorType.serviceUnavailable:
        return context.loc.aiServiceUnavailable;
      case AiParsingErrorType.schemaValidationFailed:
        return context.loc.aiSchemaValidationFailed;
      case AiParsingErrorType.networkError:
        return context.loc.aiNetworkError;
      case AiParsingErrorType.unknown:
        return context.loc.aiUnknown;
    }
  }
}
