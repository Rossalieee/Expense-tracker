import 'package:expense_tracker/app_consts.dart';

String? validateExpenseCategory(String? value) {
    if (value == null) {
      return 'Please select an expense category';
    }
    return null;
  }

  String? validateTitle(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter a title';
    }
    if (value!.length > 40) {
      return "Title can't be longer than 40 characters";
    }
    return null;
  }

  String? validateAmount(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter an amount';
    }

    if (value!.contains('.') && value.split('.')[1].length > 2) {
      return 'Only two digits after the decimal point are allowed';
    }

    if (!AppConsts.numericRegex.hasMatch(value)) {
      return 'Invalid amount format';
    }

    return null;
  }

  String? validateGoalCollectedAmount(String? value, double goalAmount) {
    if (value?.isEmpty ?? true) {
      return 'Please enter an amount';
    }

    if (value!.contains('.') && value.split('.')[1].length > 2) {
      return 'Only two digits after the decimal point are allowed';
    }

    if (!AppConsts.numericRegex.hasMatch(value)) {
      return 'Invalid amount format';
    }

    if (double.parse(value) > goalAmount) {
      return 'Collected amount cannot be greater than goal amount';
    }

    return null;
  }

  String? validateGoalDescription(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter a goal description';
    }
    return null;
  }
