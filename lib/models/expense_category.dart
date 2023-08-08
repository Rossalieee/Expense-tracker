import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ExpenseCategory {
  housing(
    'Housing & Utilities',
    FontAwesomeIcons.house,
    Color.fromARGB(255, 123, 237, 127),
  ),
  transportation(
    'Transportation',
    FontAwesomeIcons.car,
    Color.fromARGB(255, 112, 187, 224),
  ),
  food(
    'Food & House Supplies',
    FontAwesomeIcons.appleWhole,
    Color.fromARGB(255, 226, 237, 123),
  ),
  health(
    'Health',
    FontAwesomeIcons.heartPulse,
    Color.fromARGB(255, 237, 123, 123),
  ),
  entertainment(
    'Entertainment',
    FontAwesomeIcons.faceSmile,
    Color.fromARGB(255, 195, 123, 237),
  ),
  clothing(
    'Clothing & Beauty',
    FontAwesomeIcons.shirt,
    Color.fromARGB(255, 255, 118, 177),
  ),
  other(
    'Other',
    FontAwesomeIcons.asterisk,
    Color.fromARGB(255, 255, 170, 0),
  );

  const ExpenseCategory(this.name, this.icon, this.color);

  final String name;
  final IconData icon;
  final Color color;

  static ExpenseCategory getValues(String? value) => ExpenseCategory.values
      .firstWhere(
        (expenseCategory) => expenseCategory.name == value,
      );

  static IconData getIcon(String? value) => ExpenseCategory.values
      .firstWhere(
        (expenseCategory) => expenseCategory.name == value,
      )
      .icon;

  static Color getColor(String? value) => ExpenseCategory.values
      .firstWhere(
        (expenseCategory) => expenseCategory.name == value,
      )
      .color;
}
