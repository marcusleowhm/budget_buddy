import 'package:flutter/material.dart';

class AccountListView extends StatelessWidget {
  const AccountListView({
    super.key,
    required this.selectedGroupIndex,
    required this.accountGroups,
    required this.selectGroupIndex,
    required this.onSelectAccount,
  });

  final int selectedGroupIndex;
  final Map<String, List<String>> accountGroups;
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
                    itemCount: accountGroups.keys.length,
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
                        child: accountGroups.values.elementAt(index).isEmpty
                            //Without chevron, without sub groups. SubAccount will equal Account
                            ? ListTile(
                                onTap: () => onSelectAccount(
                                      accountGroups.keys.elementAt(index),
                                      accountGroups.keys.elementAt(index),
                                    ),
                                title:
                                    Text(accountGroups.keys.elementAt(index)),
                                trailing: null)
                            //With chevron
                            : ListTile(
                                onTap: selectedGroupIndex == index
                                    //If the group is already selected, just select the index and disallow returning the group
                                    ? () => () => selectGroupIndex(index)
                                    //If group is not already selected, select it
                                    : () => selectGroupIndex(index),
                                title: Text(
                                  accountGroups.keys.elementAt(index),
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
                    itemCount: accountGroups.values
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
                              accountGroups.keys.elementAt(selectedGroupIndex),
                              //Sub account
                              accountGroups.values
                                  .elementAt(selectedGroupIndex)
                                  .elementAt(index),
                            );
                          },
                          title: Text(
                            //Sub account
                            accountGroups.values
                                .elementAt(selectedGroupIndex)
                                .elementAt(index),
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
