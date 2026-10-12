import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constant/images_manager.dart';
import '../../../../core/extension/app_sizes.dart';
import '../../../../core/extension/text_style_extension.dart';
import '../../../auth/presentation/state/auth_controller.dart';

class SettingsProfileHeader extends ConsumerWidget {
  const SettingsProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final fullName = user?.fullName ?? '';
    final email = user?.email ?? '';

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          child: Image.asset(ImagesManager.userAvatar,fit: BoxFit.cover),
        ),
        if (fullName.isNotEmpty) ...[
          context.addVerticalSpace(12),
          Text(
            fullName,
            style: context.labelLarge,
          ),
        ],
        if (email.isNotEmpty) ...[
          context.addVerticalSpace(4),
          Text(
            email,
            style: context.bodyMedium,
          ),
        ],
      ],
    );
  }
}
