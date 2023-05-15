import 'package:budget_buddy/features/ledger/widgets/expansion_form_group.dart';
import 'package:budget_buddy/features/ledger/widgets/expansion_form_item.dart';
import 'package:flutter/material.dart';

class LedgerInput extends StatefulWidget {
  const LedgerInput({super.key, required this.expansionTileController});

  //To be passed into the first FormEntry
  final ExpansionTileController expansionTileController;

  @override
  State<LedgerInput> createState() => _LedgerInputState();
}

class _LedgerInputState extends State<LedgerInput> {
  final TextEditingController _accountController = TextEditingController();

  List<ExpansionFormItem> _buildData() {
    return <ExpansionFormItem>[
      ExpansionFormItem(
        formEntry: FormEntry(
          expansionTileController: widget.expansionTileController,
          leading: const Column(
            children: [
              Text('14'),
              Text('May'),
              Text('2023'),
            ],
          ),
          title: Text(widget.key.toString()),
          subtitle: const Text('example subtitle'),
          children: [
            const FormEntry(
              title: TextField(
                decoration: InputDecoration(labelText: 'Date'),
              ),
            ),
            FormEntry(
                title: TextField(
              controller: _accountController,
              decoration: const InputDecoration(labelText: 'Account'),
            )),
            const FormEntry(title: Text('Category')),
            const FormEntry(title: Text('Amount')),
            const FormEntry(title: Text('Additional Note')),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionFormGroup(children: _buildData());
  }
}
