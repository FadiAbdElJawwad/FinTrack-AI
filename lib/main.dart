import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/constant/app_env.dart';
import 'core/error/currency_exception.dart';
import 'core/theme/app_theme.dart';
import 'features/currency/data/services/exchange_rate_service.dart';
import 'features/currency/presentation/screens/exchange_rate_gate_screen.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/router_provider.dart';
import 'core/providers/shared_prefs_provider.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  final prefs = await SharedPreferences.getInstance();

  if (!AppEnv.isAiConfigured && kDebugMode) {
    debugPrint('Warning: AI config is missing or invalid. Voice entry will be disabled.');
  }

  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: const FinTrackApp(),
    ),
  );
}

class FinTrackApp extends ConsumerWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    final goRouter = ref.watch(goRouterProvider);
    final ratesBootstrap = ref.watch(exchangeRatesBootstrapProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      onGenerateTitle: (context) => S.of(context).appTitle,
      theme: AppTheme.lightTheme(locale.languageCode),
      darkTheme: AppTheme.darkTheme(locale.languageCode),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      builder: (context, child) {
        final error = ratesBootstrap.error;
        if (error != null) {
          return ExchangeRateGateScreen(
            error: (error is NoExchangeRatesAvailableException ||
                    error is ExchangeRateServiceException)
                ? error
                : ExchangeRateServiceException(error.toString()),
          );
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}

