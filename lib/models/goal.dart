
import 'package:objectbox/objectbox.dart';

@Entity()
class GoalModel {
  GoalModel({
    required this.goalAmount,
    required this.collectedAmount,
    required this.description,
    required this.isFinished,
    this.id = 0,
  });

  @Id()
  int id;
  String description;
  double goalAmount;
  double collectedAmount;
  bool isFinished;
}
