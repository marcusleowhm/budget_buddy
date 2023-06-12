import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
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
  final double width = 12;
  int touchedGroupIndex = -1;

  List<BarChartGroupData> prepareBarGroups(CTransactionState state) {
    List<TransactionData> data = state.committedEntries;

    List<BarChartGroupData> groups = [];
    DateTime now = DateTime.now().toLocal();
    int currentLocalMonth = now.month;
    int currentLocalYear = now.year;

    if (widget.dateFilter == ChartDateFilterCriteria.monthly) {
      //Starting month will always be 1, since Monthly filter implies Year to Date in Monthly intervals
      for (int i = 1; i <= currentLocalMonth; i++) {
        double incomeSum = 0.0;
        double expenseSum = 0.0;

        // Calculate the sum of income and expense in a particular month
        for (TransactionData entry in data) {
          DateTime entryLocalDateTime = entry.utcDateTime.toLocal();
          if (entryLocalDateTime.month == i &&
              entryLocalDateTime.year == currentLocalYear) {
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

        switch (widget.amountFilter) {
          case ChartAmountDisplayCriteria.gross:
            groups.add(_makeDoubleBarGroupData(i, incomeSum, expenseSum));
            break;
          case ChartAmountDisplayCriteria.nett:
            groups.add(_makeSingleBarGroupdata(i, incomeSum - expenseSum));
            break;
        }
      }
    }

    //Starting month will be the 5th past year from current year
    if (widget.dateFilter == ChartDateFilterCriteria.yearly) {
      for (int i = currentLocalYear - 4; i <= currentLocalYear; i++) {
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

        switch (widget.amountFilter) {
          case ChartAmountDisplayCriteria.gross:
            groups.add(_makeDoubleBarGroupData(i, incomeSum, expenseSum));
            break;
          case ChartAmountDisplayCriteria.nett:
            groups.add(_makeSingleBarGroupdata(i, incomeSum - expenseSum));
            break;
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
    return BlocBuilder<CTransactionCubit, CTransactionState>(
      builder: (context, state) {
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
                      maxY: state.committedEntries.isEmpty ? 50.0 : null,
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                              y: 0,
                              strokeWidth: 0.5,
                              color: Colors.grey,
                              dashArray: [
                                20,
                                5,
                              ]),
                        ],
                      ),
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
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: _buildLeftTitles,
                            reservedSize: 56,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: prepareBarGroups(state),
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
      },
    );
  }
}
