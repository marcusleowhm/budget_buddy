import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FiveYearBarchart extends StatefulWidget {
  const FiveYearBarchart(
      {super.key, required this.type, required this.dateTimeValue});

  final TransactionType type;
  final DateTime dateTimeValue;

  @override
  State<FiveYearBarchart> createState() => _FiveYearBarchartState();
}

class _FiveYearBarchartState extends State<FiveYearBarchart> {
  int touchedIndex = -1;
  final double barWidth = 22;

  Map<int, List<Map<String, double>>> formatData(CTransactionState state) {
    Map<int, List<Map<String, double>>> formattedData = {};

    for (int i = widget.dateTimeValue.year - 4;
        i <= widget.dateTimeValue.year;
        i++) {
      List<Map<String, double>> yearlyData = [];
      for (TransactionData data in state.committedEntries) {
        DateTime dataLocalDateTime = data.utcDateTime.toLocal();
        //Ensure that the month, year and type is the same as what's being passed in
        if (dataLocalDateTime.year == i &&
            dataLocalDateTime.month == widget.dateTimeValue.month &&
            data.type == widget.type) {
          switch (data.type) {
            case TransactionType.income:
              yearlyData.add({data.incomeCategory: data.amount});
              break;
            case TransactionType.expense:
              yearlyData.add({data.expenseCategory: data.amount});
              break;
            default:
              //Do nothing if it's transfer
              break;
          }
        }
        //Sort the yearly data in ascending order
        yearlyData.sort((a, b) => a.values.first.compareTo(b.values.first));
      }
      //Add into the main formatted data
      formattedData.putIfAbsent(i, () => yearlyData);
    }
    return formattedData;
  }

  int countRodStackItems(Map<int, List<Map<String, double>>> formatted) {
    int count = 0;

    for (MapEntry<int, List<Map<String, double>>> entry in formatted.entries) {
      count += entry.value.length;
    }
    return count;
  }

  BarChartGroupData generateGroup(int year, List<Map<String, double>> values) {
    //Check if the smallest value is positive or negative
    //The list being passed in is a list of map with only 1 entry, hence, we use first to access the amount
    bool isTop = values.isNotEmpty && values.first.values.first > 0;
    double sum = 0;
    for (Map<String, double> element in values) {
      sum += element.values.first;
    }
    //TODO calculate sum for positive number


    bool isTouched =
        touchedIndex == year; //TODO change this to something other than year
    //touchedIndex is zero indexed, year is just the year itself

    return BarChartGroupData(
      x: year,
      groupVertically: true,
      barsSpace: 6,
      showingTooltipIndicators: isTouched ? [2] : [],
      barRods: [
        BarChartRodData(
          toY: sum,
          width: barWidth,
          borderRadius: isTop
              ? const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                )
              : const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
          rodStackItems: generateBarChartRodStackItems(values),
        ),
      ],
    );
  }

  List<BarChartRodStackItem> generateBarChartRodStackItems(
      List<Map<String, double>> values) {
    List<BarChartRodStackItem> items = [];
    double stackItemTotal = 0.0;
    int colorValue = 900;

    //TODO create logic for negative stack item
    for (int i = 0; i < values.length; i++) {
      //The first rod stack item in the list
      if (items.isEmpty) {
        items.add(
          BarChartRodStackItem(
            0,
            stackItemTotal + values.elementAt(i).values.first,
            Colors.lightBlue[colorValue - 100 * i]!,
          ),
        );
      } else {
        items.add(
          BarChartRodStackItem(
            stackItemTotal,
            stackItemTotal + values.elementAt(i).values.first,
            Colors.lightBlue[colorValue - 100 * i]!,
          ),
        );
      }

      //Update the total for the next iteration
      stackItemTotal += values.elementAt(i).values.first;
    }
    return items;
  }

  Widget _buildBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.black);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: Text(value.toInt().toString(), style: style),
    );
  }

  Widget _buildLeftTitles(double value, TitleMeta meta) {
    double roundingThreshold = 0.5;

    Widget axisTitle = Text(compactCurrencyFormatter.format(value));
    // A workaround to hide the max value title as FLChart is overlapping it on top of previous
    if (value == meta.max) {
      final remainder = value % meta.appliedInterval;
      if (remainder != 0.0 &&
          remainder / meta.appliedInterval < roundingThreshold) {
        axisTitle = const SizedBox.shrink();
      }
    }

    if (value == meta.min) {
      final remainder = -value % meta.appliedInterval;
      if (remainder != 0.0 &&
          -remainder / meta.appliedInterval < roundingThreshold) {
        axisTitle = const SizedBox.shrink();
      }
    }

    return SideTitleWidget(axisSide: meta.axisSide, child: axisTitle);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CTransactionCubit, CTransactionState>(
      builder: (context, state) {
        Map<int, List<Map<String, double>>> formattedData = formatData(state);
        int count = countRodStackItems(formattedData);
        return AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 30.0),
            child: BarChart(
              BarChartData(
                maxY: count == 0 ? 100.0 : null,
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 0,
                      strokeWidth: 0.5,
                      color: Colors.grey,
                      dashArray: [
                        20,
                        5,
                      ],
                    ),
                  ],
                ),
                alignment: BarChartAlignment.center,
                barGroups: formattedData.entries
                    .map((entry) => generateGroup(entry.key, entry.value))
                    .toList(),
                groupsSpace: 36,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    fitInsideVertically: true,
                  ),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {},
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: _buildBottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 56,
                      getTitlesWidget: _buildLeftTitles,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
