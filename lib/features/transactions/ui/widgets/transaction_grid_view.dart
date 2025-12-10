import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/responsive_grid_view.dart';
import '../../domain/entities/transaction.dart';
import 'transaction_grid_item.dart';

class TransactionGridView extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(Transaction transaction)? onTap;
  final String? selectedTransactionId;

  const TransactionGridView({
    required this.transactions,
    this.onTap,
    this.selectedTransactionId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridView(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final isSelected = selectedTransactionId == transaction.id;
        return TransactionGridItem(
          transaction: transaction,
          isSelected: isSelected,
          onTap: onTap,
        );
      },
    );
  }
}
