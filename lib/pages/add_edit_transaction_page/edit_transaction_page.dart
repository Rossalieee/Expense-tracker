import 'dart:io';

import 'package:expense_tracker/app_spacers.dart';
import 'package:expense_tracker/expense_category.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/pages/add_edit_transaction_page/add_transaction_state.dart';
import 'package:expense_tracker/pages/add_edit_transaction_page/bloc/add_transaction_cubit.dart';
import 'package:expense_tracker/pages/add_edit_transaction_page/choice_chips.dart';
import 'package:expense_tracker/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditTransactionPage extends StatelessWidget {
  const EditTransactionPage({required this.transaction, super.key});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTransactionCubit(),
      child: _EditTransactionPage(transaction: transaction),
    );
  }
}

class _EditTransactionPage extends StatelessWidget {
  const _EditTransactionPage({required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final picker = ImagePicker();

    final title = transaction.title;
    var description = transaction.description ?? '';
    var amount = transaction.amount;

    return BlocBuilder<AddTransactionCubit, AddTransactionState>(
      builder: (context, state) {
        final cubit = context.read<AddTransactionCubit>();

        context.read<AddTransactionCubit>().editTransaction(
              date: transaction.date,
              isIncome: transaction.isIncome,
              type: transaction.isIncome
                  ? TransactionType.income
                  : TransactionType.expense,
              photo: transaction.photo,
              expenseCategory: transaction.expenseCategory,
            );

        void submitForm() {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();

            objectbox.updateTransaction(
              transaction.id,
              title: title,
              description: description.isEmpty ? null : description,
              amount: amount,
              date: transaction.date,
              isIncome: transaction.isIncome,
              photo: transaction.photo,
              expenseCategory: transaction.expenseCategory,
            );

            Navigator.pop(context);
            Navigator.pop(context);
          }
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Edit Transaction'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  AppSpacers.h5,
                  TextFormField(
                    initialValue: title,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                      contentPadding: EdgeInsets.all(10),
                    ),
                    onSaved: validateTitle,
                  ),
                  AppSpacers.h12,
                  TextFormField(
                    initialValue: description,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      contentPadding: EdgeInsets.all(8),
                    ),
                    onSaved: (value) => description = value!,
                  ),
                  AppSpacers.h12,
                  TextFormField(
                    initialValue: amount.toString(),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Amount',
                      contentPadding: EdgeInsets.all(8),
                    ),
                    onSaved: (value) => amount = double.parse(value!),
                    validator: validateAmount,
                  ),
                  AppSpacers.h12,
                  Center(
                    child: Wrap(
                      spacing: 6,
                      children: choiceChips(context, state, transaction,
                          isEditTransactionPage: true),
                    ),
                  ),
                  AppSpacers.h5,
                  Visibility(
                    visible: cubit.state.type == TransactionType.expense,
                    child: DropdownButtonFormField(
                      value: cubit.state.expenseCategory,
                      hint: const Text('Expense Category'),
                      isExpanded: true,
                      onChanged: validateExpenseCategory,
                      onSaved: (value) {
                        transaction.expenseCategory = value;
                        cubit.setExpenseCategory(value);
                      },
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
                    ),
                  ),
                  AppSpacers.h15,
                  OutlinedButton(
                    onPressed: () {
                      picker.pickImage(source: ImageSource.gallery).then(
                        (value) {
                          transaction.photo = value!.path;
                          cubit.selectPhoto(value.path);
                        },
                      );
                    },
                    child: const Text('Add photo'),
                  ),
                  if (cubit.state.photo != null)
                    Stack(
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
                            onPressed: () {
                              transaction.photo = null;
                              cubit.clearPhoto();
                            },
                          ),
                        )
                      ],
                    )
                  else
                    AppSpacers.h0,
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Transaction Date'),
                    subtitle: Text(DateFormat.yMMMd().format(cubit.state.date)),
                    onTap: () => showDatePicker(
                      context: context,
                      initialDate: state.date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    ).then((value) {
                      if (value != null) {
                        transaction.date = value;
                      }
                      cubit.selectDate(value);
                    }),
                  ),
                  AppSpacers.h15,
                  ElevatedButton(
                    onPressed: submitForm,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      minimumSize: const Size(60, 45),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
