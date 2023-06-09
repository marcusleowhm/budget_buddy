import 'dart:math';

import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateTimeSeriesChart extends StatefulWidget {
  DateTimeSeriesChart({super.key});

  final Color incomeBarColor = Colors.blue[700]!;
  final Color expenseBarColor = Colors.red;

  final Color netPositiveColor = Colors.green;
  final Color netNegativeColor = Colors.red;

  @override
  State<DateTimeSeriesChart> createState() => _DateTimeSeriesChartState();
}

class _DateTimeSeriesChartState extends State<DateTimeSeriesChart> {
  final double width = 7;
  int touchedGroupIndex = -1;
  late double maxY;

  // late double minY;

  List<BarChartGroupData> prepareBarGroups(BuildContext context) {
    List<TransactionData> data =
        context.read<CTransactionCubit>().state.committedEntries;
    List<BarChartGroupData> groups = [];

    //monthly for now
    DateTime now = DateTime.now().toLocal();
    int currentMonth = now.month;
    int currentYear = now.year;
    double maxOfIncomeAndExpense = 0.0;

    for (int i = 1; i <= currentMonth; i++) {
      double incomeSum = 0.0;
      double expenseSum = 0.0;

      // Calculate the sum of income and expense in a particular month
      for (TransactionData entry in data) {
        DateTime entryLocalDateTime = entry.utcDateTime.toLocal();
        if (entryLocalDateTime.month == i &&
            entryLocalDateTime.year == currentYear) {
          switch (entry.type) {
            case TransactionType.income:
              incomeSum += entry.amount;
              break;
            case TransactionType.expense:
              expenseSum += entry.amount;
              break;
            default:
              //Do nothing when it's transfer
              break;
          }

          if (maxOfIncomeAndExpense < max(incomeSum, expenseSum)) {
            maxOfIncomeAndExpense = max(incomeSum, expenseSum);
          }
        }
      }

      //Round up to the next 50 of the highest value in the time series
      maxOfIncomeAndExpense = ((maxOfIncomeAndExpense / 50).ceil() * 50);
      setState(() => maxY = maxOfIncomeAndExpense);

      //Add the group data to the list
      groups.add(_makeGroupData(i, incomeSum, expenseSum));
    }
    return groups;
  }

  BarChartGroupData _makeGroupData(
    int x,
    double incomeValue,
    double expenseValue,
  ) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: incomeValue,
          color: widget.incomeBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: expenseValue,
          color: widget.expenseBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget _buildBottomTitles(double value, TitleMeta meta) {
    DateTime localNow = DateTime.now().toLocal();

    final Widget text = Text(
        monthNameFormatter.format(
          DateTime(
            0,
            value.toInt(),
          ),
        ),
        style: value.toInt() == localNow.month
            ? const TextStyle(fontWeight: FontWeight.bold)
            : null);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = prepareBarGroups(context);

    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        children: [
          // const Row(
          //   children: [Text('Left for future feature update')],
          // ),
          const SizedBox(height: 24),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.grey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) => null,
                  ),
                  touchCallback: (FlTouchEvent event, response) {
                    if (response == null || response.spot == null) {
                      setState(() {
                        //Handle when user does not touch on any bar
                        touchedGroupIndex = -1;
                      });
                      return;
                    }

                    //Else handle when user touch the bar
                    touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: _buildBottomTitles,
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: barGroups,
                gridData: FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
