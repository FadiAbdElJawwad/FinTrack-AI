import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constant/color_manager.dart';
import '../../../../core/extension/app_sizes.dart';
import '../../../../core/providers/locale_provider.dart';

class LanguageSelectorDialog extends ConsumerWidget {
  const LanguageSelectorDialog({super.key});

  static const _languages = [
    (locale: Locale('en'), name: 'English'),
    (locale: Locale('ar'), name: 'العربية'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return AlertDialog(
      title: Text(context.loc.settingsLanguage),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((item) {
            final isSelected =
                item.locale.languageCode == currentLocale.languageCode;
            return ListTile(
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(item.locale);
                Navigator.pop(context);
              },
              title: Text(item.name),
              trailing: isSelected
                  ? const Icon(
                      Icons.check_circle,
                      color: ColorManager.primaryBlue,
                    )
                  : null,
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.loc.cancel),
        ),
      ],
    );
  }
}
