import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/c_transaction_statistics.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime utcNow = DateTime.now();
  late DateTime currentLocalDate;

  @override
  void initState() {
    setState(() => currentLocalDate =
        DateTime(utcNow.year, utcNow.month, utcNow.day).toLocal());
    super.initState();
  }

  void incrementMonth() {
    setState(() => currentLocalDate = DateTime(currentLocalDate.year,
        currentLocalDate.month + 1, currentLocalDate.day));
  }

  void decrementMonth() {
    setState(() => currentLocalDate = DateTime(currentLocalDate.year,
        currentLocalDate.month - 1, currentLocalDate.day));
  }

  void resetDate() {
    setState(() => currentLocalDate = utcNow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${titles[MainRoutes.statistics]}')),
      backgroundColor: Colors.grey[200], //TODO change this color
      body: CTransactionStatistics(
        currentLocalDate: currentLocalDate,
        nowDate: utcNow,
        incrementMonth: incrementMonth,
        decrementMonth: decrementMonth,
        resetDate: resetDate,
      ),
    );
  }
}
