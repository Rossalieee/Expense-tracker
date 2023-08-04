import 'package:expense_tracker/add_edit_transaction_page/add_transaction_page.dart';
import 'package:expense_tracker/expenses_page.dart';
import 'package:expense_tracker/goals_page.dart';
import 'package:expense_tracker/home_page.dart';
import 'package:expense_tracker/root_page/bloc/root_page_cubit.dart';
import 'package:expense_tracker/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RootPageCubit(),
      child: _RootPage(),
    );
  }
}

class _RootPage extends StatelessWidget {
  _RootPage();

  final List<Widget> pages = [
    const HomePage(),
    ExpensesPage(),
    const AddTransactionPage(),
    const GoalsPage(),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootPageCubit, RootPageState>(
      builder: (context, state) {
        final currentPage = state.currentPage;

        return Scaffold(
          body: pages[currentPage],
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.monetization_on),
                label: 'Expenses',
              ),
              NavigationDestination(
                icon: Icon(Icons.add_box_outlined),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.check_box),
                label: 'Goals',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: 'Settings',
              )
            ],
            onDestinationSelected: (int index) {
              context.read<RootPageCubit>().setPage(index);
            },
            selectedIndex: currentPage,
          ),
        );
      },
    );
  }
}
