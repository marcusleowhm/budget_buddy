import 'package:flutter/material.dart';

import '../../../../../utilities/date_formatter.dart';
import '../../../model/ledger_input.dart';

class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.input,
    required this.controller,
    required this.now,
    required this.onTapTrailing,
    required this.onTap,
  });

  final LedgerInput input;
  final TextEditingController controller;
  final DateTime now;
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
        suffixIcon: dateLongFormatter.format(
                  DateTime(
                    input.utcDateTime.toLocal().year,
                    input.utcDateTime.toLocal().month,
                    input.utcDateTime.toLocal().day,
                  ),
                ) !=
                dateLongFormatter.format(
                  DateTime(
                    now.year,
                    now.month,
                    now.day,
                  ),
                )
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
