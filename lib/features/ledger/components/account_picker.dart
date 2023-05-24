import 'package:flutter/material.dart';

import '../../../mock/account.dart';

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
                  ? Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 64,
                          crossAxisCount: 3,
                        ),
                        itemCount: accounts.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                border: Border.all(
                                  width: 0.5,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              child: Text(
                                accounts[index],
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () => widget.onPressed(accounts[index]),
                          );
                        },
                      ),
                    )
                  : Expanded(
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
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: accountGroups.keys.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: selectedGroupIndex == index
                                              ? Colors
                                                  .blue[100] //TODO change color
                                              : Theme.of(context).canvasColor,
                                          border: Border.all(
                                            width: 0.5,
                                            color:
                                                Theme.of(context).dividerColor,
                                          ),
                                        ),
                                        child: ListTile(
                                          onTap: () => setState(
                                              () => selectedGroupIndex = index),
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
                                    physics: const ScrollPhysics(),
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
                                            color:
                                                Theme.of(context).dividerColor,
                                          ),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            widget.onPressed(
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
                    )
            ],
          ),
        ));
  }
}
