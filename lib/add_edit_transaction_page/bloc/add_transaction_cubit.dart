import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransactionState {
  AddTransactionState(
      {required this.date,
      required this.isIncome,
      required this.selectedIndex,
      this.photo,
      this.expenseCategory});

  final int selectedIndex;
  final String? photo;
  final DateTime date;
  final String? expenseCategory;
  final bool isIncome;

  AddTransactionState copyWith({
    int? selectedIndex,
    String? photo,
    DateTime? date,
    String? expenseCategory,
    bool? isIncome,
  }) {
    return AddTransactionState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      photo: photo ?? this.photo,
      date: date ?? this.date,
      expenseCategory: expenseCategory ?? this.expenseCategory,
      isIncome: isIncome ?? this.isIncome,
    );
  }
}

class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit()
      : super(
          AddTransactionState(
            selectedIndex: 0,
            date: DateTime.now(),
            isIncome: true,
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

  void setIndex(int? value) {
    emit(state.copyWith(selectedIndex: value));
  }

  void setExpenseCategory(String? value) {
    emit(state.copyWith(expenseCategory: value));
  }

  void setIsIncome({required bool value}) {
    emit(state.copyWith(isIncome: value));
  }

  void clearPhoto() {
    emit(
      AddTransactionState(
        date: state.date,
        isIncome: state.isIncome,
        selectedIndex: state.selectedIndex,
        expenseCategory: state.expenseCategory,
      ),
    );
  }

  void clearExpenseCategory() {
    emit(
      AddTransactionState(
        date: state.date,
        isIncome: state.isIncome,
        selectedIndex: state.selectedIndex,
        photo: state.photo,
      ),
    );
  }

  void editTransaction({
    required DateTime date,
    required bool isIncome,
    required int selectedIndex,
    String? photo,
    String? expenseCategory,
  }) {
    emit(
      AddTransactionState(
        date: date,
        isIncome: isIncome,
        selectedIndex: selectedIndex,
        photo: photo,
        expenseCategory: expenseCategory,
      ),
    );
  }
}
