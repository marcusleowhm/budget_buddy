import 'package:flutter/material.dart';

import '../../../model/ledger_input.dart';

class NoteField extends StatelessWidget {
  const NoteField({
    super.key,
    required this.input,
    required this.controller,
    required this.onTapTrailing,
    required this.onTap,
    required this.showIcon,
    required this.trailingIcon,
    required this.onEditingComplete,
  });

  final LedgerInput input;
  final TextEditingController controller;
  final VoidCallback onTapTrailing;
  final VoidCallback onTap;
  final bool showIcon;
  final Icon trailingIcon;
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
        suffixIcon: showIcon
            ? IconButton(
                onPressed: () {
                  controller.clear();
                  onTapTrailing();
                },
                icon: trailingIcon,
              )
            : null,
      ),
      onTap: onTap,
      onEditingComplete: onEditingComplete,
    );
  }
}
