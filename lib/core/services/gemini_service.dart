import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../constant/app_env.dart';
import '../error/ai_parsing_exception.dart';
import '../providers/firebase_providers.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return GeminiService(
    proxyUrl: AppEnv.appsScriptProxyUrl,
    sharedSecret: AppEnv.appSharedSecret,
    idTokenProvider: () async =>
        ref.read(firebaseAuthProvider).currentUser?.getIdToken(),
    client: client,
  );
});

class GeminiService {
  final String proxyUrl;
  final String sharedSecret;
  final Future<String?> Function() idTokenProvider;
  final http.Client _client;

  GeminiService({
    required this.proxyUrl,
    required this.sharedSecret,
    required this.idTokenProvider,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> parseTransactionText(String input) async {
    try {
      final idToken = await idTokenProvider();
      if (idToken == null || idToken.isEmpty) {
        throw AiParsingException(AiParsingErrorType.unauthorized);
      }

      // The secret and the ID token travel in the body only; the URL carries
      // no query string, so neither can end up in URL logs.
      final response = await _client
          .post(
            Uri.parse(proxyUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'input': input,
              'secret': sharedSecret,
              'idToken': idToken,
            }),
          )
          .timeout(const Duration(seconds: 20));

      var finalStatusCode = response.statusCode;
      var finalResponseBody = response.body;

      if (response.statusCode >= 300 && response.statusCode < 400) {
        final location =
            response.headers['location'] ?? response.headers['Location'];
        if (location == null || location.isEmpty) {
          throw AiParsingException(
            AiParsingErrorType.unknown,
            message: 'Redirect with no location header',
          );
        }

        final followUpResponse = await _client
            .get(Uri.parse(location))
            .timeout(const Duration(seconds: 20));

        finalStatusCode = followUpResponse.statusCode;
        finalResponseBody = followUpResponse.body;
      }

      switch (finalStatusCode) {
        case 200:
          try {
            final decoded = jsonDecode(finalResponseBody);
            if (decoded is Map<String, dynamic>) {
              if (decoded.containsKey('error')) {
                final errorMsg = decoded['error'].toString();
                switch (errorMsg) {
                  case 'unauthorized':
                    throw AiParsingException(AiParsingErrorType.unauthorized);
                  case 'missing or invalid input':
                    throw AiParsingException(AiParsingErrorType.invalidInput);
                  case 'schema validation failed':
                    throw AiParsingException(
                      AiParsingErrorType.schemaValidationFailed,
                    );
                  case 'gemini request failed':
                    throw AiParsingException(
                      AiParsingErrorType.serviceUnavailable,
                    );
                  case 'rate limited':
                    throw AiParsingException(
                      AiParsingErrorType.serviceUnavailable,
                    );
                  default:
                    throw AiParsingException(
                      AiParsingErrorType.unknown,
                      message: errorMsg,
                    );
                }
              }
              return decoded;
            }
            throw AiParsingException(
              AiParsingErrorType.schemaValidationFailed,
              message: 'Response is not a valid JSON object',
            );
          } on FormatException catch (e) {
            throw AiParsingException(
              AiParsingErrorType.schemaValidationFailed,
              message: e.message,
            );
          }
        case 400:
          throw AiParsingException(AiParsingErrorType.invalidInput);
        case 401:
          throw AiParsingException(AiParsingErrorType.unauthorized);
        case 422:
          throw AiParsingException(AiParsingErrorType.schemaValidationFailed);
        case 502:
          throw AiParsingException(AiParsingErrorType.serviceUnavailable);
        default:
          throw AiParsingException(
            AiParsingErrorType.unknown,
            message: finalResponseBody,
          );
      }
    } on AiParsingException {
      rethrow;
    } on TimeoutException {
      throw AiParsingException(
        AiParsingErrorType.networkError,
        message: 'Request timed out after 20s',
      );
    } on SocketException catch (e) {
      throw AiParsingException(
        AiParsingErrorType.networkError,
        message: e.message,
      );
    } catch (e) {
      if (e is http.ClientException) {
        throw AiParsingException(
          AiParsingErrorType.networkError,
          message: e.message,
        );
      }
      throw AiParsingException(
        AiParsingErrorType.networkError,
        message: e.toString(),
      );
    }
  }
}
