import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/piechart_breakdown/piechart_page.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PiechartRoot extends StatefulWidget {
  const PiechartRoot({super.key, required this.dateTimeValue});

  final DateTime dateTimeValue;

  @override
  State<PiechartRoot> createState() => _PiechartRootState();
}

class _PiechartRootState extends State<PiechartRoot>
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

  List<Widget> createPages() {
    return [
      PiechartPage(
        type: TransactionType.income,
        dateTimeValue: widget.dateTimeValue,
      ),
      PiechartPage(
        type: TransactionType.expense,
        dateTimeValue: widget.dateTimeValue,
      ),
    ];
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
              const Text(
                'Monthly Breakdown by Category',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TabBar(
                controller: _tabController,
                tabs: _tabs,
              ),
              BlocBuilder<CTransactionCubit, CTransactionState>(
                builder: (context, state) {
                  return Builder(
                    builder: (context) {
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
