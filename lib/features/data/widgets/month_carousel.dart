import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';

class MonthCarousel extends StatelessWidget {
  const MonthCarousel({
    super.key,
    required this.dateTimeValue,
    required this.localNow,
    required this.incrementMonth,
    required this.decrementMonth,
    required this.resetDate,
    this.periodSelector,
  });

  final DateTime dateTimeValue;
  final DateTime localNow;
  final VoidCallback incrementMonth;
  final VoidCallback decrementMonth;
  final VoidCallback resetDate;

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
                onPressed: decrementMonth,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                constraints: const BoxConstraints(),
              ),
              //Date to display
              SizedBox(
                width: 80,
                child: Text(dateMonthYearFormatter.format(dateTimeValue),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16)),
              ),
              //Right chevron button
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: incrementMonth,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                constraints: const BoxConstraints(),
              ),
              if (
                  //Same month but different year
                  (dateTimeValue.month == localNow.month &&
                          dateTimeValue.year != localNow.year) ||
                      //Different month, year is irrelevant
                      (dateTimeValue.month != localNow.month))
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
            children: [
               if (periodSelector != null) periodSelector!
            ],
          )
        ],
      ),
    );
  }
}
