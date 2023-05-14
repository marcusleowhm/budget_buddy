import 'package:budget_buddy/features/ledger/screens/secondary/add_ledger_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LedgerScreen extends StatelessWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Ledger')),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => context.go('/ledger/add'),
        ));
  }
}
