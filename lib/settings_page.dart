import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';

String choosenCurrency = 'PLN';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextButton(
              onPressed: () {
                showCurrencyPicker(
                  context: context,
                  favorite: ['PLN', 'EUR', 'GBP', 'USD'],
                  onSelect: (Currency currency) {
                    choosenCurrency = currency.code;
                  },
                );
              },
              child: const Card(
                child: Text(
                  'Change currency',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
