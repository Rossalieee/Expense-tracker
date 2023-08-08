import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/models/transaction_type.dart';
import 'package:expense_tracker/pages/add_edit_transaction_page/add_transaction_state.dart';
import 'package:expense_tracker/pages/add_edit_transaction_page/bloc/add_transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


List<Widget> choiceChips(
  BuildContext context,
  AddTransactionState state,
  TransactionModel? transaction,
) {
  final cubit = context.read<AddTransactionCubit>();

  final chips = TransactionType.values
      .map(
        (e) => ChoiceChip(
          label: Text(e.name),
          selected: cubit.state.type == e,
          onSelected: (bool value) {
            cubit.setType(e);
            if (cubit.state.type == TransactionType.income) {
              cubit.clearExpenseCategory();
            }
          },
        ),
      )
      .toList();

  return chips;
}
