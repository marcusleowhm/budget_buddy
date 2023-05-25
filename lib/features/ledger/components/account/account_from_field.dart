import 'package:budget_buddy/features/ledger/components/type_picker.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:flutter/material.dart';

class AccountFromField extends StatelessWidget {
  const AccountFromField({
    super.key,
    required this.input,
    required this.onTapTrailing,
    required this.onTap,
  });

  final LedgerInput input;
  final VoidCallback onTapTrailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: input.accountOrAccountFromKey,
      focusNode: input.accountOrAccountFromFocus,
      controller: input.accountOrAccountFromController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText:
            input.type == TransactionType.transfer ? 'Account From' : 'Account',
        suffixIcon: input.accountOrAccountFromController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  input.accountOrAccountFromController.clear();
                  onTapTrailing();
                },
                icon: const Icon(Icons.cancel_outlined),
              ),
      ),
      readOnly: true,
      showCursor: false,
      onTap: onTap,
    );
  }
}
