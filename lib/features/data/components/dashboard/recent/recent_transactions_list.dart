import 'dart:math';

import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecentTransactionsList extends StatefulWidget {
  const RecentTransactionsList({super.key});

  @override
  State<RecentTransactionsList> createState() => _RecentTransactionsListState();
}

class _RecentTransactionsListState extends State<RecentTransactionsList> {
  static const Map<RecentTransactionFilterCriteria, String> labels = {
    RecentTransactionFilterCriteria.transactionDate: 'Transaction Date',
    RecentTransactionFilterCriteria.createdDate: 'Created Date',
    RecentTransactionFilterCriteria.modifiedDate: 'Modified Date'
  };

  RecentTransactionFilterCriteria filterCriteria =
      RecentTransactionFilterCriteria.transactionDate;

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
              GlobalKey<TooltipState> recentTransactionTooltip = GlobalKey();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        const Text(
                          'Recent Transactions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Tooltip(
                          key: recentTransactionTooltip,
                          message:
                              'Up to 10 recent transactions will appear here.',
                          showDuration: const Duration(seconds: 3),
                          triggerMode: TooltipTriggerMode.manual,
                          child: IconButton(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            constraints: const BoxConstraints(),
                            iconSize: 16,
                            icon: const Icon(
                              Icons.info_outline_rounded,
                            ),
                            onPressed: () {
                              recentTransactionTooltip.currentState
                                  ?.ensureTooltipVisible();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter by',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        PopupMenuButton(
                          initialValue: filterCriteria,
                          onSelected: (RecentTransactionFilterCriteria value) {
                            setState(() => filterCriteria = value);
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: RecentTransactionFilterCriteria
                                  .transactionDate,
                              child: Text(labels[RecentTransactionFilterCriteria
                                  .transactionDate]!),
                            ),
                            PopupMenuItem(
                              value:
                                  RecentTransactionFilterCriteria.createdDate,
                              child: Text(labels[RecentTransactionFilterCriteria
                                  .createdDate]!),
                            ),
                            PopupMenuItem(
                              value:
                                  RecentTransactionFilterCriteria.modifiedDate,
                              child: Text(labels[RecentTransactionFilterCriteria
                                  .modifiedDate]!),
                            ),
                          ],
                          child: TextButton.icon(
                            icon: Text(labels[filterCriteria]!),
                            label: const Icon(Icons.arrow_drop_down_rounded),
                            onPressed: null,
                            style: const ButtonStyle(
                              padding:
                                  MaterialStatePropertyAll<EdgeInsetsGeometry?>(
                                EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 5.0,
                  ),

                  //If the transaction is empty
                  if (state.committedEntries.isEmpty)
                    const ListTile(
                      title: Column(
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
                          ]),
                    ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: min(10, state.committedEntries.length) * 2,
                    itemBuilder: (context, index) {
                      if (index.isOdd) {
                        return const Divider(
                          thickness: 1,
                        );
                      }
                      index = index ~/ 2;
                      final GlobalKey<TooltipState> tooltipKey =
                          GlobalKey<TooltipState>();

                      return ListTile(
                        onTap: () {
                          context.go(
                            '/${routes[MainRoutes.ledger]}/${routes[SubRoutes.editLedger]}',
                            extra: data.elementAt(index),
                          );
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 10.0),
                              child: Text(
                                dateFormatter.format(
                                  data.elementAt(index).utcDateTime.toLocal(),
                                ),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                data.elementAt(index).type ==
                                        TransactionType.income
                                    ? data.elementAt(index).incomeCategory
                                    : data.elementAt(index).type ==
                                            TransactionType.expense
                                        ? data.elementAt(index).expenseCategory
                                        : data
                                            .elementAt(index)
                                            .transferCategory,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                data.elementAt(index).note.isEmpty
                                    ? '-'
                                    : data.elementAt(index).note,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
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
                          ],
                        ),
                        trailing: Tooltip(
                          key: tooltipKey,
                          triggerMode: TooltipTriggerMode.manual,
                          showDuration: const Duration(seconds: 10),
                          // message: toolTipMessage,
                          richMessage: TextSpan(children: [
                            TextSpan(
                              text:
                                  'Created: ${dateFormatter.format(data.elementAt(index).createdUtcDateTime!)}\n',
                            ),
                            TextSpan(
                              text: data.elementAt(index).modifiedUtcDateTime ==
                                      null
                                  ? 'Modified: Never\n\n'
                                  : 'Modified: ${dateFormatter.format(data.elementAt(index).modifiedUtcDateTime!)}\n\n',
                            ),
                            TextSpan(
                                text:
                                    data.elementAt(index).additionalNote.isEmpty
                                        ? 'No additional note added'
                                        : data.elementAt(index).additionalNote,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic)),
                          ]),
                          child: IconButton(
                            icon: const Icon(Icons.info_outline_rounded),
                            onPressed: () {
                              tooltipKey.currentState?.ensureTooltipVisible();
                            },
                          ),
                        ),
                      );
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
