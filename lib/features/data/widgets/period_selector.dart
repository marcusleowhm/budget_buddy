import 'package:budget_buddy/features/constants/enum.dart';
import 'package:flutter/material.dart';

class PeriodSelector extends StatelessWidget {
  const PeriodSelector({super.key, required this.period, required this.setPeriod});

  final FilterPeriod period;
  final void Function(FilterPeriod) setPeriod;

  static const Map<FilterPeriod, String> map = {
    FilterPeriod.weekly: 'Weekly',
    FilterPeriod.monthly: 'Monthly',
    FilterPeriod.annual: 'Annual',
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FilterPeriod>(
      onSelected: setPeriod,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: FilterPeriod.weekly,
          child: Text('Weekly'),
        ),
        const PopupMenuItem(
          value: FilterPeriod.monthly,
          child: Text('Monthly'),
        ),
        const PopupMenuItem(
          value: FilterPeriod.annual,
          child: Text('Annual'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextButton.icon(
          style: const ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
          icon: Text(map[period]!),
          label: const Icon(Icons.arrow_drop_down_rounded),
          onPressed: null,
        ),
      ),
    );
  }
}
