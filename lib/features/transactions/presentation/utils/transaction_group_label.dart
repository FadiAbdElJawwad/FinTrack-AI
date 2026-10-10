import '../../../../l10n/app_localizations.dart';
import '../../domain/usecases/group_transactions_usecase.dart';

extension TransactionGroupLabel on TransactionGroup {
  String label(AppLocalizations loc) {
    return switch (this) {
      TransactionGroup.upcoming => loc.groupUpcoming,
      TransactionGroup.today => loc.groupToday,
      TransactionGroup.yesterday => loc.groupYesterday,
      TransactionGroup.thisMonth => loc.groupThisMonth,
      TransactionGroup.earlier => loc.groupEarlier,
    };
  }
}
