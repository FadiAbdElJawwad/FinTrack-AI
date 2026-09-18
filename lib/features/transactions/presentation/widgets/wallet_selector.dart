import 'package:flutter/material.dart';

import '../../../../core/constant/color_manager.dart';
import '../../../../core/extension/text_style_extension.dart';

class WalletSelector extends StatelessWidget {
  final List<String> wallets;
  final String selectedWallet;
  final Function(String) onSelect;

  const WalletSelector({
    super.key,
    required this.wallets,
    required this.selectedWallet,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: wallets.map((wallet) {
          final isSelected = selectedWallet == wallet;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(wallet),
              selected: isSelected,
              onSelected: (_) => onSelect(wallet),
              selectedColor: ColorManager.primaryBlue,
              backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
              labelStyle: context.labelSmall.copyWith(
                color: isSelected
                    ? Colors.white
                    : ColorManager.secondaryColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide.none,
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}
