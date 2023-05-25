import 'package:budget_buddy/features/ledger/components/account/account_grid_view.dart';
import 'package:budget_buddy/features/ledger/components/account/account_list_view.dart';
import 'package:flutter/material.dart';

import '../../../../mock/account.dart';

class AccountPicker extends StatefulWidget {
  const AccountPicker({super.key, required this.onPressed});

  final void Function(String? selectedAccount) onPressed;

  @override
  State<AccountPicker> createState() => _AccountPickerState();
}

class _AccountPickerState extends State<AccountPicker> {
  bool isGridView = true;
  int selectedGroupIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> accounts = [];
    accountGroups.forEach((key, value) => accounts += value);

    return FractionallySizedBox(
        //This widget keeps the height of the bottom sheet be at 40% of screen
        heightFactor: 0.4,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(
              width: 0.5,
              color: Theme.of(context).dividerColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => widget.onPressed(null),
                      icon: const Icon(Icons.cancel_rounded),
                      color: Theme.of(context).canvasColor,
                    ),
                    IconButton(
                      onPressed: () => setState(() => isGridView = !isGridView),
                      icon: isGridView
                          ? const Icon(Icons.list)
                          : const Icon(Icons.window_rounded),
                      color: Theme.of(context).canvasColor,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.mode_edit_outline_outlined),
                      color: Theme.of(context).canvasColor,
                    ),
                  ],
                ),
              ),
              isGridView
                  ? AccountGridView(
                      accounts: accounts,
                      onItemPressed: widget.onPressed,
                    )
                  : AccountListView(
                      selectedGroupIndex: selectedGroupIndex,
                      accountGroups: accountGroups,
                      selectGroupIndex: (index) {
                        setState(() => selectedGroupIndex = index);
                      },
                      onSelectAccount: widget.onPressed,
                    ),
            ],
          ),
        ));
  }
}
