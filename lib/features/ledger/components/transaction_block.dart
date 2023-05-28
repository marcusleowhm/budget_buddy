import 'package:flutter/material.dart';

import '../../../utilities/date_formatter.dart';
import '../model/ledger_input.dart';

class TransactionBlock extends StatelessWidget {
  const TransactionBlock({
    super.key,
    required this.dateTime,
    required this.transactions,
  });

  final DateTime dateTime;
  final List<LedgerInput> transactions;

  Widget _buildFirstLine() {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              dateTime.day.toString(),
            )),
        Text(dateDayOfWeekFormatter.format(dateTime))
      ],
    );
  }

  List<Widget> _buildSubsequentLines() {
    return transactions
        .map((input) => Row(
              children: [
                Text(input.currency),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(input.accountOrAccountFrom),
                  Text(input.categoryOrAccountTo),
                  Text(input.note),
                ]),
                Text(input.amount.toString()),
              ],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        _buildFirstLine(),
        const Divider(),
        ..._buildSubsequentLines()
      ]),
    );
  }
}
