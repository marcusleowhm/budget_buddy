import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/piechart_breakdown/piechart_root.dart';
import 'package:budget_buddy/features/data/widgets/period_carousel.dart';
import 'package:flutter/material.dart';

class CommittedTransactionStatistics extends StatelessWidget {
  CommittedTransactionStatistics({
    super.key,
    required this.dateTimeValue,
    required this.localNow,
    required this.incrementPeriod,
    required this.decrementPeriod,
    required this.resetDate,
    this.period,
    this.periodSelector,
  });

  final DateTime dateTimeValue;
  final DateTime localNow;

  //Scroll controller for scrolling down
  final ScrollController _scrollController = ScrollController();
  final VoidCallback incrementPeriod;
  final VoidCallback decrementPeriod;
  final VoidCallback resetDate;

  final PeriodSelectorFilter? period;
  final Widget? periodSelector;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PeriodCarousel(
          dateTimeValue: dateTimeValue,
          localNow: localNow,
          incrementPeriod: incrementPeriod,
          decrementPeriod: decrementPeriod,
          resetDate: resetDate,
          period: period,
          periodSelector: periodSelector,
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                PiechartRoot(
                  period: period,
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
