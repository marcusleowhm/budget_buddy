import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/breakdown/category_piechart.dart';
import 'package:flutter/material.dart';

class CategoryBreakdown extends StatelessWidget {
  const CategoryBreakdown({super.key});

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
              DefaultTabController(
                initialIndex: 1,
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          child: Text('Income',
                              style: TextStyle(color: Colors.black)),
                        ),
                        Tab(
                          child: Text('Expense',
                              style: TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: TabBarView(
                        children: [
                          CategoryPiechart(type: TransactionType.income),
                          CategoryPiechart(type: TransactionType.expense),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
