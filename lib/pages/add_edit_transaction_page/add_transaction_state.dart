import 'package:expense_tracker/pages/add_edit_transaction_page/choice_chips.dart';

class AddTransactionState {
  AddTransactionState({
    required this.date,
    this.photo,
    this.expenseCategory,
    this.isIncome = true,
    this.type = TransactionType.income,
  });

  final TransactionType type;
  final DateTime date;
  final bool isIncome;
  final String? photo;
  final String? expenseCategory;

  AddTransactionState copyWith({
    TransactionType? type,
    DateTime? date,
    bool? isIncome,
    String? photo,
    String? expenseCategory,
  }) {
    return AddTransactionState(
      type: type ?? this.type,
      photo: photo ?? this.photo,
      date: date ?? this.date,
      expenseCategory: expenseCategory ?? this.expenseCategory,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  @override
  String toString() {
    return 'AddTransactionState(selectedIndex: $type,'
        ' photo: $photo,'
        ' date: $date,'
        ' expenseCategory: $expenseCategory,'
        ' isIncome: $isIncome'
        ')';
  }
}
