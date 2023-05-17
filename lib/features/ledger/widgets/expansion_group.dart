import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:flutter/material.dart';

class ExpansionGroup extends StatelessWidget {
  const ExpansionGroup({
    super.key,
    required this.ledger,
    required this.children,
  });

  final LedgerInput ledger;
  final List<Widget> children;

  Widget _buildChildrenTiles(Widget child) {
    return ListTile(
      title: child,
      key: PageStorageKey(child.key),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      color: Theme.of(context).canvasColor,
      child: ListTileTheme(
        horizontalTitleGap: 16.0,
        child: ExpansionTile(
          key: PageStorageKey<String>(ledger.id),
          maintainState: true,
          initiallyExpanded: true,
          leading: const Icon(Icons.abc),
          title: ListTile(
            title: Text(ledger.account),
            subtitle: Text(ledger.category),
          ),
          children: children.map(_buildChildrenTiles).toList(),
        ),
      ),
    );
  }
}
