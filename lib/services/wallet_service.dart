import 'package:flutter/material.dart';
import '../models/models.dart';

class WalletService {
  static List<WalletCard> getCards() {
    return [
      const WalletCard(
        id: '1',
        name: 'Visa Principal',
        number: '**** **** **** 1234',
        type: 'Visa',
        expiryDate: '12/25',
        color: Color(0xFF1A1A3E),
        isDefault: true,
      ),
      const WalletCard(
        id: '2',
        name: 'Mastercard',
        number: '**** **** **** 5678',
        type: 'Mastercard',
        expiryDate: '09/26',
        color: Color(0xFFEB001B),
      ),
      const WalletCard(
        id: '3',
        name: 'American Express',
        number: '**** **** **** 9012',
        type: 'Amex',
        expiryDate: '03/27',
        color: Color(0xFF006FCF),
      ),
    ];
  }
  
  static List<Transaction> getRecentTransactions() {
    return [
      Transaction(
        id: '1',
        description: 'Pago en Starbucks',
        amount: -12.50,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        type: TransactionType.payment,
        merchant: 'Starbucks',
      ),
      Transaction(
        id: '2',
        description: 'Transferencia recibida',
        amount: 150.00,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.transfer,
      ),
      Transaction(
        id: '3',
        description: 'Recarga de saldo',
        amount: 200.00,
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: TransactionType.topup,
      ),
      Transaction(
        id: '4',
        description: 'Compra en Amazon',
        amount: -89.99,
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: TransactionType.payment,
        merchant: 'Amazon',
      ),
      Transaction(
        id: '5',
        description: 'Reembolso',
        amount: 25.00,
        date: DateTime.now().subtract(const Duration(days: 4)),
        type: TransactionType.refund,
      ),
    ];
  }
  
  static String formatCurrency(double amount) {
    return '\$${amount.abs().toStringAsFixed(2)}';
  }
  
  static String formatTransactionAmount(double amount) {
    final prefix = amount >= 0 ? '+' : '-';
    return '$prefix\$${amount.abs().toStringAsFixed(2)}';
  }
}