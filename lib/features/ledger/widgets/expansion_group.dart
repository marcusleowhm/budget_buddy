import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/components/form/ledger_form.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpansionGroup extends StatelessWidget {
  const ExpansionGroup({
    super.key,
    required this.input,
    required this.children,
    required this.isExpanded,
    required this.onExpand,
  });

  final LedgerInput input;
  final List<Widget> children;
  final bool isExpanded;
  final void Function(bool value) onExpand;

  Widget? _buildLeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //Whenever displaying the date time, use Local date time
        Text(dayFormatter.format(input.data.utcDateTime.toLocal()),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(monthNameFormatter.format(input.data.utcDateTime.toLocal())),
        Text(yearLongFormatter.format(input.data.utcDateTime.toLocal())),
      ],
    );
  }

  Widget? _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Text(
        input.data.account.isEmpty ? 'No account selected' : input.data.account,
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
            input.data.category.isEmpty ? 'No category selected' : input.data.category,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: input.data.type == TransactionType.income
                  ? Colors.blue[700]!
                  : input.data.type == TransactionType.expense
                      ? Colors.red
                      : Colors.grey,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            input.data.note.isEmpty ? '-' : input.data.note,
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
                      color: input.data.type == TransactionType.income
                          ? Colors.blue[700]!
                          : input.data.type == TransactionType.expense
                              ? Colors.red
                              : Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  //The price to be displayed when expansion tile is collapsed
                  '${englishDisplayCurrencyFormatter.format(input.data.amount)} ${input.data.currency}',
                  style: TextStyle(
                    fontSize: 12,
                    color: input.data.type == TransactionType.income
                        ? Colors.blue[700]!
                        : input.data.type == TransactionType.expense
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
            Slidable.of(context)?.close();
          },
          key: PageStorageKey<String>(input.data.id),
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
              input: input,
              children: children,
            ),
          ],
        ),
      ),
    );
  }
}
