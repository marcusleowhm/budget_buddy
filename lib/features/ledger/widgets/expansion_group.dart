import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/components/form/ledger_form.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //Whenever displaying the date time, use Local date time
        Text(dayFormatter.format(ledger.utcDateTime.toLocal()),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(monthNameFormatter.format(ledger.utcDateTime.toLocal())),
        Text(yearLongFormatter.format(ledger.utcDateTime.toLocal())),
      ],
    );
  }

  Widget? _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Text(
        ledger.account.isEmpty ? 'No account selected' : ledger.account,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget? _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            ledger.category.isEmpty ? 'No category selected' : ledger.category,
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
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            ledger.note.isEmpty ? '-' : ledger.note,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ), //Display the amount keyed in by the user
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor, //TODO move this color out of the component
      ),
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
              inputType: InputType.add,
              ledger: ledger,
              children: children,
            ),
          ],
        ),
      ),
    );
  }
}
