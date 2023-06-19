import 'package:budget_buddy/features/data/model/account.dart';
import 'package:budget_buddy/features/data/model/account_group.dart';
import 'package:flutter/material.dart';

class AccountListView extends StatelessWidget {
  const AccountListView({
    super.key,
    required this.selectedGroupIndex,
    required this.mappedAccount,
    required this.selectGroupIndex,
    required this.onSelectAccount,
  });

  final int selectedGroupIndex;
  final Map<AccountGroup, List<Account>> mappedAccount;
  final void Function(int) selectGroupIndex;
  final void Function(String, String?) onSelectAccount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: mappedAccount.keys.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: selectedGroupIndex == index
                              ? Colors.blue[100] //TODO change color
                              : Theme.of(context).canvasColor,
                          border: Border.all(
                            width: 0.5,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: ListTile(
                          onTap: selectedGroupIndex == index
                              //If the group is already selected, just select the index and disallow returning the group
                              ? () => () => selectGroupIndex(index)
                              //If group is not already selected, select it
                              : () => selectGroupIndex(index),
                          title: Text(
                            mappedAccount.keys.elementAt(index).name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: mappedAccount.values
                        .elementAt(selectedGroupIndex)
                        .length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          border: Border.all(
                            width: 0.5,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            onSelectAccount(
                              //Value stored in the data structure
                              //Account
                              mappedAccount.keys
                                  .elementAt(selectedGroupIndex)
                                  .name,
                              //Sub account
                              mappedAccount.values
                                  .elementAt(selectedGroupIndex)
                                  .elementAt(index)
                                  .name,
                            );
                          },
                          title: Text(
                            //Sub account
                            mappedAccount.values
                                .elementAt(selectedGroupIndex)
                                .elementAt(index)
                                .name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
