import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/piechart_breakdown/category_list.dart';
import 'package:budget_buddy/features/data/components/statistics/piechart_breakdown/category_piechart.dart';
import 'package:flutter/material.dart';

class PiechartPage extends StatelessWidget {
  const PiechartPage(
      {super.key, required this.type, this.period, required this.dateTimeValue});

  final TransactionType type;
  final FilterPeriod? period;
  final DateTime dateTimeValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategoryPiechart(
          type: type,
          period: period,
          dateTimeValue: dateTimeValue,
        ),
        const Divider(thickness: 2,),
        CategoryList(
          type: type,
          period: period,
          dateTimeValue: dateTimeValue,
        ),
      ],
    );
  }
}
