class User {
  final String username;
  final String name;
  final double balance;

  const User({
    required this.username,
    required this.name,
    required this.balance,
  });
}

class WalletCard {
  final String id;
  final String name;
  final String number;
  final String type;
  final String expiryDate;
  final Color color;
  final bool isDefault;

  const WalletCard({
    required this.id,
    required this.name,
    required this.number,
    required this.type,
    required this.expiryDate,
    required this.color,
    this.isDefault = false,
  });
}

class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String? merchant;

  const Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    this.merchant,
  });
}

enum TransactionType { 
  payment, 
  transfer, 
  topup, 
  refund 
}

import 'package:flutter/material.dart';