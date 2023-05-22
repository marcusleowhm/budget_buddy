import 'package:budget_buddy/features/ledger/components/type_picker.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:flutter/material.dart';

class CategoryAccountToField extends StatelessWidget {
  const CategoryAccountToField({
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
      key: key,
      focusNode: input.categoryOrAccountToFocus,
      controller: input.categoryOrAccountToController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText:
            input.type == TransactionType.transfer ? 'Account To' : 'Category',
        suffixIcon: input.categoryOrAccountToController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  input.categoryOrAccountToController.clear();
                  onTapTrailing();
                },
                icon: const Icon(Icons.cancel_outlined),
              ),
      ),
      readOnly: true,
      showCursor: false,
      onTap: onTap
    );
  }
}
