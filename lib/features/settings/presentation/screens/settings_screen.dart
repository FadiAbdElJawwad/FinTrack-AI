import 'package:flutter/material.dart';
import '../../../../core/extension/app_sizes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.navSettings),
        centerTitle: true,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
