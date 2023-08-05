import 'package:expense_tracker/app_spacers.dart';
import 'package:expense_tracker/date_range_cubit.dart';
import 'package:expense_tracker/expense_category.dart';
import 'package:expense_tracker/filter_by_date.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/pages/settings_page.dart';
import 'package:expense_tracker/pages/transaction_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DateRangeCubit(),
      child: const _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateRangeCubit, DateRangeState>(
      builder: (context, state) {
        final cubit = context.read<DateRangeCubit>();
        return Scaffold(
          body: Column(
            children: [
              AppSpacers.h35,
              Expanded(
                child: StreamBuilder(
                  stream: state.selectedDateRange == null
                      ? objectbox.getAllTransactions()
                      : objectbox.getTransactionsByDate(
                          state.selectedDateRange!.start,
                          state.selectedDateRange!.end,
                        ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final transactions = snapshot.data!;
                      final totalSum = transactions.fold<double>(
                        0,
                        (sum, transaction) =>
                            sum +
                            (transaction.isIncome
                                ? transaction.amount
                                : -transaction.amount),
                      );

                      final formattedTotalSum =
                          NumberFormat.decimalPattern('en_US').format(totalSum);
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(13),
                            child: Text(
                              'Total Sum: $formattedTotalSum $choosenCurrency',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FilterByDate(cubit: cubit),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = transactions[index];
                                final formattedAmount = transaction.isIncome
                                    ? '+ ${transaction.amount.toStringAsFixed(2)}'
                                    : '- ${transaction.amount.toStringAsFixed(2)}';
                                final categoryIcon =
                                    transaction.expenseCategory == null
                                        ? FontAwesomeIcons.coins
                                        : ExpenseCategory.getIcon(
                                            transaction.expenseCategory,
                                          );
                                final cardColor = transaction.isIncome
                                    ? Colors.green.shade600
                                    : Colors.red.shade600;
                                final cardBorderColor = transaction.isIncome
                                    ? Colors.green.shade900
                                    : Colors.red.shade900;
                                final formattedDate =
                                    DateFormat.yMMMd().format(transaction.date);
                                return Card(
                                  elevation: 1,
                                  margin: const EdgeInsets.all(4),
                                  child: ListTile(
                                    leading: Icon(categoryIcon),
                                    title: Text(
                                      transaction.title.toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(formattedDate),
                                    trailing: Card(
                                      color: cardColor,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: cardBorderColor,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(9),
                                        child: Text(
                                          formattedAmount,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) {
                                            return TransactionDetailsPage(
                                              transaction: transaction,
                                            );
                                          },
                                        ),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
