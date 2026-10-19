import 'package:flutter/material.dart';

const List<String> walletIconChoices = [
  'payments',
  'account_balance',
  'account_balance_wallet',
  'more_horiz',
  'credit_card',
  'savings',
  'shopping_bag',
  'home',
];

IconData walletIconData(String name) {
  switch (name) {
    case 'payments':
      return Icons.payments;
    case 'account_balance':
      return Icons.account_balance;
    case 'account_balance_wallet':
      return Icons.account_balance_wallet;
    case 'more_horiz':
      return Icons.more_horiz;
    case 'credit_card':
      return Icons.credit_card;
    case 'savings':
      return Icons.savings;
    case 'shopping_bag':
      return Icons.shopping_bag;
    case 'home':
      return Icons.home;
    default:
      return Icons.account_balance_wallet_outlined;
  }
}
