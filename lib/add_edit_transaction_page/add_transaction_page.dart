import 'dart:io';

import 'package:expense_tracker/add_edit_transaction_page/bloc/add_transaction_cubit.dart';
import 'package:expense_tracker/add_edit_transaction_page/choice_chips.dart';
import 'package:expense_tracker/expense_category.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTransactionCubit(),
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

        var title = '';
        var description = '';
        var amount = 0.0;

        void submitForm() {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            objectbox.addTransaction(
              title: title,
              description: description.isEmpty ? null : description,
              amount: amount,
              date: state.date,
              isIncome: state.isIncome,
              photo: state.photo,
              expenseCategory: state.expenseCategory,
            );

            _formKey.currentState!.reset();

            cubit.clearPhoto();
          }
        }

        return Scaffold(
          appBar: AppBar(centerTitle: true,
            title: const Text('Add Transaction'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                      contentPadding: EdgeInsets.all(10),
                    ),
                    onSaved: (value) {
                      title = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      if (value.length > 40) {
                        return "Title can't be longer than 40 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      contentPadding: EdgeInsets.all(8),
                    ),
                    onSaved: (value) {
                      description = value!;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Amount',
                      contentPadding: EdgeInsets.all(8),
                    ),
                    onSaved: (value) {
                      amount = double.parse(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }

                      if (value.contains('.') &&
                          value.split('.')[1].length > 2) {
                        return 'Only two digits after the decimal point are allowed';
                      }

                      final numericRegex = RegExp(r'^\d+(\.\d{1,2})?$');
                      if (!numericRegex.hasMatch(value)) {
                        return 'Invalid amount format';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: Wrap(
                      spacing: 6,
                      children: choiceChips(context, state, null, edit: false),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: cubit.state.selectedIndex == 1,
                    child: DropdownButtonFormField(
                      value: cubit.state.expenseCategory,
                      hint: const Text(
                        'Expense Category',
                      ),
                      isExpanded: true,
                      onChanged: cubit.setExpenseCategory,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an expense category';
                        }
                        return null;
                      },
                      onSaved: cubit.setExpenseCategory,
                      items: ExpenseCategory.values.map((e) {
                        return DropdownMenuItem(
                          value: e.name,
                          child: Row(
                            children: [
                              Icon(e.icon),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(e.name),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      picker.pickImage(source: ImageSource.gallery).then(
                            (value) => cubit.selectPhoto(value!.path),
                          );
                    },
                    child: const Text(
                      'Add photo',
                    ),
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
                            onPressed: cubit.clearPhoto,
                          ),
                        )
                      ],
                    )
                  else
                    const SizedBox(height: 0),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Transaction Date'),
                    subtitle: Text(DateFormat.yMMMd().format(cubit.state.date)),
                    onTap: () => showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    ).then(cubit.selectDate),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: submitForm,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      minimumSize: const Size(60, 45),
                    ),
                    child: const Text('Save Transaction'),
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
