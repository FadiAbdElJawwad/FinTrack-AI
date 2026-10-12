import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navAnalytics),
        centerTitle: true,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
