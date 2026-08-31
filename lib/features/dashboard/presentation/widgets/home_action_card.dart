import 'package:flutter/material.dart';

import '../../../../core/constant/color_manager.dart';
import '../../../../core/extension/app_sizes.dart';
import '../../../../core/extension/text_style_extension.dart';

class HomeActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const HomeActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              Card(
                color: ColorManager.primaryBlue.withValues(alpha: 0.2),
                shape: const StadiumBorder(),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(icon, color: ColorManager.primaryBlue, size: 24),
                ),
              ),
              context.addVerticalSpace(8),
              Text(
                label,
                style: context.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ).padSymmetric(8).padVerticalSymmetric(16),
        ),
      ),
    );
  }
}
