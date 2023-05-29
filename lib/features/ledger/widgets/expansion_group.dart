import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/widgets/ledger_form.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';

import '../components/inputs/type_picker.dart';

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

  Widget? _buildLeading() {
    if (isExpanded) {
      return null;
    } else {
      //Check the fields directly because form state will be null when undoing dismiss
      if (ledger.accountOrAccountFrom.isEmpty ||
          ledger.categoryOrAccountTo.isEmpty) {
        return null;
      }

      //Else if the form is valid
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //Whenever displaying the date time, use Local date time
          Text(dayFormatter.format(ledger.utcDateTime.toLocal()),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(monthNameFormatter.format(ledger.utcDateTime.toLocal())),
          Text(yearLongFormatter.format(ledger.utcDateTime.toLocal())),
        ],
      );
    }
  }

  Widget? _buildTitle() {
    if (isExpanded) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_rounded),
          SizedBox(width: 10),
          Text('Click to collapse', style: TextStyle()),
        ],
      );
    } else {
      //Check the fields directly because form state will be null when undoing dismiss
      if (ledger.accountOrAccountFrom.isEmpty ||
          ledger.categoryOrAccountTo.isEmpty) {
        return const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.red,
            ),
            Text(
              'Issues detected with inputs',
              style: TextStyle(color: Colors.red),
            )
          ],
        );
      }
    }
    return Text(
      ledger.accountOrAccountFrom,
      style: const TextStyle(fontSize: 14),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget? _buildSubtitle() {
    if (isExpanded) {
      return null;
    } else {
      //Check the fields directly because form state will be null when undoing dismiss
      if (ledger.accountOrAccountFrom.isEmpty ||
          ledger.categoryOrAccountTo.isEmpty) {
        return null;
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ledger.categoryOrAccountTo,
                  overflow: TextOverflow.ellipsis,
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
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
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
                '${englishDisplayCurrencyFormatter.format(ledger.amount)} ${ledger.currency}',
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(
          //Edit this to change the border radius for the ExpansionTile
          Radius.circular(0),
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
          leading: _buildLeading(),
          title: ListTile(
            title: _buildTitle(),
            subtitle: _buildSubtitle(),
          ),
          children: [
            LedgerForm(
              ledger: ledger,
              children: children,
            ),
          ],
        ),
      ),
    );
  }
}
