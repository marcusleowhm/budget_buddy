import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/piechart_breakdown/piechart_page.dart';
import 'package:budget_buddy/features/data/widgets/custom_tab_controller.dart';
import 'package:flutter/material.dart';

class PiechartRoot extends StatelessWidget {
  const PiechartRoot({super.key, required this.dateTimeValue});

  final DateTime dateTimeValue;

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
              const Text(
                'Monthly Breakdown by Category',
                style: TextStyle(
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
                    dateTimeValue: dateTimeValue,
                  ),
                  PiechartPage(
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
