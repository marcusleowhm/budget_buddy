import 'package:flutter/material.dart';

import '../../../../configuration/model/keyset.dart';
import '../../../model/ledger_input.dart';

class AmountField extends StatelessWidget {
  const AmountField({
    super.key,
    required this.input,
    required this.controller,
    required this.onCurrencyChange,
    required this.onTapTrailing,
    required this.showIcon,
    required this.trailingIcon,
    required this.onTap,
  });

  final LedgerInput input;
  final TextEditingController controller;
  final void Function(String?) onCurrencyChange;
  final VoidCallback onTapTrailing;
  final bool showIcon;
  final Icon trailingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 55,
          width: 100,
          child: InputDecorator(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              labelText: 'Currency',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: input.data.currency,
                items: currencyKeys
                    .keys //TODO change this mapping to another configuration when ready
                    .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(currency,
                            style: const TextStyle(fontSize: 16))))
                    .toList(),
                onChanged: (String? selection) {
                  onCurrencyChange(selection);
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: TextField(
            key: input.amountKey,
            focusNode: input.amountFocus,
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Amount',
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
            readOnly: true,
            showCursor: false,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
