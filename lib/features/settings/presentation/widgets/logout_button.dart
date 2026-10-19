import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constant/color_manager.dart';
import '../../../../core/extension/app_sizes.dart';
import '../../../../core/extension/snackbar_extension.dart';
import '../../../auth/presentation/state/auth_controller.dart';
import '../../../transactions/presentation/utils/error_message.dart';
import 'logout_confirm_dialog.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorManager.errorColor,
        side: const BorderSide(color: ColorManager.errorColor),
      ),
      onPressed: () async {
        final confirmed = await showLogoutConfirmDialog(context);
        if (!confirmed) return;
        try {
          await ref.read(authControllerProvider.notifier).signOut();
        } catch (e) {
          if (context.mounted) {
            context.showErrorSnackBar(errorMessage(context, e));
          }
        }
      },
      child: Text(context.loc.logout),
    );
  }
}
