import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constant/color_manager.dart';
import '../../../../core/extension/app_sizes.dart';
import '../../../../core/extension/text_style_extension.dart';
import '../../../../core/widgets/bottom_sheet_drag_handle.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../transactions/presentation/utils/error_message.dart';
import '../../domain/models/wallet_model.dart';
import '../state/wallet_controller.dart';
import '../utils/wallet_display_name.dart';
import '../utils/wallet_icon.dart';

Future<void> showAddWalletSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AddWalletSheet(),
  );
}

class AddWalletSheet extends HookConsumerWidget {
  const AddWalletSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    useValueListenable(nameController);
    final selectedIcon = useState<String>(walletIconChoices.first);
    final isLoading = useState(false);

    final wallets = ref.watch(walletControllerProvider).valueOrNull ?? [];
    final trimmedName = nameController.text.trim();

    final isDuplicate = trimmedName.isNotEmpty &&
        wallets.any((w) {
          final storedName = w.name.trim().toLowerCase();
          final localizedName =
              walletDisplayName(context.loc, w).trim().toLowerCase();
          final target = trimmedName.toLowerCase();
          return storedName == target || localizedName == target;
        });

    final isFormValid = trimmedName.isNotEmpty &&
        trimmedName.length <= 50 &&
        !isDuplicate &&
        !isLoading.value;

    Future<void> handleSave() async {
      if (!isFormValid) return;
      isLoading.value = true;
      try {
        await ref.read(walletControllerProvider.notifier).addWallet(
              WalletModel(
                name: trimmedName,
                icon: selectedIcon.value,
                isDefault: false,
              ),
            );
        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage(context, e))),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BottomSheetDragHandle(),
                context.addVerticalSpace(20),
                Text(
                  context.loc.addWalletTitle,
                  style: context.labelLarge
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                context.addVerticalSpace(20),
                TextField(
                  controller: nameController,
                  maxLength: 50,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: context.loc.walletNameLabel,
                    errorText:
                        isDuplicate ? context.loc.walletNameExists : null,
                  ),
                ),
                context.addVerticalSpace(16),
                Text(
                  context.loc.walletIconLabel,
                  style: context.labelSmall.copyWith(
                    color: ColorManager.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                context.addVerticalSpace(12),
                WalletIconSelector(
                  selectedIcon: selectedIcon.value,
                  onSelect: (icon) => selectedIcon.value = icon,
                ),
                context.addVerticalSpace(32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isFormValid ? handleSave : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryBlue,
                      disabledBackgroundColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading.value
                        ? const CircularProgressIndicator(
                            color: ColorManager.white,
                          )
                        : Text(
                            context.loc.createWallet,
                            style: context.labelLarge.copyWith(
                              color: isFormValid
                                  ? ColorManager.white
                                  : ColorManager.secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                context.addVerticalSpace(16),
              ],
            ).padSymmetric(20).padTop(16),
          ),
          if (isLoading.value) const LoadingOverlay(),
        ],
      ),
    );
  }
}

class WalletIconSelector extends StatelessWidget {
  final String selectedIcon;
  final ValueChanged<String> onSelect;

  const WalletIconSelector({
    super.key,
    required this.selectedIcon,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: walletIconChoices.map((iconName) {
        final isSelected = selectedIcon == iconName;
        final iconData = walletIconData(iconName);
        return InkWell(
          onTap: () => onSelect(iconName),
          customBorder: const CircleBorder(),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? ColorManager.primaryBlue
                  : ColorManager.primaryBlue.withValues(alpha: 0.1),
            ),
            child: Icon(
              iconData,
              color:
                  isSelected ? ColorManager.white : ColorManager.primaryBlue,
            ),
          ),
        );
      }).toList(),
    );
  }
}
