import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPiechart extends StatefulWidget {
  const CategoryPiechart(
      {super.key,
      required this.type,
      this.period,
      required this.dateTimeValue});

  final TransactionType type;
  final PeriodSelectorFilter? period;
  final DateTime dateTimeValue;

  @override
  State<CategoryPiechart> createState() => _CategoryPiechartState();
}

class _CategoryPiechartState extends State<CategoryPiechart> {
  int touchedIndex = -1;
  final double centerSpaceRadius = 70.0;
  final double dormantRadius = 50.0;
  final double activeRadius = 60.0;

  List<PieChartSectionData> prepareEmptyChartData() {
    return <PieChartSectionData>[
      PieChartSectionData(
        color: Colors.grey,
        value: 100,
        title: '',
        radius: dormantRadius,
        badgeWidget: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10.0)),
          child: const Text('No data added yet'),
        ),
      ),
    ];
  }

  List<PieChartSectionData> preparePieChartData(
      Map<String, double> categorySumData) {
    List<PieChartSectionData> pieChartSections = <PieChartSectionData>[];
    int colorValue = 900;

    //Calculate total in map
    double total = 0.0;
    for (MapEntry entry in categorySumData.entries) {
      if (entry.value > 0) {
        total += entry.value;
      }
    }

    for (MapEntry<int, MapEntry<String, double>> entry
        in categorySumData.entries.toList().asMap().entries) {
      int index = entry.key;
      MapEntry<String, double> data = entry.value;
      String categoryName = data.key;
      double categorySum = data.value;

      final isTouched = index == touchedIndex;
      final radius = isTouched ? activeRadius : dormantRadius;

      if (categorySum > 0) {
        pieChartSections.add(
          PieChartSectionData(
            color: widget.type == TransactionType.income
                ? Colors.blue[colorValue]
                : Colors.red[
                    colorValue], //TODO refactor this to use a heatmap library instead?
            value: categorySum,
            title: '',
            radius: radius,
            badgeWidget: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        categoryName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('${(categorySum / total * 100).toStringAsFixed(0)}%'),
                    if (isTouched) const SizedBox(height: 5.0),
                    if (isTouched)
                      Text(
                        englishDisplayCurrencyFormatter.format(categorySum),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ),
            badgePositionPercentageOffset: 0.8,
          ),
        );
        colorValue -= 100;
      }
    }

    return pieChartSections;
  }

  double calculatePositiveTotal(Map<String, double> categorySum) {
    double total = 0.0;
    for (MapEntry entry in categorySum.entries) {
      if (entry.value > 0) {
        total += entry.value;
      }
    }
    return total;
  }

  Map<String, double> filterByCriteria(CTransactionState state) {
    //Key is category, value is sum of that category depending on the type passed in
    Map<String, double> categorySum = {};
    for (TransactionData data in state.committedEntries) {
      DateTime dataLocalDateTime = DateTime(
        data.utcDateTime.toLocal().year,
        data.utcDateTime.toLocal().month,
        data.utcDateTime.toLocal().day,
      );

      //Weekly filter
      if (widget.period == PeriodSelectorFilter.weekly) {
        if ((DateTime(
                  widget.dateTimeValue.year,
                  widget.dateTimeValue.month,
                  widget.dateTimeValue.day,
                ).subtract(Duration(days: widget.dateTimeValue.weekday - 1)) ==
                DateTime(
                  dataLocalDateTime.year,
                  dataLocalDateTime.month,
                  dataLocalDateTime.day,
                ).subtract(Duration(days: dataLocalDateTime.weekday - 1))) &&
            (DateTime(
                  widget.dateTimeValue.year,
                  widget.dateTimeValue.month,
                  widget.dateTimeValue.day,
                ).add(Duration(
                    days:
                        DateTime.daysPerWeek - widget.dateTimeValue.weekday)) ==
                DateTime(
                  dataLocalDateTime.year,
                  dataLocalDateTime.month,
                  dataLocalDateTime.day,
                ).subtract(
                  Duration(
                      days: DateTime.daysPerWeek - dataLocalDateTime.weekday),
                )) &&
            widget.type == data.type) {
          switch (data.type) {
            case TransactionType.income:
              //if key is not present, initialize it to 0.0
              //otherwise simply add to it
              double categoryIncomeSum =
                  categorySum[data.incomeCategory] ?? 0.0;
              categorySum[data.incomeCategory] =
                  categoryIncomeSum + data.amount;
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

      //Month, Year, and Type of data must matched currently selected ones
      if (widget.period == PeriodSelectorFilter.monthly) {
        if (widget.dateTimeValue.month == dataLocalDateTime.month &&
            widget.dateTimeValue.year == dataLocalDateTime.year &&
            widget.type == data.type) {
          switch (data.type) {
            case TransactionType.income:
              //if key is not present, initialize it to 0.0
              //otherwise simply add to it
              double categoryIncomeSum =
                  categorySum[data.incomeCategory] ?? 0.0;
              categorySum[data.incomeCategory] =
                  categoryIncomeSum + data.amount;
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

      //Find data that matches the year only
      if (widget.period == PeriodSelectorFilter.annual) {
        if (widget.dateTimeValue.year == dataLocalDateTime.year &&
            widget.type == data.type) {
          switch (data.type) {
            case TransactionType.income:
              //if key is not present, initialize it to 0.0
              //otherwise simply add to it
              double categoryIncomeSum =
                  categorySum[data.incomeCategory] ?? 0.0;
              categorySum[data.incomeCategory] =
                  categoryIncomeSum + data.amount;
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
        double total = calculatePositiveTotal(categorySum);
        return categorySum.isEmpty || total == 0.0
            ? AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    startDegreeOffset: 90,
                    centerSpaceRadius: centerSpaceRadius,
                    sections: prepareEmptyChartData(),
                  ),
                ),
              )
            : AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(
                          () {
                            //If non of the piechart sections were touched
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          },
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 3,
                    startDegreeOffset: 45,
                    centerSpaceRadius: centerSpaceRadius,
                    sections: preparePieChartData(categorySum),
                  ),
                ),
              );
      },
    );
  }
}
