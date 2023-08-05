import 'package:objectbox/objectbox.dart';

@Entity()
class TransactionModel {

  TransactionModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    this.id = 0,
    this.description,
    this.photo,
    this.expenseCategory,
  });

  @Id()
  int id;
  String title;
  double amount;
  DateTime date;
  bool isIncome;
  String? photo;
  String? description;
  String? expenseCategory;
}
