import 'package:flutter/material.dart';

import '../../../utilities/date_formatter.dart';

class CTransactionList extends StatelessWidget {
  CTransactionList({
    super.key,
    required this.currentDate,
    required this.nowDate,
    required this.incrementMonth,
    required this.decrementMonth,
    required this.resetDate,
  });

  final DateTime currentDate;
  final DateTime nowDate;

  //Scroll controller for scrolling down
  final ScrollController _scrollController = ScrollController();
  final VoidCallback incrementMonth;
  final VoidCallback decrementMonth;
  final VoidCallback resetDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: Theme.of(context).cardColor,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: decrementMonth,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                constraints: const BoxConstraints(),
              ),
              SizedBox(
                width: 80,
                child: Text(dateMonthYearFormatter.format(currentDate),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16)),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: incrementMonth,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                constraints: const BoxConstraints(),
              ),
              if (
                  //Same month but different year
                  (currentDate.month == nowDate.month &&
                          currentDate.year != nowDate.year) ||
                      //Different month, year is irrelevant
                      (currentDate.month != nowDate.month))
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: resetDate,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
                  constraints: const BoxConstraints(),
                )
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return Card(child: Text(index.toString()));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
