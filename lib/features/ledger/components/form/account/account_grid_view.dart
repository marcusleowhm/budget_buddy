import 'package:flutter/material.dart';

class AccountGridView extends StatelessWidget {
  const AccountGridView({
    super.key,
    required this.accountGroups,
    required this.onItemPressed,
  });

  final Map<String, List<String>> accountGroups;
  final void Function(String?, String?) onItemPressed;

  List<Map<String, String>> flattenAccountGroups() {
    List<Map<String, String>> accounts = [];
    for (MapEntry entry in accountGroups.entries) {
      String key = entry.key;
      List<String> values = entry.value;
      //Treat account as subAccount if there is no subAccount
      if (values.isEmpty) {
        accounts.add({key: key});
        continue;
      }

      for (String value in values) {
        accounts.add({key: value});
      }
    }
    return accounts;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> flattenedAccount = flattenAccountGroups();
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 64,
          crossAxisCount: 3,
        ),
        itemCount: flattenedAccount.length,
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
                flattenedAccount.elementAt(index).values.first,
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () => onItemPressed(
              flattenedAccount.elementAt(index).keys.first,
              flattenedAccount.elementAt(index).values.first,
            ),
          );
        },
      ),
    );
  }
}
