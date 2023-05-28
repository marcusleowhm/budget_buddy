import 'package:flutter/material.dart';

class AccountListView extends StatelessWidget {
  const AccountListView(
      {super.key,
      required this.selectedGroupIndex,
      required this.accountGroups,
      required this.selectGroupIndex,
      required this.onSelectAccount,
      });

  final int selectedGroupIndex;
  final Map<String, List<String>> accountGroups;
  final void Function(int) selectGroupIndex;
  final void Function(String) onSelectAccount;

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
                        child: ListTile(
                          onTap: () => selectGroupIndex(index),
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
                              accountGroups.values
                                  .elementAt(selectedGroupIndex)
                                  .elementAt(index),
                            );
                          },
                          title: Text(
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
