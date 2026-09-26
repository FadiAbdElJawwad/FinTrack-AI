import 'package:flutter/material.dart';

import '../../../../core/widgets/app_chip_selector.dart';
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
    return AppChipSelector<WalletModel>(
      items: wallets,
      isSelected: (wallet) => selectedWalletId == wallet.id,
      labelBuilder: (wallet) => wallet.name,
      onSelect: (wallet) => onSelect(wallet.id!),
    );
  }
}

