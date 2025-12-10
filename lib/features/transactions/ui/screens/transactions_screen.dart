import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/responsive_layout.dart';
import 'mobile_transactions_screen.dart';
import 'tablet_transactions_screen.dart';

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
