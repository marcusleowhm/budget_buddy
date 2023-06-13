import 'package:budget_buddy/features/data/widgets/month_picker.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommittedTransactionStatistics extends StatelessWidget {
  CommittedTransactionStatistics({
    super.key,
    required this.currentLocalDate,
    required this.nowDate,
    required this.incrementMonth,
    required this.decrementMonth,
    required this.resetDate,
  });

  final DateTime currentLocalDate;
  final DateTime nowDate;

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
          currentLocalDate: currentLocalDate,
          nowDate: nowDate,
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
                    Container(child: Card(child: Text('1'))),
                    Container(child: Card(child: Text('2'))),
                    Container(child: Card(child: Text('3'))),
                    Container(child: Card(child: Text('4'))),
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
