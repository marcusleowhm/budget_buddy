import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/breakdown/category_breakdown_list.dart';
import 'package:budget_buddy/features/data/components/statistics/breakdown/category_breakdown_piechart.dart';
import 'package:flutter/material.dart';

class CategoryBreakdownPage extends StatelessWidget {
  const CategoryBreakdownPage(
      {super.key, required this.type, required this.dateTimeValue});

  final TransactionType type;
  final DateTime dateTimeValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CategoryBreakdownPieChart(
          type: type,
          dateTimeValue: dateTimeValue,
        ),
        const Divider(thickness: 2,),
        CategoryBreakdownList(
          type: type,
          dateTimeValue: dateTimeValue,
        ),
      ],
    );
  }
}
