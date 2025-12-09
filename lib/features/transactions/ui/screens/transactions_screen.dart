import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/widgets/responsive_layout.dart';
import 'package:plata_sync/features/transactions/ui/screens/mobile_transactions_screen.dart';
import 'package:plata_sync/features/transactions/ui/screens/tablet_transactions_screen.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (context) => const MobileTransactionsScreen(),
      tabletOrLarger: (context) => const TabletTransactionsScreen(),
    );
  }
}
