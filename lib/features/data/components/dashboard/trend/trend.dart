import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/dashboard/trend/datetime_series_chart.dart';
import 'package:flutter/material.dart';

class Trend extends StatefulWidget {
  const Trend({super.key});

  @override
  State<Trend> createState() => _TrendState();
}

class _TrendState extends State<Trend> {
  ChartAmountDisplayCriteria amountFilter = ChartAmountDisplayCriteria.gross;

  static const Map<ChartAmountDisplayCriteria, String> labels = {
    ChartAmountDisplayCriteria.gross: 'Gross Amount',
    ChartAmountDisplayCriteria.nett: 'Nett Amount'
  };

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
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trend',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                      'View',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    PopupMenuButton<ChartAmountDisplayCriteria>(
                      initialValue: amountFilter,
                      onSelected: (ChartAmountDisplayCriteria value) =>
                          setState(() => amountFilter = value),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: ChartAmountDisplayCriteria.gross,
                          child:
                              Text(labels[ChartAmountDisplayCriteria.gross]!),
                        ),
                        PopupMenuItem(
                          value: ChartAmountDisplayCriteria.nett,
                          child:
                              Text(labels[ChartAmountDisplayCriteria.nett]!),
                        ),
                      ],
                      child: TextButton.icon(
                        icon: Text(labels[amountFilter]!),
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
                thickness: 1.0,
                height: 5.0,
              ),
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            '6M',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Tab(
                          child: Text(
                            '5Y',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: TabBarView(
                        children: [
                          DateTimeSeriesChart(
                            dateFilter: ChartDateFilterCriteria.sixMonth,
                            amountFilter: amountFilter,
                          ),
                          DateTimeSeriesChart(
                            dateFilter: ChartDateFilterCriteria.fiveYear,
                            amountFilter: amountFilter,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
