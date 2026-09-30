enum WalletErrorType {
  notAuthenticated,
  permissionDenied,
  notFound,
  networkError,
  invalidData,
  unknown,
}

class WalletException implements Exception {
  final WalletErrorType type;
  final String? message;

  WalletException(this.type, {this.message});

  @override
  String toString() => 'WalletException: $type ${message ?? ""}';
}
