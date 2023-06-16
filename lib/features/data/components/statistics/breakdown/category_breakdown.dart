import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/statistics/breakdown/category_breakdown_page.dart';
import 'package:flutter/material.dart';

class CategoryBreakdown extends StatefulWidget {
  const CategoryBreakdown({super.key, required this.dateTimeValue});

  final DateTime dateTimeValue;

  @override
  State<CategoryBreakdown> createState() => _CategoryBreakdownState();
}

class _CategoryBreakdownState extends State<CategoryBreakdown>
    with TickerProviderStateMixin {
  int selectedIndex = 1;
  late TabController _tabController;

  void initController() {
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: selectedIndex);
    _tabController.addListener(() {
      selectedIndex = _tabController.index;
      setState(() => _tabController.index);
    });
  }

  static const List<Widget> _tabs = [
    Tab(
      child: Text('Income', style: TextStyle(color: Colors.black)),
    ),
    Tab(
      child: Text('Expense', style: TextStyle(color: Colors.black)),
    ),
  ];

  late List<Widget> _pages;
  void createPages() {
    _pages = [
      CategoryBreakdownPage(
        type: TransactionType.income,
        dateTimeValue: widget.dateTimeValue,
      ),
      CategoryBreakdownPage(
        type: TransactionType.expense,
        dateTimeValue: widget.dateTimeValue,
      ),
    ];
  }

  @override
  void initState() {
    initController();
    createPages();
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
              TabBar(
                controller: _tabController,
                tabs: _tabs,
              ),
              Builder(
                builder: (context) {
                  return _pages[selectedIndex];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
