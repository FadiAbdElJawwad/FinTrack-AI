import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constant/color_manager.dart';
import '../../../../core/constant/images_manager.dart';
import '../../../../core/constant/shared_prefs_keys.dart';
import '../../../../core/extension/app_sizes.dart';
import '../../../../core/extension/text_style_extension.dart';
import '../../../../core/providers/shared_prefs_provider.dart';
import '../../../../core/services/biometric_service.dart';

class LockScreen extends HookConsumerWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricService = ref.watch(biometricServiceProvider);

    Future<void> handleUnlock() async {
      final success = await biometricService.authenticate();
      if (success && context.mounted) {
        context.goNamed('home');
      }
    }

    Future<void> handleSignOut() async {
      await FirebaseAuth.instance.signOut();
      final prefs = ref.read(sharedPrefsProvider);
      await prefs.setBool(SharedPrefsKeys.isBiometricEnabledKey, false);
      if (context.mounted) {
        context.goNamed('login');
      }
    }

    useEffect(() {
      Future.microtask(() => handleUnlock());
      return null;
    }, []);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              ImagesManager.finTrackAILogo,
              width: context.wp(40),
            ),
            Text(
              context.loc.loginTitle,
              style: context.headlineMedium,
            ),
            context.addVerticalSpace(32),
              ElevatedButton.icon(
                onPressed: handleUnlock,
                icon: const Icon(Icons.fingerprint),
                label: Text(context.loc.fingerPrintLogin),
            ),
            const Spacer(),
            TextButton(
              onPressed: handleSignOut,
              child: Text(
                context.loc.signInWithAnotherAccount,
                style: const TextStyle(color: ColorManager.secondaryColor),
              ),
            ),
            context.addVerticalSpace(20),
          ],
        ).padSymmetric(20),
      ),
    );
  }
}
