import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';

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

  Widget? _buildLeading() {
    return isExpanded
        ? null
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //Whenever displaying the date time, use Local date time
              Text(dayFormatter.format(ledger.dateTime.toLocal())),
              Text(monthNameFormatter.format(ledger.dateTime.toLocal())),
              Text(yearLongFormatter.format(ledger.dateTime.toLocal())),
            ],
          );
  }

  Widget _buildTitle() {
    return isExpanded
        ? const Icon(Icons.library_books_rounded)
        : Text(
            ledger.accountOrAccountFrom,
            style: const TextStyle(fontSize: 14),
          );
  }

  Widget? _buildSubtitle() {
    return isExpanded
        ? null
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ledger.categoryOrAccountTo,
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
                    currencyFormatter.format(ledger.amount),
                    style: TextStyle(
                      fontSize: 12,
                      color: ledger.type == TransactionType.income
                          ? Colors.blue[700]!
                          : ledger.type == TransactionType.expense
                              ? Colors.red
                              : Colors.grey,
                    ),
                  ),
                ),
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
          leading: _buildLeading(), //TODO to add dates here
          title: ListTile(
            title: _buildTitle(),
            subtitle: _buildSubtitle(),
          ),
          children: children.map(_buildChildrenTiles).toList(),
        ),
      ),
    );
  }
}
