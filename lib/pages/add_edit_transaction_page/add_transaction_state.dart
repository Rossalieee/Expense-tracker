import 'package:expense_tracker/models/transaction_type.dart';

class AddTransactionState {
  AddTransactionState({
    required this.date,
    this.photo,
    this.expenseCategory,
    this.type = TransactionType.income,
    this.title = '',
    this.amount = 0,
    this.description = '',
    this.editMode = false,
  });

  final String title;
  final double amount;
  final String? description;
  final TransactionType type;
  final DateTime date;
  final String? photo;
  final String? expenseCategory;
  final bool editMode;

  AddTransactionState copyWith({
    TransactionType? type,
    DateTime? date,
    bool? isIncome,
    String? photo,
    String? expenseCategory,
    String? title,
    double? amount,
    String? description,
    bool? editMode,
  }) {
    return AddTransactionState(
      type: type ?? this.type,
      photo: photo ?? this.photo,
      date: date ?? this.date,
      expenseCategory: expenseCategory ?? this.expenseCategory,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      editMode: editMode ?? this.editMode,
    );
  }

  @override
  String toString() {
    return 'AddTransactionState('
        'editMode: $editMode,'
        ' title: $title,'
        ' amount: $amount,'
        ' description: $description'
        ' type: $type,'
        ' photo: $photo,'
        ' date: $date,'
        ' expenseCategory: $expenseCategory'
        ')';
  }
}
