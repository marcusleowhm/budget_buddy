import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/utilities/date_utilities.dart';
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

  final PeriodSelectorFilter? period;
  final Widget? periodSelector;

  Widget? _buildResetButton() {
    //First day of the week
    if (period == PeriodSelectorFilter.weekly &&
        (DateTime(
              dateTimeValue.year,
              dateTimeValue.month,
              dateTimeValue.day,
            ).subtract(Duration(days: dateTimeValue.weekday - 1)) !=
            DateTime(
              localNow.year,
              localNow.month,
              localNow.day,
            ).subtract(Duration(days: dateTimeValue.weekday - 1)))) {
      return IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: resetDate,
        // padding: const EdgeInsets.symmetric(
        //   horizontal: 10.0,
        //   vertical: 15.0,
        // ),
        constraints: const BoxConstraints(),
      );
    }

    //Monthly period
    //Same month but different year
    //Different month, year is irrelevant
    if ((period == PeriodSelectorFilter.monthly) &&
            (dateTimeValue.month == localNow.month &&
                dateTimeValue.year != localNow.year) ||
        (dateTimeValue.month != localNow.month)) {
      return IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: resetDate,
        // padding: const EdgeInsets.symmetric(
        //   horizontal: 10.0,
        //   vertical: 15.0,
        // ),
        constraints: const BoxConstraints(),
      );
    }

    //Yearly period
    //Different year
    if (period == PeriodSelectorFilter.annual &&
        dateTimeValue.year != localNow.year) {
      return IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: resetDate,
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 15.0,
        ),
        constraints: const BoxConstraints(),
      );
    }

    return null;
  }

  Widget? _buildDisplayText() {
    TextStyle style = const TextStyle(fontSize: 16);
    Widget? text;
    switch (period) {
      case PeriodSelectorFilter.weekly:
        text = Text(
          '${dateShortFormatter.format(dateTimeValue.subtract(Duration(days: dateTimeValue.weekday - 1)))} '
          'to \n'
          '${dateShortFormatter.format(
            dateTimeValue.add(
              Duration(
                days: DateTime.daysPerWeek - dateTimeValue.weekday,
              ),
            ),
          )}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        );

        break;
      case PeriodSelectorFilter.monthly:
        text = Text(
          dateMonthYearFormatter.format(dateTimeValue),
          style: style,
          textAlign: TextAlign.center,
        );
        break;
      case PeriodSelectorFilter.annual:
        text = Text(
          yearLongFormatter.format(dateTimeValue),
          style: style,
          textAlign: TextAlign.center,
        );
        break;
      default:
        break;
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    Widget? resetButton = _buildResetButton();
    Widget? displayedText = _buildDisplayText();
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
                  horizontal: 10.0,
                  vertical: 15.0,
                ),
                constraints: const BoxConstraints(),
              ),
              //Date to display
              SizedBox(
                width: period == PeriodSelectorFilter.weekly ? 100 : 80,
                child: displayedText,
              ),
              //Right chevron button
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: incrementPeriod,
                padding: const EdgeInsets.only(
                  left: 10.0,
                  top: 15.0,
                  bottom: 15.0,
                ),
                constraints: const BoxConstraints(),
              ),
              if (resetButton != null) resetButton
            ],
          ),
          //Show periodSelector if it was passed in
          Row(
            children: [if (periodSelector != null) periodSelector!],
          )
        ],
      ),
    );
  }
}
