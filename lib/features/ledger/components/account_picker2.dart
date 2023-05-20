import 'package:flutter/material.dart';

import '../../../mock/account.dart';

class AccountPicker2 extends StatefulWidget {
  const AccountPicker2({super.key, required this.onPressed});

  final void Function(String? selectedAccount) onPressed;

  @override
  State<AccountPicker2> createState() => _AccountPicker2State();
}

class _AccountPicker2State extends State<AccountPicker2> {
  bool isGridView = true;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: 0.4,
        child: Container(
          color: Colors.grey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                color: Theme.of(context).canvasColor,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.mode_edit_outline_outlined),
                    ),
                    IconButton(
                      onPressed: () => setState(() => isGridView = !isGridView),
                      icon: isGridView
                          ? const Icon(Icons.list)
                          : const Icon(Icons.window_rounded),
                    ),
                    IconButton(
                      onPressed: () => widget.onPressed(null),
                      icon: const Icon(Icons.cancel_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            border: Border.all()),
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
