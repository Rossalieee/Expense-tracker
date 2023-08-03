import 'package:expense_tracker/models/goal.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/objectbox.g.dart'; // created by `flutter pub run build_runner build`
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
    transactionBox = Box<TransactionModel>(store);
    goalBox = Box<GoalModel>(store);
  }
  late final Store store;

  late final Box<TransactionModel> transactionBox;
  late final Box<GoalModel> goalBox;

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();

    final store =
        await openStore(directory: p.join(docsDir.path, 'expense_tracker'));
    return ObjectBox._create(store);
  }

  Stream<List<TransactionModel>> getAllTransactions() {
    // Query for all transactions ordered by date.
    final builder = transactionBox.query()
      ..order(TransactionModel_.date, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  Stream<List<TransactionModel>> getTransactionsByDate(
    DateTime start,
    DateTime end,
  ) {
    // Query for transactions filtered by date.
    final builder = transactionBox.query(
      TransactionModel_.date
          .between(start.millisecondsSinceEpoch, end.millisecondsSinceEpoch),
    )..order(TransactionModel_.date, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  void addTransaction({
    required String title,
    required DateTime date,
    required double amount,
    required bool isIncome,
    String? description,
    String? photo,
    String? expenseCategory,
  }) {
    final newTransaction = TransactionModel(
      title: title,
      description: description,
      date: date,
      amount: amount,
      isIncome: isIncome,
      expenseCategory: expenseCategory,
      photo: photo,
    );

    transactionBox.put(newTransaction);
  }

  void updateTransaction(
    int id, {
    required String title,
    required DateTime date,
    required double amount,
    required bool isIncome,
    String? description,
    String? photo,
    String? expenseCategory,
  }) {
    final transaction = transactionBox.get(id);

    if (transaction != null) {
      transaction
        ..title = title
        ..description = description
        ..date = date
        ..amount = amount
        ..isIncome = isIncome
        ..expenseCategory = expenseCategory
        ..photo = photo;

      transactionBox.put(transaction);
    }
  }

  void removeTransaction(int id) => transactionBox.remove(id);

  Stream<List<GoalModel>> getAllGoals() {
    // Query for all goals.
    final builder = goalBox.query()
      ..order(GoalModel_.isFinished);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  void addGoal({
    required double goalAmount,
    required double collectedAmount,
    required String description,
    required bool isFinished,
  }) {
    final newGoal = GoalModel(
      goalAmount: goalAmount,
      description: description,
      collectedAmount: collectedAmount,
      isFinished: isFinished,
    );

    goalBox.put(newGoal);
  }

  void updateGoal(
    int id, {
    required double goalAmount,
    required double collectedAmount,
    required String description,
    required bool isFinished,
  }) {
    final goal = goalBox.get(id);

    if (goal != null) {
      goal
        ..goalAmount= goalAmount
        ..description = description
        ..collectedAmount = collectedAmount
        ..isFinished = isFinished;

      goalBox.put(goal);
    }
  }

  void removeGoal(int id) => goalBox.remove(id);
}
