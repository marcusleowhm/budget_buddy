import 'package:budget_buddy/features/data/components/statistics/breakdown/category_breakdown.dart';
import 'package:budget_buddy/features/data/widgets/month_picker.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommittedTransactionStatistics extends StatelessWidget {
  CommittedTransactionStatistics({
    super.key,
    required this.dateTimeValue,
    required this.localNow,
    required this.incrementMonth,
    required this.decrementMonth,
    required this.resetDate,
  });

  final DateTime dateTimeValue;
  final DateTime localNow;

  //Scroll controller for scrolling down
  final ScrollController _scrollController = ScrollController();
  final VoidCallback incrementMonth;
  final VoidCallback decrementMonth;
  final VoidCallback resetDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MonthPicker(
          dateTimeValue: dateTimeValue,
          localNow: localNow,
          incrementMonth: incrementMonth,
          decrementMonth: decrementMonth,
          resetDate: resetDate,
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: BlocBuilder<CTransactionCubit, CTransactionState>(
              builder: (context, state) {
                return Column(
                  children: [
                    CategoryBreakdown(dateTimeValue: dateTimeValue,),
                    //TODO Other analytics widgets
                    Card(
                      child: Row(children: [Text('2')]),
                    ),
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
