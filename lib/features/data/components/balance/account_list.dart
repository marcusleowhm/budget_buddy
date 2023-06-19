import 'package:budget_buddy/features/configuration/widgets/menu_group.dart';
import 'package:budget_buddy/features/configuration/widgets/menu_group_item.dart';
import 'package:budget_buddy/mock/account.dart';
import 'package:flutter/material.dart';

class AccountList extends StatelessWidget {
  const AccountList({super.key});

  List<MenuItem> _buildChildrenTiles(int index) {
    return accountGroups.entries.elementAt(index).value.isEmpty
        ? [
            MenuItem(
              entry: MenuGroupItem(
                title: Text(accountGroups.entries.elementAt(index).key),
                trailing: Text('2222222'),
              ),
            )
          ]
        : accountGroups.entries
            .elementAt(index)
            .value
            .map(
              (item) => MenuItem(
                entry: MenuGroupItem(
                  title: Text(item, overflow: TextOverflow.ellipsis),
                  trailing: Text('1111111111111'),
                ),
              ),
            )
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: accountGroups.length,
            itemBuilder: (context, index) {
              return MenuGroup(
                title: accountGroups.keys.elementAt(index),
                children: _buildChildrenTiles(index),
              );
              // return ListTile(title: Text(index.toString()));
            },
          )
        ],
      ),
    );
  }
}
