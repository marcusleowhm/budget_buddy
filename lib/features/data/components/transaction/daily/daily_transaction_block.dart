import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_utilities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DailyTransactionBlock extends StatelessWidget {
  const DailyTransactionBlock({
    super.key,
    required this.dateTime,
    required this.transactions,
    required this.sum,
  });

  final DateTime dateTime;
  final List<TransactionData> transactions;
  final Map<String, double> sum;

  Widget _buildFirstLine(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Day
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Text(
              dayFormatter.format(dateTime),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          //Day of the week
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
              borderRadius: BorderRadius.circular(3.0),
            ),
            padding: const EdgeInsets.all(5.0),
            child: Text(
              dateShortDayOfWeekFormatter.format(dateTime),
            ),
          ),
          //Monthly tally
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  englishDisplayCurrencyFormatter.format(sum['income']),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  englishDisplayCurrencyFormatter.format(sum['expense']),
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                Text(
                  englishDisplayCurrencyFormatter.format(sum['transfer']),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSubsequentLines(BuildContext context) {
    return transactions
        .map((data) => InkWell(
              onTap: () {
                //open the edit page and populate the form with existing data
                context.go(
                  '/${routes[MainRoutes.ledger]}/${routes[SubRoutes.editLedger]}',
                  extra: data,
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: Container(
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Account
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  data.subAccount,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              //Category
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  data.type == TransactionType.income
                                      ? data.incomeSubCategory != null
                                          ? '${data.incomeCategory} (${data.incomeSubCategory})'
                                          : data.incomeCategory
                                      : data.type == TransactionType.expense
                                          ? data.expenseSubCategory != null
                                              ? '${data.expenseCategory} (${data.expenseSubCategory})'
                                              : data.expenseCategory
                                          : data.transferSubCategory!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: data.type == TransactionType.income
                                        ? Theme.of(context).primaryColor
                                        : data.type == TransactionType.expense
                                            ? Colors.red
                                            : Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                data.currency,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                englishDisplayCurrencyFormatter
                                    .format(data.amount),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: data.type == TransactionType.income
                                      ? Theme.of(context).primaryColor
                                      : data.type == TransactionType.expense
                                          ? Colors.red
                                          : Colors.grey,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            data.note.isEmpty ? '-' : data.note,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        _buildFirstLine(context),
        const Divider(height: 0),
        ..._buildSubsequentLines(context)
      ]),
    );
  }
}
