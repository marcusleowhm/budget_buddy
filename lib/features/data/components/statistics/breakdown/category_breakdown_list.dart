import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBreakdownList extends StatefulWidget {
  const CategoryBreakdownList(
      {super.key, required this.type, required this.dateTimeValue});

  final TransactionType type;
  final DateTime dateTimeValue;

  @override
  State<CategoryBreakdownList> createState() => _CategoryBreakdownListState();
}

class _CategoryBreakdownListState extends State<CategoryBreakdownList> {
  Map<String, double> filterByCriteria(CTransactionState state) {
    //Key is category, value is sum of that category depending on the type passed in
    Map<String, double> categorySum = {};
    for (TransactionData data in state.committedEntries) {
      DateTime dataLocalDateTime = DateTime(
        data.utcDateTime.toLocal().year,
        data.utcDateTime.toLocal().month,
        data.utcDateTime.toLocal().day,
      );

      //Month, Year, and Type of data must matched currently selected ones
      if (widget.dateTimeValue.month == dataLocalDateTime.month &&
          widget.dateTimeValue.year == dataLocalDateTime.year &&
          widget.type == data.type) {
        switch (data.type) {
          case TransactionType.income:
            //if key is not present, initialize it to 0.0
            //otherwise simply add to it
            double categoryIncomeSum = categorySum[data.incomeCategory] ?? 0.0;
            categorySum[data.incomeCategory] = categoryIncomeSum + data.amount;
            break;
          case TransactionType.expense:
            double categoryExpenseSum =
                categorySum[data.expenseCategory] ?? 0.0;
            categorySum[data.expenseCategory] =
                categoryExpenseSum + data.amount;
            break;
          default:
            //Do nothing, there is no use for transfer type
            break;
        }
      }
    }

    //Sort by descending categorySum first before returning
    categorySum = Map.fromEntries(categorySum.entries.toList()
      ..sort((entryOne, entryTwo) => entryTwo.value.compareTo(entryOne.value)));
    return categorySum;
  }

  double calculateTotal(Map<String, double> filteredCategory) {
    double total = 0.0;
    for (double sum in filteredCategory.values) {
      if (sum > 0) {
        total += sum;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CTransactionCubit, CTransactionState>(
      builder: (context, state) {
        Map<String, double> categorySum = filterByCriteria(state);
        double total = calculateTotal(categorySum);
        int colorValue = 900;

        return categorySum.isEmpty
            ? const Text('No data added yet')
            : Container(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categorySum.length + 1,
                      itemBuilder: (context, index) {
                        //Row header
                        if (index == 0) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Click or Tap on amount to see full amount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ]),
                          );
                        }

                        index--;
                        double percentage =
                            categorySum.entries.elementAt(index).value /
                                total *
                                100;
                        GlobalKey<TooltipState> tooltipKey = GlobalKey();

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Category
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    print('TODO implement category trend feature');
                                    //TODO implement
                                  },
                                  child: Text(
                                    categorySum.entries.elementAt(index).key,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                        
                              //Subtotal
                              Row(
                                children: [
                                  //Sum
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        tooltipKey.currentState
                                            ?.ensureTooltipVisible();
                                      },
                                      child: Tooltip(
                                        message: englishDisplayCurrencyFormatter
                                            .format(categorySum.entries
                                                .elementAt(index)
                                                .value),
                                        triggerMode: TooltipTriggerMode.manual,
                                        showDuration:
                                            const Duration(seconds: 5),
                                        key: tooltipKey,
                                        child: Container(
                                          width: 80,
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .red[colorValue - 100 * index]!,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Text(
                                              (categorySum.entries
                                                              .elementAt(index)
                                                              .value >
                                                          1000 ||
                                                      categorySum.entries
                                                              .elementAt(index)
                                                              .value <
                                                          -1000)
                                                  ? compactCurrencyFormatter
                                                      .format(categorySum
                                                          .entries
                                                          .elementAt(index)
                                                          .value)
                                                  : englishDisplayCurrencyFormatter
                                                      .format(
                                                      categorySum.entries
                                                          .elementAt(index)
                                                          .value,
                                                    ),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .canvasColor)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //Percentage
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Container(
                                      width: 70,
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .red[colorValue - 100 * index]!,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Text(
                                        percentage > 0
                                            ? '${percentage.toStringAsFixed(2)}%'
                                            : 'N/A',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).canvasColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }
}
