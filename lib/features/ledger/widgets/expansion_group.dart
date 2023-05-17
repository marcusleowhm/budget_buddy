import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/type_picker.dart';

class ExpansionGroup extends StatelessWidget {
  const ExpansionGroup({
    super.key,
    required this.ledger,
    required this.children,
    required this.isExpanded,
    required this.onExpand,
  });

  final LedgerInput ledger;
  final List<Widget> children;
  final bool isExpanded;
  final void Function(bool value) onExpand;

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

  Widget _buildTitle() {
    return Text(
      ledger.account,
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildSubtitle() {
    NumberFormat decimalFormatter = NumberFormat('#,###,###.00');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Category to display beside the price
            Text(
              ledger.categoryOrTo,
              style: TextStyle(
                fontSize: 14,
                color: ledger.type == TransactionType.income
                    ? Colors.blue[700]!
                    : ledger.type == TransactionType.expense
                        ? Colors.red
                        : Colors.grey,
              ),
            ),
            Text(
              ledger.note,
              style: TextStyle(
                fontSize: 14,
                color: ledger.type == TransactionType.income
                    ? Colors.blue[700]!
                    : ledger.type == TransactionType.expense
                        ? Colors.red
                        : Colors.grey,
              ),
            ),
          ],
        ),

        //Display the amount keyed in by the user
        if (!isExpanded && ledger.amount != 0.0)
          Container(
            padding: const EdgeInsets.all(5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
                  color: ledger.type == TransactionType.income
                      ? Colors.blue[700]!
                      : ledger.type == TransactionType.expense
                          ? Colors.red
                          : Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(
              //The price to be displayed when expansion tile is collapsed
              decimalFormatter.format(ledger.amount),
              style: TextStyle(
                fontSize: 12,
                color: ledger.type == TransactionType.income
                    ? Colors.blue[700]!
                    : ledger.type == TransactionType.expense
                        ? Colors.red
                        : Colors.grey,
              ),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: ListTileTheme(
        horizontalTitleGap: 0.0,
        child: ExpansionTile(
          onExpansionChanged: (value) {
            onExpand(value);
          },
          key: PageStorageKey<String>(ledger.id),
          maintainState: true,
          initiallyExpanded: true,
          leading: const Icon(Icons.abc),
          title: isExpanded
              ? const Text('')
              : ListTile(
                  //TODO maybe implement a long tap event to reorder list
                  // onLongPress: () => print('long tapped!'),
                  title: _buildTitle(),
                  subtitle: _buildSubtitle(),
                ),
          children: children.map(_buildChildrenTiles).toList(),
        ),
      ),
    );
  }
}
