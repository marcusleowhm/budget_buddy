import 'package:flutter/material.dart';

class AccountGridView extends StatelessWidget {
  const AccountGridView({
    super.key,
    required this.accounts,
    required this.onItemPressed,
  });

  final List<String> accounts;
  final void Function(String?) onItemPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            onTap: () => onItemPressed(accounts[index]),
          );
        },
      ),
    );
  }
}
