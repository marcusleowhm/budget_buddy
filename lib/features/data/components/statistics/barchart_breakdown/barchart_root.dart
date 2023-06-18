import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/barchart_breakdown/fiveyear_barchart.dart';
import 'package:budget_buddy/features/data/widgets/custom_tab_controller.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';

class BarchartRoot extends StatelessWidget {
  const BarchartRoot({super.key, this.period, required this.dateTimeValue});

  final DateTime dateTimeValue;
  final FilterPeriod? period;

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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Breakdown by Category for ${monthNameFormatter.format(dateTimeValue)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomTabController(
                initialIndex: 1,
                length: 2,
                tabs: const [
                  Tab(
                    child:
                        Text('Income', style: TextStyle(color: Colors.black)),
                  ),
                  Tab(
                    child:
                        Text('Expense', style: TextStyle(color: Colors.black)),
                  ),
                ],
                views: [
                  FiveYearBarchart(
                    type: TransactionType.income,
                    dateTimeValue: dateTimeValue,
                  ),
                  FiveYearBarchart(
                    type: TransactionType.expense,
                    dateTimeValue: dateTimeValue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
