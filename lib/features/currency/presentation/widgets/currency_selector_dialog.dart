import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constant/color_manager.dart';
import '../../../../core/extension/app_sizes.dart';
import '../../../../core/extension/snackbar_extension.dart';
import '../../../transactions/presentation/utils/error_message.dart';
import '../../domain/models/app_currency.dart';
import '../state/currency_controller.dart';

class CurrencySelectorDialog extends HookConsumerWidget {
  const CurrencySelectorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCode =
        ref.watch(currencyControllerProvider).valueOrNull ?? 'USD';
    final isLoading = useState(false);

    Future<void> handleSelect(AppCurrency selected) async {
      if (selected.code == currentCode || isLoading.value) return;
      isLoading.value = true;
      try {
        await ref
            .read(currencyControllerProvider.notifier)
            .changeCurrency(selected.code);
        if (context.mounted) {
          context.showSuccessSnackBar(context.loc.currencyChangeSuccess);
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          context.showErrorSnackBar(
            '${context.loc.currencyChangeFailed} ${errorMessage(context, e)}',
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return AlertDialog(
      title: Text(context.loc.selectCurrency),
      content: SizedBox(
        width: double.maxFinite,
        child: isLoading.value
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: AppCurrency.values.map((currency) {
                  final isSelected = currency.code == currentCode;
                  return ListTile(
                    onTap: () => handleSelect(currency),
                    title: Text('${currency.code} (${currency.symbol})'),
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
          onPressed: isLoading.value ? null : () => Navigator.pop(context),
          child: Text(context.loc.cancel),
        ),
      ],
    );
  }
}
