import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/committed_transaction_statistics.dart';
import 'package:budget_buddy/features/data/widgets/period_selector.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime localNow = DateTime.now();
  late DateTime dateTimeValue;
  FilterPeriod period = FilterPeriod.monthly;

  @override
  void initState() {
    setState(
      () =>
          dateTimeValue = DateTime(localNow.year, localNow.month, localNow.day),
    );
    super.initState();
  }

  void incrementPeriod() {
    if (period == FilterPeriod.monthly) {
      setState(() => dateTimeValue = DateTime(
          dateTimeValue.year, dateTimeValue.month + 1, dateTimeValue.day));
    }

    if (period == FilterPeriod.annual) {
      setState(() => dateTimeValue = DateTime(
          dateTimeValue.year + 1, dateTimeValue.month, dateTimeValue.day));
    }
  }

  void decrementPeriod() {
    if (period == FilterPeriod.monthly) {
      setState(() => dateTimeValue = DateTime(
          dateTimeValue.year, dateTimeValue.month - 1, dateTimeValue.day));
    }

    if (period == FilterPeriod.annual) {
      setState(() => dateTimeValue = DateTime(
          dateTimeValue.year - 1, dateTimeValue.month, dateTimeValue.day));
    }
  }

  void resetDate() {
    setState(() => dateTimeValue = localNow);
  }

  void setPeriod(FilterPeriod newValue) {
    setState(() => period = newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${titles[MainRoutes.statistics]}')),
      backgroundColor: Colors.grey[200], //TODO change this color
      body: CommittedTransactionStatistics(
        dateTimeValue: dateTimeValue,
        localNow: localNow,
        incrementPeriod: incrementPeriod,
        decrementPeriod: decrementPeriod,
        resetDate: resetDate,
        period: period,
        periodSelector: PeriodSelector(
          period: period,
          setPeriod: setPeriod,
        ),
      ),
    );
  }
}
