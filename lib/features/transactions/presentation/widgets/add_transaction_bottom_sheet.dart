import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constant/color_manager.dart';
import '../../../../core/extension/app_sizes.dart';
import '../../../../core/extension/text_style_extension.dart';
import '../../data/providers/transaction_providers.dart';
import '../../domain/models/transaction_model.dart';
import 'amount_input_area.dart';
import 'category_selector.dart';
import 'transaction_metadata_row.dart';
import 'transaction_type_toggle.dart';
import 'wallet_selector.dart';

class AddTransactionBottomSheet extends HookConsumerWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = useState(TransactionType.expense);
    final selectedCategory = useState<TransactionCategory?>(null);
    final selectedWallet = useState(context.loc.bank);
    final selectedDate = useState(DateTime.now());
    final amountController = useTextEditingController(text: '');
    final notesController = useTextEditingController();
    final isLoading = useState(false);

    useValueListenable(amountController);

    final wallets = [
      context.loc.bank,
      context.loc.cash,
      context.loc.paypal,
      context.loc.creditCard
    ];
    final categories = selectedType.value == TransactionType.expense
        ? [
            TransactionCategory.food,
            TransactionCategory.transport,
            TransactionCategory.shopping,
            TransactionCategory.entertainment,
            TransactionCategory.other,
          ]
        : [TransactionCategory.salary, TransactionCategory.other];

    final double amount = double.tryParse(amountController.text) ?? 0.0;
    final bool isFormValid =
        amount > 0 && selectedCategory.value != null && !isLoading.value;

    Future<void> handleSave() async {
      if (!isFormValid) return;

      isLoading.value = true;
      try {
        final transaction = TransactionModel(
          amount: amount,
          type: selectedType.value,
          category: selectedCategory.value!,
          title: notesController.text.isEmpty
              ? selectedCategory.value!.name.toUpperCase()
              : notesController.text,
          date: selectedDate.value,
        );

        await ref
            .read(transactionRepositoryProvider)
            .addTransaction(transaction);
        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        isLoading.value = false;
      }
    }

    return Container(
      decoration: const BoxDecoration(
        color: ColorManager.darkBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ColorManager.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
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
                WalletSelector(
                  wallets: wallets,
                  selectedWallet: selectedWallet.value,
                  onSelect: (val) => selectedWallet.value = val,
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
                      disabledBackgroundColor: ColorManager.white.withValues(
                        alpha: 0.05,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading.value
                        ? const CircularProgressIndicator(
                            color: ColorManager.white,
                          )
                        : Text(
                            context.loc.saveTransaction,
                            style: context.labelLarge.copyWith(
                              color: isFormValid
                                  ? ColorManager.white
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
          if (isLoading.value)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.1),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
