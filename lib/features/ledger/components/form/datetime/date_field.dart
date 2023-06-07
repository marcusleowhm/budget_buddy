import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:flutter/material.dart';


class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.input,
    required this.controller,
    required this.showIcon,
    required this.onTapTrailing,
    required this.onTap,
  });

  final LedgerInput input;
  final TextEditingController controller;
  final bool showIcon;
  final VoidCallback onTapTrailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: input.dateTimeKey,
      focusNode: input.dateTimeFocus,
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Date',
        border: const OutlineInputBorder(),
        suffixIcon: showIcon
            ? IconButton(
                onPressed: onTapTrailing,
                icon: const Icon(Icons.refresh),
              )
            : null,
      ),
      readOnly: true,
      showCursor: false,
      onTap: onTap,
    );
  }
}
