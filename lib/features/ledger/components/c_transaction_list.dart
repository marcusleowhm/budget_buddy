import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/components/transaction_block.dart';
import 'package:budget_buddy/features/ledger/model/ledger_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/date_formatter.dart';
import '../model/ledger_input.dart';
import 'inputs/type_picker.dart';

class CTransactionList extends StatelessWidget {
  CTransactionList({
    super.key,
    required this.currentLocalDate,
    required this.nowDate,
    required this.incrementMonth,
    required this.decrementMonth,
    required this.resetDate,
  });

  final DateTime currentLocalDate;
  final DateTime nowDate;

  //Scroll controller for scrolling down
  final ScrollController _scrollController = ScrollController();
  final VoidCallback incrementMonth;
  final VoidCallback decrementMonth;
  final VoidCallback resetDate;

  Map<DateTime, LedgerDisplay> getData(CTransactionState state) {
    //Do some mapping by date and return the card
    Map<DateTime, LedgerDisplay> data = {};
    for (LedgerInput input in state.committedEntries) {
      DateTime localDateTime = DateTime(
        input.utcDateTime.toLocal().year,
        input.utcDateTime.toLocal().month,
        input.utcDateTime.toLocal().day,
      );

      if (currentLocalDate.month == localDateTime.month &&
          currentLocalDate.year == localDateTime.year) {
        data.putIfAbsent(localDateTime, () => LedgerDisplay());

        //Add the elements back into the date
        data[localDateTime]!.inputs.add(input);

        //Sum up the amount according to transaction type
        switch (input.type) {
          case TransactionType.income:
            double cumulativeIncome = data[localDateTime]?.sum['income'] ?? 0.0;
            data[localDateTime]?.sum['income'] =
                cumulativeIncome + input.amount;
            break;
          case TransactionType.expense:
            double cumulativeExpense =
                data[localDateTime]?.sum['expense'] ?? 0.0;
            data[localDateTime]?.sum['expense'] =
                cumulativeExpense + input.amount;
            break;
          case TransactionType.transfer:
            double cumulativeTransfer =
                data[localDateTime]?.sum['transfer'] ?? 0.0;
            data[localDateTime]?.sum['transfer'] =
                cumulativeTransfer + input.amount;
            break;
        }
      }
    }

    //Sort the map by date
    Map<DateTime, LedgerDisplay> sortedData = Map.fromEntries(
        data.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    return sortedData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: Theme.of(context).cardColor,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: decrementMonth,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                constraints: const BoxConstraints(),
              ),
              SizedBox(
                width: 80,
                child: Text(dateMonthYearFormatter.format(currentLocalDate),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16)),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: incrementMonth,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                constraints: const BoxConstraints(),
              ),
              if (
                  //Same month but different year
                  (currentLocalDate.month == nowDate.month &&
                          currentLocalDate.year != nowDate.year) ||
                      //Different month, year is irrelevant
                      (currentLocalDate.month != nowDate.month))
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: resetDate,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
                  constraints: const BoxConstraints(),
                )
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: BlocBuilder<CTransactionCubit, CTransactionState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: getData(state).keys.length,
                      itemBuilder: (context, index) {
                        return TransactionBlock(
                          dateTime: getData(state).keys.elementAt(index),
                          transactions:
                              getData(state).values.elementAt(index).inputs,
                          sum: getData(state).values.elementAt(index).sum,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
