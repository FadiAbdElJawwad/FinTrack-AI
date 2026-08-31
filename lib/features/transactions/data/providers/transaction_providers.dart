import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/models/transaction_model.dart';
import '../repositories/firestore_transaction_repository.dart';
import '../repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return FirestoreTransactionRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

final transactionsStreamProvider =
    StreamProvider.autoDispose<List<TransactionModel>>((ref) {
      final repository = ref.watch(transactionRepositoryProvider);
      return repository.getTransactionsStream();
    });

final transactionTypeFilterProvider =
    StateProvider.autoDispose<TransactionType?>((ref) => null);
final transactionDateRangeFilterProvider =
    StateProvider.autoDispose<DateTimeRange?>((ref) => null);

final filteredTransactionsProvider =
    Provider.autoDispose<Map<String, List<TransactionModel>>>((ref) {
      final transactionsAsync = ref.watch(transactionsStreamProvider);
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

Map<String, List<TransactionModel>> groupTransactions(
  List<TransactionModel> txs,
) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final startOfMonth = DateTime(now.year, now.month, 1);

  final Map<String, List<TransactionModel>> grouped = {
    'TODAY': [],
    'YESTERDAY': [],
    'THIS MONTH': [],
  };

  for (final tx in txs) {
    final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);

    if (txDate == today) {
      grouped['TODAY']!.add(tx);
    } else if (txDate == yesterday) {
      grouped['YESTERDAY']!.add(tx);
    } else if (tx.date.isAfter(startOfMonth) ||
        tx.date.isAtSameMomentAs(startOfMonth)) {
      grouped['THIS MONTH']!.add(tx);
    }
  }

  grouped.removeWhere((key, value) => value.isEmpty);
  return grouped;
}
