import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/extension/app_sizes.dart';
import '../../../../core/extension/snackbar_extension.dart';
import '../state/biometric_setting_controller.dart';
import 'settings_section.dart';

class SecuritySection extends ConsumerWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBiometricEnabled = ref.watch(biometricSettingProvider);

    return SettingsSection(
      title: context.loc.settingsSecurity,
      children: [
        ListTile(
          leading: const Icon(Icons.fingerprint),
          title: Text(context.loc.settingsBiometric),
          trailing: Switch(
            value: isBiometricEnabled,
            onChanged: (value) async {
              final success = await ref
                  .read(biometricSettingProvider.notifier)
                  .setEnabled(value);
              if (!success && value && context.mounted) {
                context.showErrorSnackBar(context.loc.biometricDenied);
              }
            },
          ),
        ),
      ],
    );
  }
}
