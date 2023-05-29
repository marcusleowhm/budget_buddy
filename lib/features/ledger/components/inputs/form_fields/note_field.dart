import 'package:flutter/material.dart';

import '../../../model/ledger_input.dart';

class NoteField extends StatelessWidget {
  const NoteField({
    super.key,
    required this.input,
    required this.controller,
    required this.onTapTrailing,
    required this.onTap,
    required this.onEditingComplete,
  });

  final LedgerInput input;
  final TextEditingController controller;
  final VoidCallback onTapTrailing;
  final VoidCallback onTap;
  final VoidCallback onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: input.noteKey,
      focusNode: input.noteFocus,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Note',
        suffixIcon: input.note.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  controller.clear();
                  onTapTrailing();
                },
                icon: const Icon(Icons.cancel_outlined),
              ),
      ),
      onTap: onTap,
      onEditingComplete: onEditingComplete,
    );
  }
}
