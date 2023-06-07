import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/transaction/transaction_block.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/ledger_display.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    Map<DateTime, LedgerDisplay> map = {};
    for (TransactionData data in state.committedEntries) {
      DateTime localDateTime = DateTime(
        data.utcDateTime.toLocal().year,
        data.utcDateTime.toLocal().month,
        data.utcDateTime.toLocal().day,
      );

      if (currentLocalDate.month == localDateTime.month &&
          currentLocalDate.year == localDateTime.year) {
        map.putIfAbsent(localDateTime, () => LedgerDisplay());

        //Add the elements back into the map
        map[localDateTime]!.inputs.add(data);

        //Sum up the amount according to transaction type for each date
        switch (data.type) {
          case TransactionType.income:
            double cumulativeIncome = map[localDateTime]?.sum['income'] ?? 0.0;
            map[localDateTime]?.sum['income'] =
                cumulativeIncome + data.amount;
            break;
          case TransactionType.expense:
            double cumulativeExpense =
                map[localDateTime]?.sum['expense'] ?? 0.0;
            map[localDateTime]?.sum['expense'] =
                cumulativeExpense + data.amount;
            break;
          case TransactionType.transfer:
            double cumulativeTransfer =
                map[localDateTime]?.sum['transfer'] ?? 0.0;
            map[localDateTime]?.sum['transfer'] =
                cumulativeTransfer + data.amount;
            break;
        }
      }
    }

    //Sort the map by date
    Map<DateTime, LedgerDisplay> sortedData = Map.fromEntries(
        map.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    return sortedData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Month picker
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

        //Transaction list
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: BlocBuilder<CTransactionCubit, CTransactionState>(
              builder: (context, state) {
                return getData(state).keys.isEmpty
                    ? const Card(
                      child: Text('empty'), //TODO add some cool graphics here for no transaction
                    )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: getData(state).keys.length,
                            itemBuilder: (context, index) {
                              return TransactionBlock(
                                dateTime: getData(state).keys.elementAt(index),
                                transactions: getData(state)
                                    .values
                                    .elementAt(index)
                                    .inputs,
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
