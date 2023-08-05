import 'package:expense_tracker/pages/add_edit_transaction_page/add_transaction_state.dart';
import 'package:expense_tracker/pages/add_edit_transaction_page/choice_chips.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit()
      : super(
          AddTransactionState(
            date: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
          ),
        );

  void selectDate(DateTime? value) {
    if (value != null) {
      emit(state.copyWith(date: value));
    }
  }

  void selectPhoto(String? value) {
    if (value != null) {
      emit(state.copyWith(photo: value));
    }
  }

  void setType(TransactionType? value) => emit(
        state.copyWith(type: value),
      );

  void setExpenseCategory(String? value) =>
      emit(state.copyWith(expenseCategory: value));

  void setIsIncome({required bool value}) =>
      emit(state.copyWith(isIncome: value));

  void clearPhoto() => emit(
        AddTransactionState(
          date: state.date,
          isIncome: state.isIncome,
          type: state.type,
          expenseCategory: state.expenseCategory,
        ),
      );

  void clearExpenseCategory() => emit(
        AddTransactionState(
          date: state.date,
          isIncome: state.isIncome,
          type: state.type,
          photo: state.photo,
        ),
      );

  void editTransaction({
    required DateTime date,
    required bool isIncome,
    required TransactionType type,
    String? photo,
    String? expenseCategory,
  }) =>
      emit(
        AddTransactionState(
          date: date,
          isIncome: isIncome,
          type: type,
          photo: photo,
          expenseCategory: expenseCategory,
        ),
      );
}
