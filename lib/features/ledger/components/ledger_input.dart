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

  //Declare all state variables here, to be managed by this widget
  TransactionType transactionType = TransactionType.expense;
  void _changeType(Set<TransactionType> newType) {
    setState(() {
      transactionType = newType.first;
    });
  }

  ExpansionFormItem _buildData() {
    return ExpansionFormItem(
      formEntry: FormEntry(
        leading: const Column(
          children: [Text('14'), Text('May'), Text('2023')],
        ),
        title: const Text('Example Title'),
        subtitle: const Text('example subtitle'),
        children: [
          //SegmentedButton for picking the type of transaction
          FormEntry(
            title: TypePicker(type: transactionType, setType: _changeType),
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
              title: TextField(
            controller: _accountController,
            decoration: const InputDecoration(labelText: 'Account'),
          )),
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
