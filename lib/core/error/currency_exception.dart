/// Thrown when no exchange rates are cached and a live fetch also fails due
/// to a genuine connectivity/timeout problem (SocketException, TimeoutException).
/// The UI should show the "requires internet" gate.
class NoExchangeRatesAvailableException implements Exception {
  @override
  String toString() =>
      'NoExchangeRatesAvailableException: exchange rates unavailable and no cache exists.';
}

/// Thrown when the exchange-rate server is reachable but returns an error
/// (non-200 status) or the response body cannot be parsed. This is distinct
/// from [NoExchangeRatesAvailableException]: the device has internet, but
/// the service itself has a problem. The UI should show a service-error
/// message (with [details]) instead of the "no internet" gate.
class ExchangeRateServiceException implements Exception {
  const ExchangeRateServiceException(this.details);

  /// Human-readable description, e.g. "HTTP 404" or a FormatException message.
  final String details;

  @override
  String toString() => 'ExchangeRateServiceException: $details';
}
