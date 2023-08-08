import 'package:objectbox/objectbox.dart';

@Entity()
class TransactionModel {
  TransactionModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
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
  String type;
  String? photo;
  String? description;
  String? expenseCategory;
}
