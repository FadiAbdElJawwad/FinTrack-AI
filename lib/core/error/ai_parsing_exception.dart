enum AiParsingErrorType {
  notConfigured,
  unauthorized,
  invalidInput,
  serviceUnavailable,
  schemaValidationFailed,
  networkError,
  unknown,
}

class AiParsingException implements Exception {
  final AiParsingErrorType type;
  final String? message;

  AiParsingException(this.type, {this.message});

  @override
  String toString() => 'AiParsingException: $type ${message ?? ""}';
}
