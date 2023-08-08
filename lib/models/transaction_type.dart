enum TransactionType {
  income('Income'),
  expense('Expense');

  const TransactionType(this.name);

  final String name;

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TransactionType.income,
    );
  }
}
