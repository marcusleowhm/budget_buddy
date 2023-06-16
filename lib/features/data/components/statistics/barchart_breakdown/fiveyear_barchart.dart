import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FiveYearBarchart extends StatefulWidget {
  const FiveYearBarchart(
      {super.key, required this.type, required this.dateTimeValue});

  final TransactionType type;
  final DateTime dateTimeValue;

  @override
  State<FiveYearBarchart> createState() => _FiveYearBarchartState();
}

class _FiveYearBarchartState extends State<FiveYearBarchart> {
  int selectedIndex = -1;

  Map<int, List<Map<String, double>>> formatData(CTransactionState state) {
    Map<int, List<Map<String, double>>> formattedData = {};
    for (int i = widget.dateTimeValue.year - 4;
        i <= widget.dateTimeValue.year;
        i++) {
      List<Map<String, double>> yearlyData = [];
      for (TransactionData data in state.committedEntries) {
        DateTime dataLocalDateTime = data.utcDateTime.toLocal();
        if (dataLocalDateTime.year == i && data.type == widget.type) {
          switch (data.type) {
            case TransactionType.income:
              yearlyData.add({data.incomeCategory: data.amount});
              break;
            case TransactionType.expense:
              yearlyData.add({data.expenseCategory: data.amount});
              break;
            default:
              //Do nothing if it's transfer
              break;
          }
        }
        //Sort the yearly data in ascending order
        yearlyData.sort((a, b) => a.values.first.compareTo(b.values.first));
      }
      //Add into the main formatted data
      formattedData.putIfAbsent(i, () => yearlyData);
    }
    return formattedData;
  }

  BarChartGroupData generateGroup(int year, List<Map<String, double>> values) {
    //Check if the smallest value is positive or negative
    //The list being passed in is a list of map with only 1 entry, hence, we use first to access the amount
    bool isTop = values.first.values.first > 0;
    return BarChartGroupData(x: 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CTransactionCubit, CTransactionState>(
      builder: (context, state) {
        Map<int, List<Map<String, double>>> formattedData = formatData(state);
        return AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(handleBuiltInTouches: false),
              ),
            ),
          ),
        );
      },
    );
  }
}