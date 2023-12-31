import 'package:expense_tracker/color_schemes.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/models/goal.dart';
import 'package:expense_tracker/pages/add_goal_page.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  void _editDeleteGoal(BuildContext context, GoalModel goal) {
    final controller = TextEditingController(
      text: goal.collectedAmount.toStringAsFixed(2),
    );

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Collected Amount'),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
          actions: [
            _DeleteSaveGoalButtons(controller: controller, goal: goal),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return const AddGoalPage();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text('Goals'), centerTitle: true),
      body: StreamBuilder(
        stream: objectbox.getAllGoals(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final goals = snapshot.data!;

            return ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final formattedGoal = goal.goalAmount.toStringAsFixed(2);
                final formattedCollected =
                    goal.collectedAmount.toStringAsFixed(2);
                return ListTile(
                  title: Text(
                    goal.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: ProgressBar(
                    progress: goal.collectedAmount / goal.goalAmount,
                  ),
                  onTap: () => _editDeleteGoal(context, goal),
                  trailing: Text('$formattedCollected / $formattedGoal'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class _DeleteSaveGoalButtons extends StatelessWidget {
  const _DeleteSaveGoalButtons({
    required this.controller, required this.goal, super.key,
  });

  final TextEditingController controller;
  final GoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Delete goal'),
                  content: const Text(
                    'Are you sure you want to delete this goal?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        objectbox.removeGoal(goal.id);
                        Navigator.pop(context, 'OK');
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        _SaveGoalButton(controller: controller, goal: goal),
      ],
    );
  }
}

class _SaveGoalButton extends StatelessWidget {
  const _SaveGoalButton({
    required this.controller, required this.goal, super.key,
  });

  final TextEditingController controller;
  final GoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              final newAmount =
                  double.tryParse(controller.text) ?? 0.0;

              if (newAmount > goal.goalAmount) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Collected amount cannot be greater than the goal amount!',
                    ),
                  ),
                );
              } else {
                final isFinished = newAmount == goal.goalAmount;

                objectbox.updateGoal(
                  goal.id,
                  goalAmount: goal.goalAmount,
                  collectedAmount: newAmount,
                  description: goal.description,
                  isFinished: isFinished,
                );

                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    required this.progress,
    super.key,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: LinearPercentIndicator(
        width: MediaQuery.of(context).size.width - 250,
        lineHeight: 20,
        percent: progress,
        progressColor: lightColorScheme.primary,
        barRadius: const Radius.circular(12),
      ),
    );
  }
}
