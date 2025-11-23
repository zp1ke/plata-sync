import 'package:flutter/material.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.transactionsScreenTitle)),
      body: Center(child: Text(l10n.transactionsScreenBody)),
    );
  }
}
