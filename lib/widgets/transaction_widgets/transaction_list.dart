import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/wallet_service.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final bool showAll;
  
  const TransactionList({
    super.key,
    required this.transactions,
    this.showAll = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayTransactions = showAll ? transactions : transactions.take(5).toList();
    
    return Column(
      children: [
        ...displayTransactions.map((transaction) => 
          TransactionItem(transaction: transaction)
        ).toList(),
        if (!showAll && transactions.length > 5)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextButton(
              onPressed: () {
                // Navigate to full transaction history
                _showAllTransactions(context);
              },
              child: Text('Ver todas las transacciones (${transactions.length})'),
            ),
          ),
      ],
    );
  }
  
  void _showAllTransactions(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Todas las Transacciones'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TransactionList(
                transactions: transactions,
                showAll: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  
  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getTransactionColor(transaction.type).withOpacity(0.1),
          child: Icon(
            _getTransactionIcon(transaction.type),
            color: _getTransactionColor(transaction.type),
          ),
        ),
        title: Text(
          transaction.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transaction.merchant != null)
              Text(
                transaction.merchant!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            Text(
              _formatDate(transaction.date),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: Text(
          WalletService.formatTransactionAmount(transaction.amount),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: transaction.amount >= 0 
                ? Colors.green.shade600 
                : Colors.red.shade600,
          ),
        ),
        isThreeLine: transaction.merchant != null,
      ),
    );
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.payment:
        return Icons.shopping_cart;
      case TransactionType.transfer:
        return Icons.swap_horiz;
      case TransactionType.topup:
        return Icons.add_circle;
      case TransactionType.refund:
        return Icons.undo;
    }
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.payment:
        return Colors.blue;
      case TransactionType.transfer:
        return Colors.orange;
      case TransactionType.topup:
        return Colors.green;
      case TransactionType.refund:
        return Colors.purple;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Hace ${difference.inMinutes} minutos';
      }
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}