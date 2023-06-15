import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBreakdownPieChart extends StatefulWidget {
  const CategoryBreakdownPieChart(
      {super.key, required this.type, required this.dateTimeValue});

  final TransactionType type;
  final DateTime dateTimeValue;

  @override
  State<CategoryBreakdownPieChart> createState() =>
      _CategoryBreakdownPieChartState();
}

class _CategoryBreakdownPieChartState extends State<CategoryBreakdownPieChart> {
  int touchedIndex = -1;
  double dormantRadius = 50.0;
  double activeRadius = 60.0;
  double centerSpaceRadius = 40.0;

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

    //Pie chart for income
    if (widget.type == TransactionType.income) {
      for (MapEntry<int, MapEntry<String, double>> entry
          in categorySumData.entries.toList().asMap().entries) {
        int index = entry.key - 1;
        MapEntry<String, double> data = entry.value;
        String incomeCategory = data.key;
        double categorySum = data.value;

        final isTouched = index == touchedIndex;
        final radius = isTouched ? activeRadius : dormantRadius;

        //Skip the total when making the piechart
        if (incomeCategory == 'total') {
          continue;
        }

        if (categorySum > 0) {
          pieChartSections.add(
            PieChartSectionData(
              color: Colors.blue[
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(incomeCategory),
                  ],
                ),
              ),
              badgePositionPercentageOffset: 1,
            ),
          );
          colorValue -= 100;
        }
      }
      //Pie chart for expense
    } else if (widget.type == TransactionType.expense) {
      for (MapEntry<int, MapEntry<String, double>> entry
          in categorySumData.entries.toList().asMap().entries) {
        //Need to remove 1 because we are skipping the first entry
        int index = entry.key - 1;
        MapEntry<String, double> data = entry.value;
        String expenseCategory = data.key;
        double categorySum = data.value;

        final isTouched = index == touchedIndex;
        final radius = isTouched ? activeRadius : dormantRadius;

        //Skip the total when making the piechart
        if (expenseCategory == 'total') {
          continue;
        }

        if (categorySum > 0) {
          pieChartSections.add(
            PieChartSectionData(
              color: Colors.red[
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(expenseCategory),
                  ],
                ),
              ),
              badgePositionPercentageOffset: 1,
            ),
          );
          colorValue -= 100;
        }
      }
    }

    return pieChartSections;
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

            double grandTotal = categorySum['total'] ?? 0.0;
            categorySum['total'] = grandTotal += data.amount;
            break;
          case TransactionType.expense:
            double categoryExpenseSum =
                categorySum[data.expenseCategory] ?? 0.0;
            categorySum[data.expenseCategory] =
                categoryExpenseSum + data.amount;

            double grandTotal = categorySum['total'] ?? 0.0;
            categorySum['total'] = grandTotal += data.amount;
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
        return categorySum.isEmpty || categorySum['total'] == 0.0
            ? Expanded(
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    startDegreeOffset: 90,
                    centerSpaceRadius: centerSpaceRadius,
                    sections: prepareEmptyChartData(),
                  ),
                ),
              )
            : Expanded(
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
                    sectionsSpace: 2,
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
