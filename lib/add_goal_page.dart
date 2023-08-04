import 'package:expense_tracker/app_consts.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/validation.dart';
import 'package:flutter/material.dart';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({super.key});

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

double _goalAmount = 0;
double _collectedAmount = 0;
String _goalDescription = '';
bool _isFinished = false;
final _formKey = GlobalKey<FormState>();

void submitForm() {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    objectbox.addGoal(
      description: _goalDescription,
      goalAmount: _goalAmount,
      collectedAmount: _collectedAmount,
      isFinished: _isFinished,
    );

    _formKey.currentState!.reset();
  }
}

class _AddGoalPageState extends State<AddGoalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Goal Description',
                ),
                validator: validateDescription,
                onSaved: (newValue) {
                  _goalDescription = newValue!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Goal Amount',
                ),
                validator: validateAmount,
                onSaved: (newValue) {
                  _goalAmount = double.parse(newValue!);
                },
                onChanged: (value) {
                  _goalAmount = double.parse(value);
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                initialValue: _collectedAmount.toString(),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Collected Amount',
                ),
                validator: validateCollectedAmount,
                onSaved: (newValue) {
                  _collectedAmount = double.parse(newValue!);
                  if (_collectedAmount == _goalAmount) {
                    _isFinished = true;
                  } else {
                    _isFinished = false;
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              const ElevatedButton(
                onPressed: submitForm,
                child: Text('Add Goal'),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? validateDescription(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter a goal description';
    }
    return null;
  }

  String? validateCollectedAmount(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter an amount';
    }

    if (value!.contains('.') && value.split('.')[1].length > 2) {
      return 'Only two digits after the decimal point are allowed';
    }

    if (!numericRegex.hasMatch(value)) {
      return 'Invalid amount format';
    }

    if (double.parse(value) > _goalAmount) {
      return 'Collected amount cannot be greater than goal amount';
    }

    return null;
  }
}
