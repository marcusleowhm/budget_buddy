import 'dart:math';

import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/utilities/chart_formatter.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateTimeSeriesChart extends StatefulWidget {
  DateTimeSeriesChart(
      {super.key, required this.dateFilter, required this.amountFilter});

  final Color incomeBarColor = Colors.blue[700]!;
  final Color expenseBarColor = Colors.red;

  final Color netPositiveColor = Colors.green;
  final Color netNegativeColor = Colors.red;

  final ChartDateFilterCriteria dateFilter;
  final ChartAmountDisplayCriteria amountFilter;

  @override
  State<DateTimeSeriesChart> createState() => _DateTimeSeriesChartState();
}

class _DateTimeSeriesChartState extends State<DateTimeSeriesChart> {
  final double width = 7;
  int touchedGroupIndex = -1;
  double maxY = 0.0;
  double minY = 0.0;

  // late double minY;

  List<BarChartGroupData> prepareBarGroups(BuildContext context) {
    List<TransactionData> data =
        context.read<CTransactionCubit>().state.committedEntries;
    List<BarChartGroupData> groups = [];
    DateTime now = DateTime.now().toLocal();
    int currentMonth = now.month;
    int currentYear = now.year;
    double maxOfIncomeAndExpense = 0.0;
    double minOfIncomeAndExpense = 0.0;

    if (widget.dateFilter == ChartDateFilterCriteria.monthly) {
      //Starting month will always be 1, since Monthly filter implies Year to Date in Monthly intervals
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
          }
        }

        if (widget.amountFilter == ChartAmountDisplayCriteria.gross) {
          if (maxOfIncomeAndExpense < max(incomeSum, expenseSum)) {
            maxOfIncomeAndExpense = max(incomeSum, expenseSum);
          }

          //Round up to the nearest of the highest value in the time series
          maxOfIncomeAndExpense = roundToNearestPositive(maxOfIncomeAndExpense);
          setState(() {
            maxY = maxOfIncomeAndExpense;
            minY = 0.0;
          });

          //Add the group data to the list
          groups.add(_makeDoubleBarGroupData(i, incomeSum, expenseSum));
        }

        if (widget.amountFilter == ChartAmountDisplayCriteria.nett) {
          //If the income is higher than the expense, we can find the max Y
          if (incomeSum > expenseSum &&
              maxOfIncomeAndExpense < incomeSum - expenseSum) {
            maxOfIncomeAndExpense = incomeSum - expenseSum;
          }

          //If the income is lower than the expense, we find the minimum Y
          if (incomeSum < expenseSum &&
              minOfIncomeAndExpense > incomeSum - expenseSum) {
            minOfIncomeAndExpense = incomeSum - expenseSum;
          }

          //Round up to the nearest of the highest value in the time series
          maxOfIncomeAndExpense = roundToNearestPositive(maxOfIncomeAndExpense);
          minOfIncomeAndExpense = roundToNearestNegative(minOfIncomeAndExpense);
          setState(() {
            maxY = maxOfIncomeAndExpense;
            minY = minOfIncomeAndExpense;
          });

          //Add the group data to the list
          groups.add(_makeSingleBarGroupdata(i, incomeSum - expenseSum));
        }
      }
    }

    //Starting month will be the 5th past year from current year
    if (widget.dateFilter == ChartDateFilterCriteria.yearly) {
      for (int i = currentYear - 4; i <= currentYear; i++) {
        double incomeSum = 0.0;
        double expenseSum = 0.0;
        for (TransactionData entry in data) {
          DateTime entryLocalDateTime = entry.utcDateTime.toLocal();
          if (entryLocalDateTime.year == i) {
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
          }
        }

        //Calculated only if the data's year is equals to i
        if (widget.amountFilter == ChartAmountDisplayCriteria.gross) {
          if (maxOfIncomeAndExpense < max(incomeSum, expenseSum)) {
            maxOfIncomeAndExpense = max(incomeSum, expenseSum);
          }

          //Round up to the next 50 of the highest value in the time series
          maxOfIncomeAndExpense = roundToNearestPositive(maxOfIncomeAndExpense);
          setState(() {
            maxY = maxOfIncomeAndExpense;
            minY = 0.0;
          });

          //Add the group data to the list
          groups.add(_makeDoubleBarGroupData(i, incomeSum, expenseSum));
        }

        if (widget.amountFilter == ChartAmountDisplayCriteria.nett) {
          //If the income is higher than the expense, we can find the max Y
          if (incomeSum > expenseSum &&
              maxOfIncomeAndExpense < incomeSum - expenseSum) {
            maxOfIncomeAndExpense = incomeSum - expenseSum;
          }

          //If the income is lower than the expense, we find the minimum Y
          if (incomeSum < expenseSum &&
              minOfIncomeAndExpense > incomeSum - expenseSum) {
            minOfIncomeAndExpense = incomeSum - expenseSum;
          }

          //Round up to the nearest of the highest value in the time series
          maxOfIncomeAndExpense = roundToNearestPositive(maxOfIncomeAndExpense);
          //Round down to the nearest of the lowest value in time series
          minOfIncomeAndExpense = roundToNearestNegative(minOfIncomeAndExpense);
          setState(() {
            maxY = maxOfIncomeAndExpense;
            minY = minOfIncomeAndExpense;
          });
          //Add the group data to the list
          groups.add(_makeSingleBarGroupdata(i, incomeSum - expenseSum));
        }
      }
    }

    return groups;
  }

  BarChartGroupData _makeDoubleBarGroupData(
    int x,
    double incomeValue,
    double expenseValue,
  ) {
    return BarChartGroupData(
        barsSpace: 6,
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
        showingTooltipIndicators: touchedGroupIndex == x ? [2] : []);
  }

  BarChartGroupData _makeSingleBarGroupdata(
    int x,
    double nettValue,
  ) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: nettValue,
        color:
            nettValue < 0 ? widget.netNegativeColor : widget.netPositiveColor,
        width: width,
      ),
    ]);
  }

  Widget _buildBottomTitles(double value, TitleMeta meta) {
    DateTime localNow = DateTime.now().toLocal();

    Widget text = const Text('');
    if (widget.dateFilter == ChartDateFilterCriteria.monthly) {
      text = Text(
        monthNameFormatter.format(
          DateTime(
            0,
            value.toInt(),
          ),
        ),
        style: value.toInt() == localNow.month
            ? const TextStyle(fontWeight: FontWeight.bold)
            : null,
      );

      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 16, //margin top
        child: text,
      );
    }

    //If the date filter is yearly
    if (widget.dateFilter == ChartDateFilterCriteria.yearly) {
      text = Text(
        yearLongFormatter.format(
          DateTime(
            value.toInt(),
          ),
        ),
        style: value.toInt() == localNow.year
            ? const TextStyle(fontWeight: FontWeight.bold)
            : null,
      );
    }

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
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: BarChart(
                BarChartData(
                  maxY: maxY == 0.0 ? 50.0 : maxY,
                  minY: minY == 0.0 ? 0.0 : minY,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey[200],
                      getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        return BarTooltipItem(
                          englishDisplayCurrencyFormatter.format(rod.toY),
                          TextStyle(
                              fontWeight: FontWeight.bold,
                              color: rod.color,
                              fontSize: 16,
                              shadows: const [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 12,
                                )
                              ]),
                        );
                      },
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
                      if (event.isInterestedForInteractions &&
                          response.spot != null) {
                        setState(() => touchedGroupIndex =
                            response.spot!.touchedBarGroupIndex);
                      }
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
                    leftTitles: AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 42),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: barGroups,
                  gridData: FlGridData(
                    show: false,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
