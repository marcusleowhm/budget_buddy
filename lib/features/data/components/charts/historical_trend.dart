import 'package:budget_buddy/features/data/components/charts/datetime_series_chart.dart';
import 'package:flutter/material.dart';

class HistoricalTrend extends StatelessWidget {
  const HistoricalTrend({super.key});

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
                  children: [
                    Text(
                      'Historical Trend',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1.0),
              DateTimeSeriesChart()
            ],
          ),
        ),
      ),
    );
  }
}
