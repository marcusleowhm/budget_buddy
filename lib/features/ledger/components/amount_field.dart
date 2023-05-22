import 'package:flutter/material.dart';

import '../../../mock/account.dart';
import '../model/ledger_input.dart';

class AmountField extends StatelessWidget {
  const AmountField({
    super.key,
    required this.input,
    required this.onCurrencyChange,
    required this.onTapTrailing,
    required this.onTap,
  });

  final LedgerInput input;
  final void Function(String?) onCurrencyChange;
  final VoidCallback onTapTrailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton(
          value: input.currency,
          items: currencies
              .map(
                (currency) => DropdownMenuItem(
                  value: currency,
                  child: Text(currency, style: const TextStyle(fontSize: 12)),
                ),
              )
              .toList(),
          onChanged: (String? selection) {
            onCurrencyChange(selection);
          },
        ),
        Expanded(
          child: TextField(
            key: key,
            focusNode: input.amountFocus,
            controller: input.amountController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Amount',
              suffixIcon: input.amountController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        input.amountController.clear();
                        onTapTrailing();
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    ),
            ),
            readOnly: true,
            showCursor: false,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
