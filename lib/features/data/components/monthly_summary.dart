import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonthlySummary extends StatelessWidget {
  const MonthlySummary({
    super.key,
  });

  Map<String, double> getData(CTransactionState state) {
    DateTime localNow = DateTime.now().toLocal();
    Map<String, double> sum = {'income': 0.0, 'expense': 0.0, 'transfer': 0.0};
    for (TransactionData entry in state.committedEntries) {
      DateTime localDateTime = DateTime(
        entry.utcDateTime.toLocal().year,
        entry.utcDateTime.toLocal().month,
        entry.utcDateTime.toLocal().day,
      );

      if (localNow.month == localDateTime.month &&
          localNow.year == localDateTime.year) {
        switch (entry.type) {
          case TransactionType.income:
            double cumulativeIncome = sum['income'] ?? 0.0;
            sum['income'] = cumulativeIncome + entry.amount;
            break;
          case TransactionType.expense:
            double cumulativeExpense = sum['expense'] ?? 0.0;
            sum['expense'] = cumulativeExpense + entry.amount;
            break;
          case TransactionType.transfer:
            double cumulativeTransfer = sum['transfer'] ?? 0.0;
            sum['transfer'] = cumulativeTransfer + entry.amount;
            break;
        }
      }
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    DateTime localNow = DateTime.now();
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'This month\'s total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        dateMonthYearFormatter.format(localNow),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: BlocBuilder<CTransactionCubit, CTransactionState>(
                      builder: (context, state) {
                    final GlobalKey<TooltipState> incomeToolTipKey =
                        GlobalKey<TooltipState>();
                    final GlobalKey<TooltipState> expenseToolTipKey =
                        GlobalKey<TooltipState>();
                    final GlobalKey<TooltipState> transferToolTipKey =
                        GlobalKey<TooltipState>();

                    Map<String, double> data = getData(state);
                    return Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.only(right: 5.0),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue[700],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Income',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .canvasColor),
                                      ),
                                    ),
                                    const Divider(),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            (data['income']! > 1000 || data['income']! < -1000)
                                                ? compactCurrencyFormatter
                                                    .format(data['income'])
                                                : englishDisplayCurrencyFormatter
                                                    .format(
                                                    data['income'],
                                                  ),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Theme.of(context)
                                                    .canvasColor),
                                          ),
                                          if (data['income']! > 1000 || data['income']! < -1000)
                                            Tooltip(
                                              key: incomeToolTipKey,
                                              message:
                                                  englishDisplayCurrencyFormatter
                                                      .format(data['income']),
                                              triggerMode:
                                                  TooltipTriggerMode.manual,
                                              showDuration:
                                                  const Duration(seconds: 10),
                                              child: IconButton(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 5),
                                                constraints:
                                                    const BoxConstraints(),
                                                iconSize: 18,
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                icon: const Icon(Icons
                                                    .info_outline_rounded),
                                                onPressed: () {
                                                  incomeToolTipKey
                                                      .currentState
                                                      ?.ensureTooltipVisible();
                                                },
                                              ),
                                            ),
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Expense',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .canvasColor),
                                      ),
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (data['expense']! > 1000 || data['expense']! < -1000)
                                              ? compactCurrencyFormatter
                                                  .format(data['expense'])
                                              : englishDisplayCurrencyFormatter
                                                  .format(
                                                  data['expense'],
                                                ),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 24,
                                            color:
                                                Theme.of(context).canvasColor,
                                          ),
                                        ),
                                        if (data['expense']! > 1000 || data['expense']! < -1000)
                                          Tooltip(
                                            key: expenseToolTipKey,
                                            message:
                                                englishDisplayCurrencyFormatter
                                                    .format(data['expense']),
                                            triggerMode:
                                                TooltipTriggerMode.manual,
                                            showDuration:
                                                const Duration(seconds: 10),
                                            child: IconButton(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              constraints:
                                                  const BoxConstraints(),
                                              iconSize: 18,
                                              color: Theme.of(context)
                                                  .canvasColor,
                                              icon: const Icon(
                                                  Icons.info_outline_rounded),
                                              onPressed: () {
                                                expenseToolTipKey.currentState
                                                    ?.ensureTooltipVisible();
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.only(left: 5.0),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Transfer',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .canvasColor),
                                      ),
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (data['transfer']! > 1000 || data['transfer']! < -1000)
                                              ? compactCurrencyFormatter
                                                  .format(data['transfer'])
                                              : englishDisplayCurrencyFormatter
                                                  .format(
                                                  data['transfer'],
                                                ),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Theme.of(context)
                                                  .canvasColor),
                                        ),
                                        if (data['transfer']! > 1000 || data['transfer']! < -1000)
                                          Tooltip(
                                            key: transferToolTipKey,
                                            message:
                                                englishDisplayCurrencyFormatter
                                                    .format(data['transfer']),
                                            triggerMode:
                                                TooltipTriggerMode.manual,
                                            showDuration:
                                                const Duration(seconds: 10),
                                            child: IconButton(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              constraints:
                                                  const BoxConstraints(),
                                              iconSize: 18,
                                              color: Theme.of(context)
                                                  .canvasColor,
                                              icon: const Icon(
                                                  Icons.info_outline_rounded),
                                              onPressed: () {
                                                transferToolTipKey
                                                    .currentState
                                                    ?.ensureTooltipVisible();
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Net Change: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    englishDisplayCurrencyFormatter.format(
                                        data['income']! - data['expense']!),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  data['income']! - data['expense']! < 0
                                      ? const Icon(
                                          Icons.arrow_drop_down_rounded,
                                          color: Colors.red)
                                      : data['income']! - data['expense']! != 0
                                          ? const Icon(
                                              Icons.arrow_drop_up_rounded,
                                              color: Colors.green)
                                          : const Icon(Icons.remove)
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ));
  }
}
