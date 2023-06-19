import 'package:budget_buddy/features/configuration/widgets/menu_group.dart';
import 'package:budget_buddy/features/configuration/widgets/menu_group_item.dart';
import 'package:budget_buddy/features/data/cubit/account_cubit.dart';
import 'package:budget_buddy/features/data/model/account.dart';
import 'package:budget_buddy/features/data/model/account_group.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountList extends StatelessWidget {
  const AccountList({super.key});

  Map<AccountGroup, List<Account>> formatAccountGroups(AccountState state) {
    Map<AccountGroup, List<Account>> formattedData = {};
    for (AccountGroup accountGroup in state.accountGroups) {
      formattedData.putIfAbsent(accountGroup, () => []);
      for (Account account in state.accounts) {
        if (accountGroup == account.group) {
          formattedData[accountGroup]?.add(account);
        }
      }
    }
    return formattedData;
  }

  List<MenuItem> _buildChildrenTiles(
      Map<AccountGroup, List<Account>> formattedData, int index) {
    return formattedData.entries
        .elementAt(index)
        .value
        .map(
          (item) => MenuItem(
            entry: MenuGroupItem(
              title: Text(item.name, overflow: TextOverflow.ellipsis),
              trailing:
                  Text(englishDisplayCurrencyFormatter.format(item.balance)),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          Map<AccountGroup, List<Account>> formattedData =
              formatAccountGroups(state);
          return Column(
            children: [
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: formattedData.keys.length,
                itemBuilder: (context, index) {
                  return MenuGroup(
                    title: formattedData.keys.elementAt(index).name,
                    children: _buildChildrenTiles(formattedData, index),
                  );
                  // return ListTile(title: Text(index.toString()));
                },
              )
            ],
          );
        },
      ),
    );
  }
}
