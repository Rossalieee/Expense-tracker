import 'dart:io';

import 'package:expense_tracker/app_spacers.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/models/transaction_type.dart';
import 'package:expense_tracker/pages/add_edit_transaction_page/add_transaction_page.dart';
import 'package:expense_tracker/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDetailsPage extends StatelessWidget {
  const TransactionDetailsPage({required this.transaction, super.key});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final isIncome =
        TransactionType.fromString(transaction.type) == TransactionType.income;
    final formattedAmount = isIncome
        ? '+ ${transaction.amount.toStringAsFixed(2)}'
        : '- ${transaction.amount.toStringAsFixed(2)}';

    final formattedDate = DateFormat.yMMMd().format(transaction.date);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AddTransactionPage(
                  transaction: transaction,
                ),
              ),
            ),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Delete transaction'),
                content: const Text(
                  'Are you sure you want to delete this transaction?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      objectbox.removeTransaction(transaction.id);
                      Navigator.pop(context, 'OK');
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              AppSpacers.h15,
              Text(
                '$formattedAmount $choosenCurrency',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),
              AppSpacers.h8,
              Text(
                transaction.description ?? 'No description',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              AppSpacers.h15,
              if (transaction.photo != null)
                Container(
                  alignment: Alignment.center,
                  height: 240,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      File(transaction.photo!),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              AppSpacers.h8,
            ],
          ),
        ),
      ),
    );
  }
}
