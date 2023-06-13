import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPiechart extends StatefulWidget {
  const CategoryPiechart({super.key, required this.type});

  final TransactionType type;

  @override
  State<CategoryPiechart> createState() => _CategoryPiechartState();
}

class _CategoryPiechartState extends State<CategoryPiechart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CTransactionCubit, CTransactionState>(
      builder: (context, state) {
        return Center(
          child: Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            //If non of the piechart sections were touched
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex =
                                pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        }),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(color: Colors.red, value: 40, title: '40%'),
                          PieChartSectionData(color: Colors.blue, value: 30, title: '30%')
                        ]),
                  ),
                ),
              ),
              Text('test')
            ],
          ),
        );
      },
    );
  }
}
