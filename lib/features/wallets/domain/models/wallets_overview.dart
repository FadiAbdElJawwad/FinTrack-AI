import '../../../currency/domain/models/app_currency.dart';
import 'wallet_model.dart';

class WalletBalance {
  const WalletBalance({
    required this.wallet,
    required this.balanceMinor,
  });

  final WalletModel wallet;
  final int? balanceMinor;
}

class WalletsOverview {
  const WalletsOverview({
    required this.currency,
    required this.wallets,
    required this.unassignedMinor,
    required this.totalMinor,
  });

  final AppCurrency currency;
  final List<WalletBalance> wallets;
  final int? unassignedMinor;
  final int? totalMinor;
}
