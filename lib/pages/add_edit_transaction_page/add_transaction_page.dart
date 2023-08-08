import 'dart:io';

import 'package:expense_tracker/app_spacers.dart';
import 'package:expense_tracker/models/expense_category.dart';
import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/models/transaction_type.dart';
import 'package:expense_tracker/pages/add_edit_transaction_page/add_transaction_state.dart';
import 'package:expense_tracker/pages/add_edit_transaction_page/bloc/add_transaction_cubit.dart';
import 'package:expense_tracker/pages/add_edit_transaction_page/choice_chips.dart';
import 'package:expense_tracker/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key, this.transaction});

  final TransactionModel? transaction;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTransactionCubit()..initialize(transaction),
      child: _AddTransactionPage(),
    );
  }
}

class _AddTransactionPage extends StatelessWidget {
  _AddTransactionPage();

  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionCubit, AddTransactionState>(
      builder: (context, state) {
        final cubit = context.read<AddTransactionCubit>();

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title:
                Text(state.editMode ? 'Edit Transaction' : 'Add Transaction'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  AppSpacers.h5,
                  _AddTransactionInput(
                    label: 'Title',
                    onSaved: cubit.setTitle,
                    validator: validateTitle,
                    initialValue: state.title,
                  ),
                  AppSpacers.h12,
                  _AddTransactionInput(
                    label: 'Description',
                    onSaved: cubit.setDescription,
                    initialValue: state.description,
                  ),
                  AppSpacers.h12,
                  _AddTransactionInput(
                    label: 'Amount',
                    onSaved: (value) =>
                        cubit.setAmount(double.tryParse(value!)),
                    isNumeric: true,
                    validator: validateAmount,
                    initialValue:
                        state.editMode ? state.amount.toString() : null,
                  ),
                  AppSpacers.h12,
                  Center(
                    child: Wrap(
                      spacing: 6,
                      children: choiceChips(
                        context,
                        state,
                        null,
                      ),
                    ),
                  ),
                  AppSpacers.h5,
                  Visibility(
                    visible: state.type == TransactionType.expense,
                    child: ExpenseCategoryDropdown(cubit: cubit),
                  ),
                  AppSpacers.h15,
                  OutlinedButton(
                    onPressed: () {
                      picker.pickImage(source: ImageSource.gallery).then(
                            (value) => cubit.setPhoto(value?.path),
                          );
                    },
                    child: const Text('Add photo'),
                  ),
                  if (state.photo != null)
                    ShowPhoto(cubit: cubit)
                  else
                    AppSpacers.h0,
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Transaction Date'),
                    subtitle: Text(DateFormat.yMMMd().format(state.date)),
                    onTap: () => showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    ).then(cubit.setDate),
                  ),
                  AppSpacers.h15,
                  ElevatedButton(
                    onPressed: () =>
                        submitForm(context, editMode: state.editMode),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      minimumSize: const Size(60, 45),
                    ),
                    child: Text(
                      state.editMode ? 'Save changes' : 'Save Transaction',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void submitForm(BuildContext context, {required bool editMode}) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (editMode) {
        context.read<AddTransactionCubit>().updateTransaction();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        context.read<AddTransactionCubit>().addTransaction();
        _formKey.currentState!.reset();
      }
    }
  }
}

class _AddTransactionInput extends StatelessWidget {
  const _AddTransactionInput({
    required this.label,
    required this.onSaved,
    this.validator,
    this.isNumeric = false,
    this.initialValue,
  });

  final String label;
  final String? initialValue;
  final bool isNumeric;
  final void Function(String?) onSaved;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: isNumeric
          ? const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            )
          : TextInputType.text,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        contentPadding: const EdgeInsets.all(8),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}

class ShowPhoto extends StatelessWidget {
  const ShowPhoto({
    required this.cubit,
    super.key,
  });

  final AddTransactionCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          height: 240,
          child: Image.file(
            File(cubit.state.photo!),
            fit: BoxFit.fill,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: const Icon(Icons.cancel_outlined),
            onPressed: cubit.clearPhoto,
          ),
        )
      ],
    );
  }
}

class ExpenseCategoryDropdown extends StatelessWidget {
  const ExpenseCategoryDropdown({
    required this.cubit,
    super.key,
  });

  final AddTransactionCubit cubit;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: cubit.state.expenseCategory,
      hint: const Text('Expense Category'),
      isExpanded: true,
      onChanged: cubit.setExpenseCategory,
      validator: validateExpenseCategory,
      onSaved: cubit.setExpenseCategory,
      items: ExpenseCategory.values.map((e) {
        return DropdownMenuItem(
          value: e.name,
          child: Row(
            children: [
              Icon(e.icon),
              AppSpacers.w10,
              Text(e.name),
            ],
          ),
        );
      }).toList(),
    );
  }
}
