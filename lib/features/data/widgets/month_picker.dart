import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';

class MonthPicker extends StatelessWidget {
  const MonthPicker({
    super.key,
    required this.currentLocalDate,
    required this.nowDate,
    required this.incrementMonth,
    required this.decrementMonth,
    required this.resetDate,
  });

  final DateTime currentLocalDate;
  final DateTime nowDate;
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
            child: Text(dateMonthYearFormatter.format(currentLocalDate),
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
              (currentLocalDate.month == nowDate.month &&
                      currentLocalDate.year != nowDate.year) ||
                  //Different month, year is irrelevant
                  (currentLocalDate.month != nowDate.month))
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
