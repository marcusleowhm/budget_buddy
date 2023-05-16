import 'package:budget_buddy/features/ledger/components/type_picker.dart';
import 'package:budget_buddy/features/ledger/widgets/expansion_form_group.dart';
import 'package:budget_buddy/features/ledger/widgets/expansion_form_item.dart';
import 'package:flutter/material.dart';

class LedgerInput extends StatefulWidget {
  const LedgerInput({super.key});

  @override
  State<LedgerInput> createState() => _LedgerInputState();
}

class _LedgerInputState extends State<LedgerInput> {
  final TextEditingController _accountController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  //Declare all state variables here, to be managed by this widget
  TransactionType _transactionType = TransactionType.expense;
  void _changeType(Set<TransactionType> newType) {
    setState(() {
      _transactionType = newType.first;
    });
  }

  String _account = '';

  ExpansionFormItem _buildData() {
    return ExpansionFormItem(
      formEntry: FormEntry(
        //Information provided in this entry should be from the children widget
        leading: const Column(
          children: [Text('14'), Text('May'), Text('2023')],
        ),
        title: Text(_account),
        subtitle: const Text('example subtitle'),
        children: [
          //SegmentedButton for picking the type of transaction
          FormEntry(
            title: TypePicker(
              type: _transactionType,
              setType: _changeType,
            ),
          ),
          //Input for date
          //TODO refactor this to date picker
          const FormEntry(
            title: TextField(
              decoration: InputDecoration(labelText: 'Date'),
            ),
          ),
          //Input for account.s
          //TODO refactor this to a select widget
          FormEntry(
            title: TextFormField(
              controller: _accountController,
              decoration: const InputDecoration(labelText: 'Account'),
              onChanged: (value) {
                setState(() {
                  _account = value;
                });
              },
            ),
          ),
          const FormEntry(title: Text('Category')),
          const FormEntry(title: Text('Amount')),
          const FormEntry(title: Text('Additional Note')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionFormGroup(child: _buildData());
  }
}
