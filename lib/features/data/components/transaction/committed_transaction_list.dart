import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/transaction/daily/daily_transaction_block.dart';
import 'package:budget_buddy/features/data/widgets/month_picker.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/daily_ledger_input.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommittedTransactionList extends StatelessWidget {
  CommittedTransactionList({
    super.key,
    required this.dateTimeValue,
    required this.localNow,
    required this.incrementMonth,
    required this.decrementMonth,
    required this.resetDate,
  });

  final DateTime dateTimeValue;
  final DateTime localNow;

  //Scroll controller for scrolling down
  final ScrollController _scrollController = ScrollController();
  final VoidCallback incrementMonth;
  final VoidCallback decrementMonth;
  final VoidCallback resetDate;

  Map<String, double> getMonthlyTransactionData(CTransactionState state) {
    Map<String, double> sum = {'income': 0.0, 'expense': 0.0, 'transfer': 0.0};
    for (TransactionData data in state.committedEntries) {
      DateTime localDateTime = DateTime(
        data.utcDateTime.toLocal().year,
        data.utcDateTime.toLocal().month,
        data.utcDateTime.toLocal().day,
      );
      if (dateTimeValue.month == localDateTime.month &&
          dateTimeValue.year == localDateTime.year) {
        switch (data.type) {
          case TransactionType.income:
            double cumulativeMonthlyIncome = sum['income'] ?? 0.0;
            sum['income'] = cumulativeMonthlyIncome + data.amount;
            break;
          case TransactionType.expense:
            double cumulativeMonthlyExpense = sum['expense'] ?? 0.0;
            sum['expense'] = cumulativeMonthlyExpense + data.amount;
            break;
          case TransactionType.transfer:
            double cumulativeTransferExpense = sum['transfer'] ?? 0.0;
            sum['transfer'] = cumulativeTransferExpense + data.amount;
            break;
        }
      }
    }
    return sum;
  }

  Map<DateTime, DailyLedgerInput> getDailyTransactionData(
      CTransactionState state) {
    //Do some mapping by date and return the card
    Map<DateTime, DailyLedgerInput> map = {};

    for (TransactionData data in state.committedEntries) {
      DateTime localDateTime = DateTime(
        data.utcDateTime.toLocal().year,
        data.utcDateTime.toLocal().month,
        data.utcDateTime.toLocal().day,
      );

      if (dateTimeValue.month == localDateTime.month &&
          dateTimeValue.year == localDateTime.year) {
        map.putIfAbsent(localDateTime, () => DailyLedgerInput());

        //Add the elements back into the map
        map[localDateTime]!.inputs.add(data);

        //Sum up the amount according to transaction type for each date
        switch (data.type) {
          case TransactionType.income:
            double cumulativeIncome = map[localDateTime]?.sum['income'] ?? 0.0;
            map[localDateTime]?.sum['income'] = cumulativeIncome + data.amount;
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
    Map<DateTime, DailyLedgerInput> sortedData = Map.fromEntries(
        map.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    return sortedData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Month picker
        MonthPicker(
          dateTimeValue: dateTimeValue,
          localNow: localNow,
          incrementMonth: incrementMonth,
          decrementMonth: decrementMonth,
          resetDate: resetDate,
        ),

        //Total sum for the selected month
        BlocBuilder<CTransactionCubit, CTransactionState>(
          builder: (context, state) {
            Map<String, double> monthlySum = getMonthlyTransactionData(state);
            return Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Text('Income',
                              style: TextStyle(color: Colors.blue[700])),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Text(
                            englishDisplayCurrencyFormatter
                                .format(monthlySum['income']),
                            style: TextStyle(color: Colors.blue[700]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                          child: Text(
                            'Expense',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Text(
                            englishDisplayCurrencyFormatter
                                .format(monthlySum['expense']),
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                          child: Text(
                            'Transfer',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Text(
                            englishDisplayCurrencyFormatter
                                .format(monthlySum['transfer']),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        //Transaction list
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: BlocBuilder<CTransactionCubit, CTransactionState>(
              builder: (context, state) {
                return getDailyTransactionData(state).keys.isEmpty
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('<Some image>'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'No transactions added yet',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ]) //TODO add some cool graphics here for no transaction
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                getDailyTransactionData(state).keys.length,
                            itemBuilder: (context, index) {
                              return DailyTransactionBlock(
                                dateTime: getDailyTransactionData(state)
                                    .keys
                                    .elementAt(index),
                                transactions: getDailyTransactionData(state)
                                    .values
                                    .elementAt(index)
                                    .inputs,
                                sum: getDailyTransactionData(state)
                                    .values
                                    .elementAt(index)
                                    .sum,
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
