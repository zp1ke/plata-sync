import 'package:flutter/material.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.categoriesScreenTitle)),
      body: Center(child: Text(l10n.categoriesScreenBody)),
    );
  }
}
