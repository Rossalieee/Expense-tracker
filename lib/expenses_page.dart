import 'package:expense_tracker/date_range_cubit.dart';
import 'package:expense_tracker/expense_category.dart';
import 'package:expense_tracker/filter_by_date.dart';
import 'package:expense_tracker/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DateRangeCubit(),
      child: _ExpensesPage(),
    );
  }
}

class _ExpensesPage extends StatelessWidget {
  _ExpensesPage();

  final expensesSum = <String, double>{};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateRangeCubit, DateRangeState>(
      builder: (context, state) {
        final cubit = context.read<DateRangeCubit>();
        return Scaffold(
          body: StreamBuilder(
            stream: state.selectedDateRange == null
                ? objectbox.getAllTransactions()
                : objectbox.getTransactionsByDate(
                    state.selectedDateRange!.start,
                    state.selectedDateRange!.end,
                  ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                for (final expenseCategory in ExpenseCategory.values) {
                  expensesSum[expenseCategory.name] = 0.0;
                }
                final transactions = snapshot.data!;
                for (final transaction in transactions) {
                  if (!transaction.isIncome) {
                    expensesSum[transaction.expenseCategory!] =
                        expensesSum[transaction.expenseCategory]! +
                            transaction.amount;
                  }
                }
                return Column(
                  children: [
                    const SizedBox(height: 35),
                    Expanded(child: BuildPieChart(dataMap: expensesSum)),
                    FilterByDate(cubit: cubit),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: ExpenseCategory.values.length,
                        itemBuilder: (context, index) {
                          final expense = ExpenseCategory.values[index];
                          final expenseTotal = expensesSum[expense.name];
                          final expenseIcon = Icon(expense.icon);
                          return ListTile(
                            leading: expenseIcon,
                            title: Text(expense.name),
                            trailing: Text(
                              expenseTotal!.toStringAsFixed(2),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        );
      },
    );
  }
}

class BuildPieChart extends StatelessWidget {
  const BuildPieChart({
    required this.dataMap,
    super.key,
  });

  final Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    final totalValue = dataMap.values.reduce((a, b) => a + b);

    return PieChart(
      PieChartData(
        centerSpaceRadius: 0,
        sections: dataMap.entries
            .map(
              (entry) => chartSections(entry, totalValue),
            )
            .toList(),
      ),
    );
  }

  PieChartSectionData chartSections(
      MapEntry<String, double> entry, double totalValue) {
    return PieChartSectionData(
      value: entry.value,
      title: '${((entry.value / totalValue) * 100).toStringAsFixed(0)}%',
      badgeWidget: _Badge(
        expense: ExpenseCategory.getValues(entry.key),
      ),
      badgePositionPercentageOffset: .98,
      color: ExpenseCategory.getColor(entry.key),
      radius: 120,
      titleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.expense,
  });
  final ExpenseCategory expense;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: expense.color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          expense.icon,
          color: Colors.black,
        ),
      ),
    );
  }
}
