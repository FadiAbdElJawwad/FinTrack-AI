import '../../../../l10n/app_localizations.dart';
import '../../domain/models/wallet_model.dart';

String walletDisplayName(AppLocalizations loc, WalletModel wallet) {
  switch (wallet.id) {
    case 'cash':
      if (wallet.name == 'Cash') return loc.defaultWalletName;
    case 'bank':
      if (wallet.name == 'Bank Account') return loc.walletNameBank;
    case 'paypal':
      if (wallet.name == 'PayPal') return loc.walletNamePaypal;
    case 'other':
      if (wallet.name == 'Other') return loc.walletNameOther;
  }
  return wallet.name;
}
