import 'package:budget_buddy/features/ledger/components/inputs/type_picker.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/widgets/widget_shaker.dart';
import 'package:flutter/material.dart';

class CategoryAccountToField extends StatelessWidget {
  const CategoryAccountToField({
    super.key,
    required this.input,
    required this.type,
    required this.controller,
    required this.onTapTrailing,
    required this.onTap,
  });

  final LedgerInput input;
  final TransactionType type;
  final TextEditingController controller;
  final VoidCallback onTapTrailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ShakeError(
      key: input.categoryShakerKey,
      duration: const Duration(milliseconds: 600),
      shakeCount: 4,
      shakeOffset: 10,
      child: TextFormField(
        key: input.categoryKey,
        controller: controller,
        focusNode: input.categoryFocus,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select category';
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: type == TransactionType.transfer
              ? 'Account To'
              : 'Category',
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    controller.clear();
                    onTapTrailing();
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
        ),
        readOnly: true,
        showCursor: false,
        onTap: onTap,
      ),
    );
  }
}
