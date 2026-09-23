import 'package:flutter/material.dart';

import '../../../../core/constant/color_manager.dart';
import '../../../../core/extension/text_style_extension.dart';
import '../../../wallets/domain/models/wallet_model.dart';

class WalletSelector extends StatelessWidget {
  final List<WalletModel> wallets;
  final String? selectedWalletId;
  final Function(String) onSelect;

  const WalletSelector({
    super.key,
    required this.wallets,
    this.selectedWalletId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (wallets.isEmpty) return const SizedBox.shrink();
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: wallets.map((wallet) {
          final isSelected = selectedWalletId == wallet.id;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(wallet.name),
              selected: isSelected,
              onSelected: (_) => onSelect(wallet.id!),
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

