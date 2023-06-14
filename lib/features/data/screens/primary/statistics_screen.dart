import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/committed_transaction_statistics.dart';
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

  @override
  void initState() {
    setState(
      () =>
          dateTimeValue = DateTime(localNow.year, localNow.month, localNow.day),
    );
    super.initState();
  }

  void incrementMonth() {
    setState(() => dateTimeValue = DateTime(
        dateTimeValue.year, dateTimeValue.month + 1, dateTimeValue.day));
  }

  void decrementMonth() {
    setState(() => dateTimeValue = DateTime(
        dateTimeValue.year, dateTimeValue.month - 1, dateTimeValue.day));
  }

  void resetDate() {
    setState(() => dateTimeValue = localNow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${titles[MainRoutes.statistics]}')),
      backgroundColor: Colors.grey[200], //TODO change this color
      body: CommittedTransactionStatistics(
        dateTimeValue: dateTimeValue,
        localNow: localNow,
        incrementMonth: incrementMonth,
        decrementMonth: decrementMonth,
        resetDate: resetDate,
      ),
    );
  }
}
