import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:flutter/material.dart';

import '../../../utilities/date_formatter.dart';
import '../model/ledger_input.dart';
import 'inputs/type_picker.dart';

class TransactionBlock extends StatelessWidget {
  const TransactionBlock({
    super.key,
    required this.dateTime,
    required this.transactions,
    required this.sum,
  });

  final DateTime dateTime;
  final List<LedgerInput> transactions;
  final Map<String, double> sum;

  Widget _buildFirstLine(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Text(
              dateTime.day.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
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
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      englishDisplayCurrencyFormatter.format(sum['income']),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      englishDisplayCurrencyFormatter.format(sum['expense']),
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      englishDisplayCurrencyFormatter.format(sum['transfer']),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildSubsequentLines(BuildContext context) {
    return transactions
        .map((input) => Container(
              margin: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              input.accountOrAccountFrom,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              input.categoryOrAccountTo,
                              style: TextStyle(
                                fontSize: 14,
                                color: input.type == TransactionType.income
                                    ? Theme.of(context).primaryColor
                                    : input.type == TransactionType.expense
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              input.note.isEmpty ? '-' : input.note,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        input.currency,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        englishDisplayCurrencyFormatter.format(input.amount),
                        style: TextStyle(
                            fontSize: 14,
                            color: input.type == TransactionType.income
                                ? Theme.of(context).primaryColor
                                : input.type == TransactionType.expense
                                    ? Colors.red
                                    : Colors.grey),
                      )
                    ],
                  ),
                ],
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
