import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constant/color_manager.dart';
import '../../../../core/extension/app_sizes.dart';
import '../../../../core/extension/text_style_extension.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/bottom_sheet_drag_handle.dart';
import '../../domain/models/transaction_model.dart';
import '../../../currency/data/services/exchange_rate_service.dart';
import '../../../currency/domain/models/app_currency.dart';
import '../../../currency/presentation/state/currency_controller.dart';
import '../../../wallets/presentation/state/wallet_controller.dart';
import '../state/transaction_controller.dart';
import '../utils/transaction_category_extension.dart';
import '../utils/error_message.dart';
import 'amount_input_area.dart';
import 'category_selector.dart';
import 'transaction_metadata_row.dart';
import 'transaction_type_toggle.dart';
import 'wallet_selector.dart';

class AddTransactionBottomSheet extends HookConsumerWidget {
  final TransactionModel? existingTransaction;
  final TransactionDraft? prefillDraft;

  const AddTransactionBottomSheet({
    super.key,
    this.existingTransaction,
    this.prefillDraft,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = useState(
      existingTransaction?.type ??
          prefillDraft?.type ??
          TransactionType.expense,
    );
    final selectedCategory = useState<TransactionCategory?>(
      existingTransaction?.category ?? prefillDraft?.category,
    );
    final selectedWalletId = useState<String?>(existingTransaction?.walletId);
    final selectedDate = useState(
      existingTransaction?.date ?? prefillDraft?.date ?? DateTime.now(),
    );
    final amountController = useTextEditingController(
      text: existingTransaction != null
          ? existingTransaction!.amount.toString()
          : (prefillDraft != null ? prefillDraft!.amount.toString() : ''),
    );
    final notesController = useTextEditingController(
      text: existingTransaction?.title ?? prefillDraft?.title ?? '',
    );
    final isLoading = useState(false);

    useValueListenable(amountController);

    final walletsAsync = ref.watch(walletControllerProvider);
    final wallets = walletsAsync.valueOrNull ?? [];

    final appCurrencyCode =
        ref.watch(currencyControllerProvider).valueOrNull ?? 'USD';
    final selectedInputCurrency = useState(
      appCurrencyFromCode(appCurrencyCode),
    );

    useEffect(() {
      if (selectedWalletId.value == null && wallets.isNotEmpty) {
        selectedWalletId.value = wallets
            .firstWhere((w) => w.isDefault, orElse: () => wallets.first)
            .id;
      }
      return null;
    }, [wallets.length]);

    useEffect(() {
      selectedInputCurrency.value = appCurrencyFromCode(appCurrencyCode);
      return null;
    }, [appCurrencyCode]);

    final categories = categoriesForType(selectedType.value);

    final double amount = double.tryParse(amountController.text) ?? 0.0;
    final bool isFormValid =
        amount > 0 &&
        selectedCategory.value != null &&
        selectedWalletId.value != null &&
        !isLoading.value;

    Future<void> handleSave() async {
      if (!isFormValid) return;

      isLoading.value = true;
      try {
        final rateService = ref.read(exchangeRateServiceProvider);
        await rateService.ensureLoaded();
        if (!context.mounted) return;
        final rate = rateService.rateBetween(
          selectedInputCurrency.value.code,
          appCurrencyCode,
        );

        final transaction = _buildTransactionFromForm(
          existingTransaction: existingTransaction,
          amount: amount * rate,
          type: selectedType.value,
          category: selectedCategory.value!,
          notesText: notesController.text,
          date: selectedDate.value,
          context: context,
          walletId: selectedWalletId.value!,
        );

        if (existingTransaction == null) {
          await ref
              .read(transactionControllerProvider.notifier)
              .addTransaction(transaction);
        } else {
          await ref
              .read(transactionControllerProvider.notifier)
              .updateTransaction(transaction);
        }

        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(errorMessage(context, e))));
        }
      } finally {
        isLoading.value = false;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BottomSheetDragHandle(),
                context.addVerticalSpace(20),
                TransactionTypeToggle(
                  selectedType: selectedType.value,
                  onChanged: (TransactionType type) {
                    selectedType.value = type;
                    selectedCategory.value = null;
                  },
                ),
                context.addVerticalSpace(32),
                AmountInputArea(
                  controller: amountController,
                  type: selectedType.value,
                  currency: selectedInputCurrency.value,
                  onCurrencyChanged: (currency) =>
                      selectedInputCurrency.value = currency,
                ),
                context.addVerticalSpace(24),
                TransactionMetadataRow(
                  selectedDate: selectedDate.value,
                  notesController: notesController,
                  onDateTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate.value,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) selectedDate.value = picked;
                  },
                ),
                context.addVerticalSpace(24),
                Text(
                  context.loc.selectWallet,
                  style: context.labelSmall.copyWith(
                    color: ColorManager.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                context.addVerticalSpace(12),
                if (walletsAsync.hasError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      errorMessage(context, walletsAsync.error!),
                      style: context.labelSmall.copyWith(
                        color: ColorManager.errorColor,
                      ),
                    ),
                  ),
                WalletSelector(
                  wallets: wallets,
                  selectedWalletId: selectedWalletId.value,
                  onSelect: (val) => selectedWalletId.value = val,
                ),
                const SizedBox(height: 24),
                Text(
                  context.loc.category,
                  style: context.labelSmall.copyWith(
                    color: ColorManager.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                CategorySelector(
                  categories: categories,
                  selectedCategory: selectedCategory.value,
                  onSelect: (cat) => selectedCategory.value = cat,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isFormValid ? handleSave : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryBlue,
                      disabledBackgroundColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            existingTransaction == null
                                ? context.loc.saveTransaction
                                : context.loc.editTransaction,
                            style: context.labelLarge.copyWith(
                              color: isFormValid
                                  ? Colors.white
                                  : ColorManager.secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ).padSymmetric(20).padTop(16),
          ),
          if (isLoading.value) const LoadingOverlay(),
        ],
      ),
    );
  }
}

TransactionModel _buildTransactionFromForm({
  required TransactionModel? existingTransaction,
  required double amount,
  required TransactionType type,
  required TransactionCategory category,
  required String notesText,
  required DateTime date,
  required BuildContext context,
  required String walletId,
}) {
  return TransactionModel(
    id: existingTransaction?.id,
    amount: amount,
    type: type,
    category: category,
    title: notesText.isEmpty ? category.getLocalizedName(context) : notesText,
    date: date,
    walletId: walletId,
  );
}
