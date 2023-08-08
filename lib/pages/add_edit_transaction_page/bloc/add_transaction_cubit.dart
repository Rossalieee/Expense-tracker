import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/models/transaction_type.dart';
import 'package:expense_tracker/pages/add_edit_transaction_page/add_transaction_state.dart';
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

  late final int transactionId;

  void initialize(TransactionModel? transaction) {
    if (transaction != null) {
      transactionId = transaction.id;

      emit(
        AddTransactionState(
          title: transaction.title,
          amount: transaction.amount,
          description: transaction.description,
          date: transaction.date,
          type: TransactionType.fromString(transaction.type),
          photo: transaction.photo,
          expenseCategory: transaction.expenseCategory,
          editMode: true,
        ),
      );
    }
  }

  void setTitle(String? value) => emit(state.copyWith(title: value));

  void setAmount(double? value) => emit(state.copyWith(amount: value));

  void setDescription(String? value) =>
      emit(state.copyWith(description: value));

  void setDate(DateTime? value) => emit(state.copyWith(date: value));

  void setPhoto(String? value) => emit(state.copyWith(photo: value));

  void setType(TransactionType? value) => emit(state.copyWith(type: value));

  void setExpenseCategory(String? value) =>
      emit(state.copyWith(expenseCategory: value));

  void clearPhoto() => emit(
        AddTransactionState(
          date: state.date,
          type: state.type,
          expenseCategory: state.expenseCategory,
          title: state.title,
          amount: state.amount,
          description: state.description,
          editMode: state.editMode,
        ),
      );

  void clearExpenseCategory() => emit(
        AddTransactionState(
          date: state.date,
          type: state.type,
          photo: state.photo,
          title: state.title,
          amount: state.amount,
          description: state.description,
          editMode: state.editMode,
        ),
      );

  void clearState() => emit(
        AddTransactionState(
          date: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
        ),
      );

  void addTransaction() {
    objectbox.addTransaction(
      title: state.title,
      description: state.description,
      amount: state.amount,
      date: state.date,
      photo: state.photo,
      expenseCategory: state.expenseCategory,
      type: state.type.name,
    );
    clearState();
  }

  void updateTransaction() => objectbox.updateTransaction(
        transactionId,
        title: state.title,
        description: state.description,
        amount: state.amount,
        date: state.date,
        photo: state.photo,
        expenseCategory: state.expenseCategory,
        type: state.type.name,
      );
}
