import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';

class PeriodCarousel extends StatelessWidget {
  const PeriodCarousel({
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
  final VoidCallback incrementPeriod;
  final VoidCallback decrementPeriod;
  final VoidCallback resetDate;

  final FilterPeriod? period;
  final Widget? periodSelector;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              //Left chevron button
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: decrementPeriod,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                constraints: const BoxConstraints(),
              ),
              //Date to display
              SizedBox(
                width: period == FilterPeriod.weekly ? 100 : 80,
                child: Text(
                    period == FilterPeriod.monthly
                        ? dateMonthYearFormatter.format(dateTimeValue)
                        : period == FilterPeriod.annual
                            ? yearLongFormatter.format(dateTimeValue)
                            : '${dateShortFormatter.format(dateTimeValue.subtract(Duration(days: dateTimeValue.weekday - 1)))} '
                                'to '
                                '${dateShortFormatter.format(dateTimeValue.add(Duration(days: DateTime.daysPerWeek - dateTimeValue.weekday)))}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16)),
              ),
              //Right chevron button
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: incrementPeriod,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                constraints: const BoxConstraints(),
              ),

              //TODO fix the logic to display reset button
              if (period == FilterPeriod.weekly && dateTimeValue != localNow)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: resetDate,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
                  constraints: const BoxConstraints(),
                ),
              if (
                  //Monthly period
                  //Same month but different year
                  //Different month, year is irrelevant
                  period == FilterPeriod.monthly &&
                          (dateTimeValue.month == localNow.month &&
                              dateTimeValue.year != localNow.year) ||
                      (dateTimeValue.month != localNow.month))
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: resetDate,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
                  constraints: const BoxConstraints(),
                ),
              if (
                  //Yearly period
                  //Different year
                  period == FilterPeriod.annual &&
                      dateTimeValue.year != localNow.year)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: resetDate,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          Row(
            children: [if (periodSelector != null) periodSelector!],
          )
        ],
      ),
    );
  }
}
