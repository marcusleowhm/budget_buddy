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

  static const rowSpacing = EdgeInsets.all(8.0);

  List<TableRow> _createTableRows() {
    const String incomeSum = 'incomeSum';
    const String expenseSum = 'expenseSum';
    const String transferSum = 'transferSum';

    return currenciesTotal.entries.map((entry) {
      String currency = entry.key;
      double? incomeAmount = entry.value[incomeSum];
      incomeAmount ??= 0.0;
      double? expenseAmount = entry.value[expenseSum];
      expenseAmount ??= 0.0;
      double? transferAmount = entry.value[transferSum];
      transferAmount ??= 0.0;

      return TableRow(children: [
        TableCell(
          child: Padding(
            padding: rowSpacing,
            child: Center(
              child: Text(
                currency,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: rowSpacing,
            child: Center(
              child: Text(
                currencyFormatter.format(incomeAmount),
                style: TextStyle(
                  color: Colors.blue[700],
                ),
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: rowSpacing,
            child: Center(
              child: Text(
                currencyFormatter.format(expenseAmount),
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: rowSpacing,
            child: Center(
              child: Text(
                currencyFormatter.format(transferAmount),
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ]);
    }).toList();
  }

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
          Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                children: [
                  const TableCell(
                    child: Padding(
                      padding: rowSpacing,
                      child: Center(
                        child: Text(
                          'Currency',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: rowSpacing,
                      child: Center(
                        child: Text(
                          'Income',
                          style: TextStyle(
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const TableCell(
                    child: Padding(
                      padding: rowSpacing,
                      child: Center(
                        child: Text(
                          'Expense',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const TableCell(
                    child: Padding(
                      padding: rowSpacing,
                      child: Center(
                        child: Text(
                          'Transfer',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ..._createTableRows()
            ],
          ),
          SubmitButton(action: onSubmitPressed)
        ],
      ),
    );
  }
}
