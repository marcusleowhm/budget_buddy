import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/widgets/widget_shaker.dart';
import 'package:flutter/material.dart';

class AccountField extends StatelessWidget {
  const AccountField({
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
  final Icon trailingIcon;
  final bool showIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ShakeError(
      key: input.accountShakerKey,
      duration: const Duration(milliseconds: 600),
      shakeCount: 4,
      shakeOffset: 10,
      child: TextFormField(
        key: input.accountKey,
        controller: controller,
        focusNode: input.accountFocus,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select account';
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: input.data.type == TransactionType.transfer
              ? 'Account From'
              : 'Account',
          suffixIcon: showIcon
              ? IconButton(
                  onPressed: () {
                    controller.clear();
                    onTapTrailing();
                  },
                  icon: trailingIcon)
              : null,
        ),
        readOnly: true,
        showCursor: false,
        onTap: onTap,
      ),
    );
  }
}
