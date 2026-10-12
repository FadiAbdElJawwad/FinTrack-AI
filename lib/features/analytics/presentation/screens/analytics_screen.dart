import 'package:flutter/material.dart';
import '../../../../core/extension/app_sizes.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.navAnalytics),
        centerTitle: true,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
