import 'package:budget_buddy/features/constants/enum.dart';
import 'package:flutter/material.dart';

class FiveYearBarchart extends StatefulWidget {
  const FiveYearBarchart({super.key, required this.type, required this.dateTimeValue});

  final TransactionType type;
  final DateTime dateTimeValue;

  @override
  State<FiveYearBarchart> createState() => _FiveYearBarchartState();
}

class _FiveYearBarchartState extends State<FiveYearBarchart> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}