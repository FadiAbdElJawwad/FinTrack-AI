import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constant/color_manager.dart';
import '../../../../core/extension/app_sizes.dart';
import '../../../../core/extension/text_style_extension.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  // Design tokens from Figma node 6:3090
  static const double _borderRadius = 12.0;
  static const double _inactiveItemWidth = 64.0;
  static const double _activeItemWidth = 80.0;
  static const double _inactiveIconSize = 18.0;
  static const double _activeIconSize = 20.0;
  static const double _activePillRadius = 100.0; // Fully rounded pill

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsetsDirectional.only(
          top: context.screenHeight(13),
          bottom: context.screenHeight(12),
          start: context.screenWidth(26.75),
          end: context.screenWidth(26.75),
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.dividerColor,
              width: 1.0,
            ),
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(_borderRadius),
            topRight: Radius.circular(_borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavBarItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: l10n.navHome,
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavBarItem(
              icon: Icons.analytics_outlined,
              activeIcon: Icons.analytics,
              label: l10n.navAnalytics,
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavBarItem(
              icon: Icons.account_balance_wallet_outlined,
              activeIcon: Icons.account_balance_wallet,
              label: l10n.navWallets,
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavBarItem(
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: l10n.navSettings,
              isSelected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.labelSmall.copyWith(
      color: isSelected ? ColorManager.white : ColorManager.secondaryColor,
    );

    return Semantics(
      selected: isSelected,
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: context.screenWidth(isSelected
              ? MainBottomNavBar._activeItemWidth
              : MainBottomNavBar._inactiveItemWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: isSelected
                    ? EdgeInsetsDirectional.symmetric(
                        horizontal: context.screenWidth(16),
                        vertical: context.screenHeight(4),
                      )
                    : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: isSelected ? ColorManager.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                      isSelected ? MainBottomNavBar._activePillRadius : 0),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  size: isSelected
                      ? MainBottomNavBar._activeIconSize
                      : MainBottomNavBar._inactiveIconSize,
                  color: isSelected ? ColorManager.white : ColorManager.secondaryColor,
                ),
              ),
              context.addVerticalSpace(4),
              Text(
                label,
                style: labelStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
