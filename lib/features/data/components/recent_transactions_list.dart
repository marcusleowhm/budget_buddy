import 'dart:math';

import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ledger/model/ledger_input.dart';

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

  Iterable<LedgerInput> getData(CTransactionState state) {
    List<LedgerInput> copyOfState = List.from(state.committedEntries);

    int maxCount = min(10, state.committedEntries.length);
    switch (filterCriteria) {
      case RecentTransactionFilterCriteria.transactionDate:
        copyOfState.sort(
          (a, b) => b.utcDateTime.compareTo(a.utcDateTime),
        );
        return copyOfState.getRange(0, maxCount);
      case RecentTransactionFilterCriteria.createdDate:
        copyOfState.sort(
          (a, b) => b.createdUtcDateTime!.compareTo(a.createdUtcDateTime!)
        );
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
              return 0;
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
              Iterable<LedgerInput> data = getData(state);

              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Transactions',
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
                  const Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: min(10, state.committedEntries.length),
                    itemBuilder: (context, index) => ListTile(
                      leading: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              dayFormatter.format(
                                data.elementAt(index).utcDateTime.toLocal(),
                              ),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            monthNameFormatter.format(
                              data.elementAt(index).utcDateTime.toLocal(),
                            ),
                          ),
                          Text(
                            yearLongFormatter.format(
                              data.elementAt(index).utcDateTime.toLocal(),
                            ),
                          )
                        ],
                      ),
                      title: Text(
                        data.elementAt(index).account,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.elementAt(index).category,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data.elementAt(index).note,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(data.elementAt(index).currency),
                          Text(englishDisplayCurrencyFormatter
                              .format(data.elementAt(index).amount)),
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
