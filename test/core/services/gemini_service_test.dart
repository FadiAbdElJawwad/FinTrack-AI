import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fin_track_ai/core/error/ai_parsing_exception.dart';
import 'package:fin_track_ai/core/services/gemini_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const proxyUrl = 'https://script.example.test/macros/s/abc/exec';
const secret = 'test-secret-value';
const token = 'test-id-token-value';

http.Response ok(Object body) => http.Response(
  body is String ? body : jsonEncode(body),
  200,
  headers: {'content-type': 'application/json'},
);

GeminiService serviceWith(
  MockClient client, {
  Future<String?> Function()? idTokenProvider,
  String proxyUrl = proxyUrl,
  String sharedSecret = secret,
}) => GeminiService(
  proxyUrl: proxyUrl,
  sharedSecret: sharedSecret,
  idTokenProvider: idTokenProvider ?? () async => token,
  client: client,
);

Matcher aiError(AiParsingErrorType type) =>
    isA<AiParsingException>().having((e) => e.type, 'type', type);

void main() {
  timeoutTest();

  group('configuration validation', () {
    test('invalid config throws notConfigured and makes 0 requests', () async {
      var requests = 0;
      final client = MockClient((request) async {
        requests++;
        return ok({});
      });

      final service = serviceWith(
        client,
        proxyUrl: 'http://invalid-url.com',
        sharedSecret: '',
      );

      await expectLater(
        service.parseTransactionText('x'),
        throwsA(aiError(AiParsingErrorType.notConfigured)),
      );
      expect(requests, 0);
    });
  });

  group('request contract', () {
    test('posts to the exact proxy URL without a query string', () async {
      late http.Request captured;
      final client = MockClient((request) async {
        captured = request;
        return ok({'amount': 5});
      });

      await serviceWith(client).parseTransactionText('coffee 5');

      expect(captured.method, 'POST');
      expect(captured.url.toString(), proxyUrl);
      expect(captured.url.hasQuery, isFalse);
      expect(captured.headers['Content-Type'], contains('application/json'));
    });

    test('body carries input, secret and idToken', () async {
      late Map<String, dynamic> body;
      final client = MockClient((request) async {
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return ok({'amount': 5});
      });

      await serviceWith(client).parseTransactionText('coffee 5');

      expect(body, {'input': 'coffee 5', 'secret': secret, 'idToken': token});
    });

    test('the secret never appears in the URL', () async {
      late Uri url;
      final client = MockClient((request) async {
        url = request.url;
        return ok({});
      });

      await serviceWith(client).parseTransactionText('x');

      expect(url.toString(), isNot(contains(secret)));
    });
  });

  group('missing ID token', () {
    for (final entry in {'null': null, 'empty': ''}.entries) {
      test(
        '${entry.key} token throws unauthorized and sends nothing',
        () async {
          var requests = 0;
          final client = MockClient((request) async {
            requests++;
            return ok({});
          });

          await expectLater(
            serviceWith(
              client,
              idTokenProvider: () async => entry.value,
            ).parseTransactionText('x'),
            throwsA(aiError(AiParsingErrorType.unauthorized)),
          );
          expect(requests, 0);
        },
      );
    }

    test(
      'a failing token provider surfaces without leaking the secret',
      () async {
        final client = MockClient((request) async => ok({}));
        final service = serviceWith(
          client,
          idTokenProvider: () async => throw StateError('no user'),
        );

        await expectLater(
          service.parseTransactionText('x'),
          throwsA(
            isA<AiParsingException>().having(
              (e) => '${e.message} ${e.type}',
              'text',
              allOf(isNot(contains(secret)), isNot(contains(token))),
            ),
          ),
        );
      },
    );
  });

  group('redirects', () {
    test('a 3xx with a Location header is followed by a GET', () async {
      final requests = <http.Request>[];
      final client = MockClient((request) async {
        requests.add(request);
        if (request.method == 'POST') {
          return http.Response(
            '',
            302,
            headers: {'location': 'https://result.example.test/echo?x=1'},
          );
        }
        return ok({'amount': 12, 'title': 'Lunch'});
      });

      final result = await serviceWith(client).parseTransactionText('lunch 12');

      expect(requests.map((r) => r.method), ['POST', 'GET']);
      expect(
        requests.last.url.toString(),
        'https://result.example.test/echo?x=1',
      );
      expect(result, {'amount': 12, 'title': 'Lunch'});
    });

    test('a 3xx without a Location header is an unknown error', () async {
      final client = MockClient((request) async => http.Response('', 302));

      await expectLater(
        serviceWith(client).parseTransactionText('x'),
        throwsA(aiError(AiParsingErrorType.unknown)),
      );
    });
  });

  group('error strings in a 200 body', () {
    final cases = <String, AiParsingErrorType>{
      'unauthorized': AiParsingErrorType.unauthorized,
      'missing or invalid input': AiParsingErrorType.invalidInput,
      'schema validation failed': AiParsingErrorType.schemaValidationFailed,
      'gemini request failed': AiParsingErrorType.serviceUnavailable,
      'rate limited': AiParsingErrorType.serviceUnavailable,
    };

    cases.forEach((message, type) {
      test('"$message" maps to $type', () async {
        final client = MockClient((request) async => ok({'error': message}));

        await expectLater(
          serviceWith(client).parseTransactionText('x'),
          throwsA(aiError(type)),
        );
      });
    });

    test(
      'an unknown error string maps to unknown and keeps the message',
      () async {
        final client = MockClient((request) async => ok({'error': 'boom'}));

        await expectLater(
          serviceWith(client).parseTransactionText('x'),
          throwsA(
            isA<AiParsingException>()
                .having((e) => e.type, 'type', AiParsingErrorType.unknown)
                .having((e) => e.message, 'message', 'boom'),
          ),
        );
      },
    );
  });

  group('success and failures', () {
    test('a valid 200 JSON object is returned unchanged', () async {
      final payload = {
        'amount': 12.5,
        'type': 'expense',
        'category': 'food',
        'title': 'Lunch',
        'date': '2026-10-04T12:00:00',
      };
      final client = MockClient((request) async => ok(payload));

      expect(await serviceWith(client).parseTransactionText('x'), payload);
    });

    test('a non-object 200 body is a schema failure', () async {
      final client = MockClient((request) async => ok('[1, 2]'));

      await expectLater(
        serviceWith(client).parseTransactionText('x'),
        throwsA(aiError(AiParsingErrorType.schemaValidationFailed)),
      );
    });

    test('HTTP fallbacks still map (401, 502)', () async {
      for (final entry in {
        401: AiParsingErrorType.unauthorized,
        502: AiParsingErrorType.serviceUnavailable,
      }.entries) {
        final client = MockClient(
          (request) async => http.Response('', entry.key),
        );
        await expectLater(
          serviceWith(client).parseTransactionText('x'),
          throwsA(aiError(entry.value)),
        );
      }
    });

    test('a socket error maps to networkError', () async {
      final client = MockClient(
        (request) async => throw const SocketException('offline'),
      );

      await expectLater(
        serviceWith(client).parseTransactionText('x'),
        throwsA(aiError(AiParsingErrorType.networkError)),
      );
    });

    test('exception messages never contain the secret or the token', () async {
      final client = MockClient(
        (request) async => throw http.ClientException('connection reset'),
      );

      await expectLater(
        serviceWith(client).parseTransactionText('x'),
        throwsA(
          isA<AiParsingException>().having(
            (e) => e.toString(),
            'toString',
            allOf(isNot(contains(secret)), isNot(contains(token))),
          ),
        ),
      );
    });
  });
}

// Outside the groups: testWidgets runs on a fake clock, so the 20 s timeout
// elapses instantly (no real waiting and no extra package).
void timeoutTest() {
  testWidgets('a 20 s timeout maps to networkError', (tester) async {
    final client = MockClient((request) async {
      await Future<void>.delayed(const Duration(seconds: 60));
      return ok({});
    });
    Object? error;
    unawaited(
      serviceWith(client)
          .parseTransactionText('x')
          .then<void>((_) {}, onError: (Object e) => error = e),
    );

    await tester.pump(const Duration(seconds: 21));

    expect(error, aiError(AiParsingErrorType.networkError));
    expect((error! as AiParsingException).message, contains('20s'));
    await tester.pump(const Duration(seconds: 60));
  });
}
