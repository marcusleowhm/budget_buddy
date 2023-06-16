import 'package:budget_buddy/features/data/components/statistics/barchart_breakdown/barchart_root.dart';
import 'package:budget_buddy/features/data/components/statistics/piechart_breakdown/piechart_root.dart';
import 'package:budget_buddy/features/data/widgets/month_carousel.dart';
import 'package:flutter/material.dart';

class CommittedTransactionStatistics extends StatelessWidget {
  CommittedTransactionStatistics({
    super.key,
    required this.dateTimeValue,
    required this.localNow,
    required this.incrementMonth,
    required this.decrementMonth,
    required this.resetDate,
  });

  final DateTime dateTimeValue;
  final DateTime localNow;

  //Scroll controller for scrolling down
  final ScrollController _scrollController = ScrollController();
  final VoidCallback incrementMonth;
  final VoidCallback decrementMonth;
  final VoidCallback resetDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MonthCarousel(
          dateTimeValue: dateTimeValue,
          localNow: localNow,
          incrementMonth: incrementMonth,
          decrementMonth: decrementMonth,
          resetDate: resetDate,
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                PiechartRoot(
                  dateTimeValue: dateTimeValue,
                ),
                BarchartRoot(
                  dateTimeValue: dateTimeValue,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
