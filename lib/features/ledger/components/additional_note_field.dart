import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:flutter/material.dart';

class AdditionalNoteField extends StatelessWidget {
  const AdditionalNoteField({
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
      focusNode: input.additionalNoteFocus,
      controller: input.additionalNoteController,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          suffixIcon: input.additionalNoteController.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    input.additionalNoteController.clear();
                    onTapTrailing();
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
          hintText: 'Additional Notes',
          helperText:
              'Write notes here for transactions that require more details'),
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      onTap: onTap,
    );
  }
}
