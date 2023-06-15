import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/breakdown/category_breakdown_page.dart';
import 'package:flutter/material.dart';

class CategoryBreakdown extends StatelessWidget {
  const CategoryBreakdown({super.key, required this.dateTimeValue});

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
              DefaultTabController(
                initialIndex: 1,
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(
                          child: Text('Income',
                              style: TextStyle(color: Colors.black)),
                        ),
                        Tab(
                          child: Text('Expense',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: TabBarView(
                        children: [
                          CategoryBreakdownPage(
                            type: TransactionType.income,
                            dateTimeValue: dateTimeValue,
                          ),
                          CategoryBreakdownPage(
                            type: TransactionType.expense,
                            dateTimeValue: dateTimeValue,
                          ),
                        ],
                      ),
                    )
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
