import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:flutter/material.dart';

class AdditionalNoteField extends StatelessWidget {
  const AdditionalNoteField({
    super.key,
    required this.input,
    required this.controller,
    required this.onTapTrailing,
    required this.showIcon,
    required this.trailingIcon,
    required this.onTap,
  });

  final LedgerInput input;
  final TextEditingController controller;
  final VoidCallback onTapTrailing;
  final bool showIcon;
  final Icon trailingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: input.additionalNoteKey,
      focusNode: input.additionalNoteFocus,
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          suffixIcon: showIcon
              ? IconButton(
                  onPressed: () {
                    controller.clear();
                    onTapTrailing();
                  },
                  icon: trailingIcon,
                )
              : null,
          hintText: 'Additional Notes',
          helperText:
              'Write notes here for transactions that require more details'),
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      onTap: onTap,
    );
  }
}
