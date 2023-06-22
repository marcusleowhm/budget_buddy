import 'package:budget_buddy/features/configuration/cubit/account_cubit.dart';
import 'package:budget_buddy/features/data/model/account.dart';
import 'package:budget_buddy/features/data/model/account_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_grid_view.dart';
import 'account_list_view.dart';

class AccountPicker extends StatefulWidget {
  const AccountPicker({super.key, required this.onPressed});

  final void Function(String? selectedAccount, String? selectedSubAccount)
      onPressed;

  @override
  State<AccountPicker> createState() => _AccountPickerState();
}

class _AccountPickerState extends State<AccountPicker> {
  bool isGridView = true;
  int selectedGroupIndex = 0;

  Map<AccountGroup, List<Account>> mapAccount(AccountState state) {
    Map<AccountGroup, List<Account>> mappedAccount = {};
    for (Account account in state.accounts) {
      mappedAccount.putIfAbsent(account.group, () => []);
      mappedAccount[account.group]?.add(account);
    }
    return mappedAccount;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        Map<AccountGroup, List<Account>> mappedAccount = mapAccount(state);
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
                          onPressed: () => widget.onPressed(null, null),
                          icon: const Icon(Icons.cancel_rounded),
                          color: Theme.of(context).canvasColor,
                        ),
                        IconButton(
                          onPressed: () =>
                              setState(() => isGridView = !isGridView),
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
                          mappedAccount: mappedAccount,
                          onItemPressed: widget.onPressed,
                        )
                      : AccountListView(
                          selectedGroupIndex: selectedGroupIndex,
                          mappedAccount: mappedAccount,
                          selectGroupIndex: (index) {
                            setState(() => selectedGroupIndex = index);
                          },
                          onSelectAccount: widget.onPressed,
                        ),
                ],
              ),
            ));
      },
    );
  }
}
