enum TransactionErrorType {
  notAuthenticated,
  permissionDenied,
  notFound,
  networkError,
  invalidData,
  unknown,
}

class TransactionException implements Exception {
  final TransactionErrorType type;
  final String? message;

  TransactionException(this.type, {this.message});

  @override
  String toString() => 'TransactionException: $type ${message ?? ""}';
}
