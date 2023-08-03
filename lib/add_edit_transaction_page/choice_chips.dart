import 'package:expense_tracker/add_edit_transaction_page/bloc/add_transaction_cubit.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final List<String> chipsChoiceList = ['Income', 'Expense'];

List<Widget> choiceChips(
  BuildContext context,
  AddTransactionState state,
  TransactionModel? transaction, {
  required bool edit,
}) {
  final chips = <Widget>[];
  final cubit = context.read<AddTransactionCubit>();
  for (var i = 0; i < chipsChoiceList.length; i++) {
    final Widget item = ChoiceChip(
      label: Text(chipsChoiceList[i]),
      selected: cubit.state.selectedIndex == i,
      onSelected: (bool value) {
        cubit.setIndex(i);
        if (cubit.state.selectedIndex == 0) {
          cubit
            ..clearExpenseCategory()
            ..setIsIncome(value: true);
          if (edit == true) {transaction!.expenseCategory = null;
          transaction.isIncome = true;}
        } else {
          cubit.setIsIncome(value: false);
          if (edit == true) {transaction!.isIncome = false;}
        }
      },
    );
    chips.add(item);
  }
  return chips;
}
