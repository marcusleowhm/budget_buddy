import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/barchart_breakdown/fiveyear_barchart.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BarchartRoot extends StatefulWidget {
  const BarchartRoot({super.key, required this.dateTimeValue});

  final DateTime dateTimeValue;

  @override
  State<BarchartRoot> createState() => _BarchartRootState();
}

class _BarchartRootState extends State<BarchartRoot>
    with TickerProviderStateMixin {
  int selectedIndex = 1;
  late TabController _tabController;

  static const List<Widget> _tabs = [
    Tab(
      child: Text('Income', style: TextStyle(color: Colors.black)),
    ),
    Tab(
      child: Text('Expense', style: TextStyle(color: Colors.black)),
    ),
  ];

  void initController() {
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: selectedIndex);
    _tabController.addListener(() {
      selectedIndex = _tabController.index;
      setState(() => _tabController.index);
    });
  }

  @override
  void initState() {
    initController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> createPages() {
    return [
      FiveYearBarchart(
        type: TransactionType.income,
        dateTimeValue: widget.dateTimeValue,
      ),
      FiveYearBarchart(
        type: TransactionType.expense,
        dateTimeValue: widget.dateTimeValue,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                controller: _tabController,
                tabs: _tabs,
              ),
              BlocBuilder<CTransactionCubit, CTransactionState>(
                builder: (context, state) {
                  return Builder(
                    builder: (context) {
                      // return createPages()[selectedIndex];
                      return createPages()[selectedIndex];
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}