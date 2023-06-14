import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';

class MonthPicker extends StatelessWidget {
  const MonthPicker({
    super.key,
    required this.dateTimeValue,
    required this.localNow,
    required this.incrementMonth,
    required this.decrementMonth,
    required this.resetDate,
  });

  final DateTime dateTimeValue;
  final DateTime localNow;
  final VoidCallback incrementMonth;
  final VoidCallback decrementMonth;
  final VoidCallback resetDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: decrementMonth,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            constraints: const BoxConstraints(),
          ),
          SizedBox(
            width: 80,
            child: Text(dateMonthYearFormatter.format(dateTimeValue),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16)),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: incrementMonth,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
