import 'package:budget_buddy/features/ledger/components/submit_button.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:flutter/material.dart';

class AddSummary extends StatelessWidget {
  const AddSummary({
    super.key,
    required this.onSubmitPressed,
    required this.totalTransactions,
    required this.currenciesTotal,
  });

  final VoidCallback onSubmitPressed;
  final int totalTransactions;
  final Map<String, Map<String, double>> currenciesTotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          //Text for summary
          const Text('Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          const Divider(),
          Text('Total Transactions: $totalTransactions'),
          const Divider(),
          //Total value of income, expense and, transfer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Income',
                    style: TextStyle(
                      color: Colors.blue[700],
                    ),
                  ),
                  Text(
                    currencyFormatter.format(0), //TODO use currenciesTotal
                    style: TextStyle(
                      color: Colors.blue[700],
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Expense',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    currencyFormatter.format(0), //TODO use currenciesTotal
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Transfer',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    currencyFormatter.format(0), //TODO use currenciesTotal
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SubmitButton(action: onSubmitPressed)
        ],
      ),
    );
  }
}
