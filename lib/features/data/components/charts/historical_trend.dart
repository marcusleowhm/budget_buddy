import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/charts/datetime_series_chart.dart';
import 'package:flutter/material.dart';

class HistoricalTrend extends StatefulWidget {
  const HistoricalTrend({super.key});

  @override
  State<HistoricalTrend> createState() => _HistoricalTrendState();
}

class _HistoricalTrendState extends State<HistoricalTrend> {
  ChartDateFilterCriteria dateFilter = ChartDateFilterCriteria.monthly;
  ChartAmountDisplayCriteria amountFilter = ChartAmountDisplayCriteria.gross;

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
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Historical Trend',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            dateFilter == ChartDateFilterCriteria.monthly
                                ? setState(() =>
                                    dateFilter = ChartDateFilterCriteria.yearly)
                                : setState(() => dateFilter =
                                    ChartDateFilterCriteria.monthly);
                          },
                          child: Text(
                              'View ${dateFilter == ChartDateFilterCriteria.monthly ? 'Yearly' : 'Monthly'}'),
                        ),
                        TextButton(
                          onPressed: () {
                            amountFilter == ChartAmountDisplayCriteria.gross
                                ? setState(() => amountFilter =
                                    ChartAmountDisplayCriteria.nett)
                                : setState(() => amountFilter =
                                    ChartAmountDisplayCriteria.gross);
                          },
                          child: Text(
                              'View ${amountFilter == ChartAmountDisplayCriteria.gross ? 'Net' : 'Gross'}'),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const Divider(thickness: 1.0),
              DateTimeSeriesChart(
                dateFilter: dateFilter,
                amountFilter: amountFilter,
              )
            ],
          ),
        ),
      ),
    );
  }
}
