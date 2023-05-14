import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LedgerScreen extends StatelessWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${titles[MainRoutes.ledger]}')),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => context.go(
              '/${routes[MainRoutes.ledger]}/${routes[SubRoutes.addledger]}'),
        ));
  }
}
