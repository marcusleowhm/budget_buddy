import 'package:flutter/material.dart';

class RecentTransactionsList extends StatefulWidget {
  const RecentTransactionsList({super.key});

  @override
  State<RecentTransactionsList> createState() => _RecentTransactionsListState();
}

class _RecentTransactionsListState extends State<RecentTransactionsList> {
  String sortCriteria = '';

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
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    TextButton.icon(
                      icon: const Text('Sort by'),
                      label: const Icon(Icons.arrow_drop_down_rounded),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const Divider(),
              const ListTile(title: Text('test')),
              const ListTile(title: Text('test')),
            ],
          ),
        ),
      ),
    );
  }
}
