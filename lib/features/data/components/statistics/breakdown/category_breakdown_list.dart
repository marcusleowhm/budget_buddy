import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CTransactionCubit, CTransactionState>(
      builder: (context, state) {
        Map<String, double> categorySum = filterByCriteria(state);
        return categorySum.isEmpty
            ? const Flexible(
              child: Center(
                  child: Text('No data added yet'),
                ),
            )
            : Flexible(
              flex: 2,
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: categorySum.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(categorySum.entries.elementAt(index).key),
                                Text(categorySum.entries
                                    .elementAt(index)
                                    .value
                                    .toString())
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            );
      },
    );
  }
}