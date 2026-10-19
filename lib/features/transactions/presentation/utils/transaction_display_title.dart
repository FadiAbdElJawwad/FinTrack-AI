import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/models/transaction_model.dart';
import 'transaction_category_extension.dart';

bool isAutoTitle(TransactionModel t) {
  final trimmedTitle = t.title.trim();
  if (trimmedTitle.isEmpty) {
    return true;
  }
  for (final locale in AppLocalizations.supportedLocales) {
    final loc = lookupAppLocalizations(locale);
    final catName = t.category.localizedNameFor(loc).trim();
    if (trimmedTitle == catName) {
      return true;
    }
  }
  return false;
}

String transactionDisplayTitle(BuildContext context, TransactionModel t) {
  return isAutoTitle(t) ? t.category.getLocalizedName(context) : t.title;
}
