import 'package:expense_tracker/app_spacers.dart';
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
              _AddGoalInput(
                label: 'Goal Description',
                onSaved: _goalDescriptionOnSaved,
                validator: validateGoalDescription,
              ),
              AppSpacers.h15,
              _AddGoalInput(
                label: 'Goal Amount',
                onSaved: _goalAmountOnSaved,
                validator: validateAmount,
                onChanged: _goalAmountOnChanged,
                isNumeric: true,
              ),
              AppSpacers.h15,
              _AddGoalInput(
                label: 'Collected Amount',
                onSaved: _collectedAmountOnSaved,
                validator: (value) =>
                    validateGoalCollectedAmount(value, _goalAmount),
                isNumeric: true,
                initialValue: '0.00',
              ),
              AppSpacers.h15,
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

  void _goalDescriptionOnSaved(String? newValue) =>
      _goalDescription = newValue!;

  void _goalAmountOnChanged(String value) => _goalAmount = double.parse(value);

  void _goalAmountOnSaved(String? newValue) =>
      _goalAmount = double.parse(newValue!);

  void _collectedAmountOnSaved(String? newValue) {
    _collectedAmount = double.parse(newValue!);
    if (_collectedAmount == _goalAmount) {
      _isFinished = true;
    } else {
      _isFinished = false;
    }
  }
}

class _AddGoalInput extends StatelessWidget {
  const _AddGoalInput({
    required this.label,
    required this.onSaved,
    this.onChanged,
    this.validator,
    this.isNumeric = false,
    this.initialValue,
  });

  final String label;
  final String? initialValue;
  final bool isNumeric;
  final void Function(String?) onSaved;
  final void Function(String)? onChanged;
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
      onChanged: onChanged,
      validator: validator,
    );
  }
}
