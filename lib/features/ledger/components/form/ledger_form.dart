import 'package:flutter/material.dart';

import '../../model/ledger_input.dart';

class LedgerForm extends StatelessWidget {
  const LedgerForm({
    super.key,
    required this.ledger,
    required this.children,
  });

  final LedgerInput ledger;
  final List<Widget> children;

  Widget _buildChildrenTiles(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: child is Divider
          ? Divider(
              key: PageStorageKey(child.key),
              height: 0,
              thickness: 1,
            )
          : ListTile(
              title: child,
              key: PageStorageKey(child.key),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: ledger.formKey,
      child: Column(
        children: [
          ...children.map(_buildChildrenTiles).toList(),
        ],
      ),
    );
  }
}
