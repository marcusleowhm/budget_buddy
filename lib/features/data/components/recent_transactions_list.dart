import 'dart:math';

import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentTransactionsList extends StatefulWidget {
  const RecentTransactionsList({super.key});

  @override
  State<RecentTransactionsList> createState() => _RecentTransactionsListState();
}

class _RecentTransactionsListState extends State<RecentTransactionsList> {
  RecentTransactionFilterCriteria filterCriteria =
      RecentTransactionFilterCriteria.transactionDate;

  Map<RecentTransactionFilterCriteria, String> labels = {
    RecentTransactionFilterCriteria.transactionDate: 'Transaction Date',
    RecentTransactionFilterCriteria.createdDate: 'Created Date',
    RecentTransactionFilterCriteria.modifiedDate: 'Modified Date'
  };

  Iterable<TransactionData> getData(CTransactionState state) {
    List<TransactionData> copyOfState = List.from(state.committedEntries);

    int maxCount = min(10, state.committedEntries.length);
    switch (filterCriteria) {
      case RecentTransactionFilterCriteria.transactionDate:
        copyOfState.sort(
          (a, b) => b.utcDateTime.compareTo(a.utcDateTime),
        );
        return copyOfState.getRange(0, maxCount);
      case RecentTransactionFilterCriteria.createdDate:
        copyOfState.sort(
            (a, b) => b.createdUtcDateTime!.compareTo(a.createdUtcDateTime!));
        return copyOfState.getRange(0, maxCount);
      case RecentTransactionFilterCriteria.modifiedDate:
        copyOfState.sort(
          (a, b) {
            if (a.modifiedUtcDateTime == null &&
                b.modifiedUtcDateTime != null) {
              return 1;
            } else if (a.modifiedUtcDateTime != null &&
                b.modifiedUtcDateTime == null) {
              return -1;
            } else {
              //If both transactions were not modified, sort by their transaction date
              return b.utcDateTime.compareTo(a.utcDateTime);
            }
          },
        );
        return copyOfState.getRange(0, maxCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: BlocBuilder<CTransactionCubit, CTransactionState>(
                builder: (context, state) {
              //Sort data depending on criteria selected
              Iterable<TransactionData> data = getData(state);

              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '10 Recent Transactions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopupMenuButton(
                        initialValue: filterCriteria,
                        onSelected: (RecentTransactionFilterCriteria value) {
                          setState(() => filterCriteria = value);
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value:
                                RecentTransactionFilterCriteria.transactionDate,
                            child: Text(labels[RecentTransactionFilterCriteria
                                .transactionDate]!),
                          ),
                          PopupMenuItem(
                            value: RecentTransactionFilterCriteria.createdDate,
                            child: Text(labels[
                                RecentTransactionFilterCriteria.createdDate]!),
                          ),
                          PopupMenuItem(
                            value: RecentTransactionFilterCriteria.modifiedDate,
                            child: Text(labels[
                                RecentTransactionFilterCriteria.modifiedDate]!),
                          ),
                        ],
                        child: TextButton.icon(
                          icon: const Text('Filter by'),
                          label: const Icon(Icons.arrow_drop_down_rounded),
                          onPressed: null,
                        ),
                      ),
                      Text(labels[filterCriteria]!),
                    ],
                  ),
                  const Divider(thickness: 1),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: min(10, state.committedEntries.length),
                    itemBuilder: (context, index) => ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                                dateFormatter.format(
                                  data.elementAt(index).utcDateTime.toLocal(),
                                ),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              data.elementAt(index).account,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              data.elementAt(index).category,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: data.elementAt(index).type ==
                                        TransactionType.income
                                    ? Colors.blue[700]
                                    : data.elementAt(index).type ==
                                            TransactionType.expense
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              data.elementAt(index).note.isEmpty
                                  ? '-'
                                  : data.elementAt(index).note,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: data.elementAt(index).type ==
                                            TransactionType.income
                                        ? Colors.blue[700]!
                                        : data.elementAt(index).type ==
                                                TransactionType.expense
                                            ? Colors.red
                                            : Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Text(
                                '${data.elementAt(index).currency} ${englishDisplayCurrencyFormatter.format(data.elementAt(index).amount)}',
                                style: TextStyle(
                                  color: data.elementAt(index).type ==
                                          TransactionType.income
                                      ? Colors.blue[700]!
                                      : data.elementAt(index).type ==
                                              TransactionType.expense
                                          ? Colors.red
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 5.0, top: 20.0),
                            child: Text(
                                'Created: ${dateFormatter.format(data.elementAt(index).createdUtcDateTime!)}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                                data.elementAt(index).modifiedUtcDateTime ==
                                        null
                                    ? 'Modified: -'
                                    : 'Modified: ${dateFormatter.format(data.elementAt(index).modifiedUtcDateTime!)}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12)),
                          ),
                          if (index !=
                              min(10, state.committedEntries.length) - 1)
                            const Divider(thickness: 1.0)
                        ],
                      ),
                    ),
                  )
                ],
              );
            })),
      ),
    );
  }
}
