import 'package:flutter/material.dart';

import '../../../mock/account.dart';

class AccountPicker extends StatefulWidget {
  const AccountPicker({
    super.key,
    required this.context,
    required this.onPressed,
  });

  final BuildContext context;
  final void Function(String? selectedAccount) onPressed;

  @override
  State<AccountPicker> createState() => _AccountPickerState();
}

class _AccountPickerState extends State<AccountPicker> {
  bool isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: Colors.grey,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).canvasColor,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mode_edit_outline),
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
              ]),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  return Container(
                    //TODO adjust the text in the grid
                    color: Theme.of(context).canvasColor,
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      child: Text(accounts[index]),
                      onTap: () => widget.onPressed(accounts[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
