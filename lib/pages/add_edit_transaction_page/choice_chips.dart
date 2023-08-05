import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/pages/add_edit_transaction_page/add_transaction_state.dart';
import 'package:expense_tracker/pages/add_edit_transaction_page/bloc/add_transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final List<String> transactionType = ['Income', 'Expense'];

enum TransactionType {
  income('Income'),
  expense('Expense');

  const TransactionType(this.name);

  final String name;
}

List<Widget> choiceChips(
  BuildContext context,
  AddTransactionState state,
  TransactionModel? transaction, {
  required bool isEditTransactionPage,
}) {
  final cubit = context.read<AddTransactionCubit>();

  final chips = TransactionType.values
      .map(
        (e) => ChoiceChip(
          label: Text(e.name),
          selected: cubit.state.type == e,
          onSelected: (bool value) {
            cubit.setType(e);
            if (cubit.state.type == TransactionType.income) {
              cubit
                ..clearExpenseCategory()
                ..setIsIncome(value: true);
              if (isEditTransactionPage) {
                transaction!.expenseCategory = null;
                transaction.isIncome = true;
              }
            } else {
              cubit.setIsIncome(value: false);
              if (isEditTransactionPage) {
                transaction!.isIncome = false;
              }
            }
          },
        ),
      )
      .toList();

  return chips;
}
