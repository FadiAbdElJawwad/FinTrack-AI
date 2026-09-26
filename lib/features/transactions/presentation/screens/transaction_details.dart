import 'package:fin_track_ai/core/services/share_service.dart';
import '../../../../core/extension/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constant/color_manager.dart';
import '../../../../core/extension/text_style_extension.dart';
import '../../../wallets/domain/models/wallet_model.dart';
import '../../../wallets/presentation/state/wallet_controller.dart';
import '../state/transaction_controller.dart';
import '../utils/transaction_ui_extension.dart';
import '../widgets/add_transaction_bottom_sheet.dart';

class TransactionDetails extends HookConsumerWidget {
  final String transactionId;
  const TransactionDetails({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState<bool>(false);
    final isSharing = useState<bool>(false);
    final receiptKey = useMemoized(() => GlobalKey());

    Future<void> shareTransactionImage(String title) async {
      isSharing.value = true;
      try {
        await ShareService.shareWidgetAsImage(
          key: receiptKey,
          fileName: 'transaction_receipt.png',
          pixelRatio: MediaQuery.of(context).devicePixelRatio,
          text: '${context.loc.transactionDetails}: $title',
        );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error sharing receipt: $e')));
        }
      } finally {
        if (context.mounted) isSharing.value = false;
      }
    }

    Future<void> handleDelete() async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.loc.deleteTransaction),
          content: Text(context.loc.deleteConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.loc.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                context.loc.delete,
                style: const TextStyle(color: ColorManager.errorColor),
              ),
            ),
          ],
        ),
      );

      if (confirm == true) {
        isLoading.value = true;
        try {
          await ref
              .read(transactionControllerProvider.notifier)
              .deleteTransaction(transactionId);
          if (context.mounted) {
            Navigator.pop(context);
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error deleting transaction: $e')),
            );
          }
        } finally {
          if (context.mounted) isLoading.value = false;
        }
      }
    }

    final transactionsAsyncValue = ref.watch(transactionControllerProvider);
    final walletsAsyncValue = ref.watch(walletControllerProvider);

    return transactionsAsyncValue.when(
      data: (transactions) {
        final transaction = transactions
            .where((tx) => tx.id == transactionId)
            .firstOrNull;

        if (transaction == null) {
          return Scaffold(
            body: Center(child: Text(context.loc.transactionDeleted)),
          );
        }

        final walletName = walletsAsyncValue.maybeWhen(
          data: (wallets) {
            final wallet = wallets.firstWhere(
              (w) => w.id == transaction.walletId,
              orElse: () => WalletModel(name: context.loc.unknownWallet, icon: ''),
            );
            return wallet.name;
          },
          orElse: () => context.loc.unknownWallet,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(context.loc.transactionDetails),
            centerTitle: true,
            actions: [
              isSharing.value
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: () =>
                          shareTransactionImage(transaction.title),
                      icon: const Icon(Icons.share),
                    ),
            ],
          ),
          bottomNavigationBar: isLoading.value
              ? const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AddTransactionBottomSheet(
                            existingTransaction: transaction,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        side: const BorderSide(
                          color: ColorManager.secondaryColor,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.edit,
                            color: ColorManager.secondaryColor,
                          ),
                          context.addHorizontalSpace(8),
                          Text(
                            context.loc.editTransaction,
                            style: context.labelLarge.copyWith(
                              color: ColorManager.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: handleDelete,
                      child: Text(
                        context.loc.delete,
                        style: context.labelLarge.copyWith(
                          color: ColorManager.errorColor,
                        ),
                      ),
                    ),
                  ],
                ).padSymmetric(20),
          body: SafeArea(
            child: SingleChildScrollView(
              child: RepaintBoundary(
                key: receiptKey,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        color: ColorManager.primaryBlue.withValues(alpha: 0.1),
                        shape: const StadiumBorder(),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Icon(
                            transaction.categoryIcon,
                            size: 48,
                            color: ColorManager.primaryBlue,
                          ),
                        ),
                      ),
                      context.addVerticalSpace(24),
                      Text(
                        transaction.category.name,
                        style: context.headlineMedium,
                      ),
                      Text(
                        transaction.formattedAmount,
                        style: context.headlineMedium.copyWith(
                          color: transaction.amountColor,
                        ),
                      ),
                      context.addVerticalSpace(8),
                      Text(
                        DateFormat(
                          'EEEE, dd MMMM yyyy, hh:mm a',
                        ).format(transaction.date),
                        style: context.bodyMedium,
                      ),
                      context.addVerticalSpace(40),
                      Card(
                        child: Column(
                          children: [
                            _DetailRow(
                              label: context.loc.status,
                              value: context.loc.completed,
                            ),
                            const Divider(color: ColorManager.secondaryColor),
                            context.addVerticalSpace(16),
                            _DetailRow(
                              label: context.loc.category,
                              value: transaction.category.name.toUpperCase(),
                            ),
                            const Divider(color: ColorManager.secondaryColor),
                            context.addVerticalSpace(16),
                            _DetailRow(
                              label: context.loc.paymentMethod,
                              value: walletName,
                            ),
                            const Divider(color: ColorManager.secondaryColor),
                            context.addVerticalSpace(16),
                            _DetailRow(
                              label: context.loc.type,
                              value: transaction.type.name.toUpperCase(),
                            ),
                          ],
                        ).pad(24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: ${e.toString()}')),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.bodyMedium),
        Text(value, style: context.labelMedium),
      ],
    );
  }
}
