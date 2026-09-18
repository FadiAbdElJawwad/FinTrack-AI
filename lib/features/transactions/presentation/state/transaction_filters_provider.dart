import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/usecases/group_transactions_usecase.dart';
import 'transaction_controller.dart';

final transactionTypeFilterProvider =
    StateProvider.autoDispose<TransactionType?>((ref) => null);

final transactionDateRangeFilterProvider =
    StateProvider.autoDispose<DateTimeRange?>((ref) => null);

final filteredTransactionsProvider =
    Provider.autoDispose<Map<String, List<TransactionModel>>>((ref) {
      final transactionsAsync = ref.watch(transactionControllerProvider);
      final typeFilter = ref.watch(transactionTypeFilterProvider);
      final dateFilter = ref.watch(transactionDateRangeFilterProvider);

      return transactionsAsync.when(
        data: (transactions) {
          final grouped = groupTransactions(transactions);
          return Map.fromEntries(
            grouped.entries
                .map((e) {
                  final filteredList = e.value.where((tx) {
                    final typeMatch =
                        typeFilter == null || tx.type == typeFilter;
                    final dateMatch =
                        dateFilter == null ||
                        (tx.date.isAfter(
                              dateFilter.start.subtract(
                                const Duration(seconds: 1),
                              ),
                            ) &&
                            tx.date.isBefore(
                              dateFilter.end.add(const Duration(days: 1)),
                            ));
                    return typeMatch && dateMatch;
                  }).toList();
                  return MapEntry(e.key, filteredList);
                })
                .where((e) => e.value.isNotEmpty),
          );
        },
        loading: () => {},
        error: (e, st) => {},
      );
    });
