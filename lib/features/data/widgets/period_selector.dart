import 'package:budget_buddy/features/constants/enum.dart';
import 'package:flutter/material.dart';

class PeriodSelector extends StatelessWidget {
  const PeriodSelector({super.key, required this.period, required this.setPeriod});

  final PeriodSelectorFilter period;
  final void Function(PeriodSelectorFilter) setPeriod;

  static const Map<PeriodSelectorFilter, String> map = {
    PeriodSelectorFilter.weekly: 'Weekly',
    PeriodSelectorFilter.monthly: 'Monthly',
    PeriodSelectorFilter.annual: 'Annual',
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PeriodSelectorFilter>(
      onSelected: setPeriod,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: PeriodSelectorFilter.weekly,
          child: Text('Weekly'),
        ),
        const PopupMenuItem(
          value: PeriodSelectorFilter.monthly,
          child: Text('Monthly'),
        ),
        const PopupMenuItem(
          value: PeriodSelectorFilter.annual,
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
