import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/piechart_breakdown/piechart_page.dart';
import 'package:budget_buddy/features/data/widgets/custom_tab_controller.dart';
import 'package:flutter/material.dart';

class PiechartRoot extends StatelessWidget {
  const PiechartRoot({super.key, this.period, required this.dateTimeValue});

  final PeriodSelectorFilter? period;
  final DateTime dateTimeValue;

  static const Map<PeriodSelectorFilter, String> map = {
    PeriodSelectorFilter.weekly: 'Weekly',
    PeriodSelectorFilter.monthly: 'Monthly',
    PeriodSelectorFilter.annual: 'Annual',
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${map[period]} Breakdown by Category',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomTabController(
                initialIndex: 1,
                length: 2,
                tabs: const [
                  Tab(
                    child: Text(
                      'Income',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Expense',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
                views: [
                  PiechartPage(
                    type: TransactionType.income,
                    period: period,
                    dateTimeValue: dateTimeValue,
                  ),
                  PiechartPage(
                    type: TransactionType.expense,
                    period: period,
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
