import 'package:flutter/material.dart';
import '../../../../core/extension/app_sizes.dart';

class WalletsScreen extends StatelessWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.navWallets),
        centerTitle: true,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
