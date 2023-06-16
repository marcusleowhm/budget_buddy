import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/piechart_breakdown/single_month_category_list.dart';
import 'package:budget_buddy/features/data/components/statistics/piechart_breakdown/single_month_piechart.dart';
import 'package:flutter/material.dart';

class PiechartPage extends StatelessWidget {
  const PiechartPage(
      {super.key, required this.type, required this.dateTimeValue});

  final TransactionType type;
  final DateTime dateTimeValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleMonthPiechart(
          type: type,
          dateTimeValue: dateTimeValue,
        ),
        const Divider(thickness: 2,),
        SingleMonthCategoryList(
          type: type,
          dateTimeValue: dateTimeValue,
        ),
      ],
    );
  }
}
