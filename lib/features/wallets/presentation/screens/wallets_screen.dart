import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class WalletsScreen extends StatelessWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navWallets),
        centerTitle: true,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
