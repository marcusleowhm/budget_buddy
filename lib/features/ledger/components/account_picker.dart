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

  @override
  Widget build(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.mode_edit_outline_outlined),
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
                      onPressed: () => widget.onPressed(null),
                      icon: const Icon(Icons.cancel_rounded),
                      color: Theme.of(context).canvasColor,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            ],
          ),
        ));
  }
}