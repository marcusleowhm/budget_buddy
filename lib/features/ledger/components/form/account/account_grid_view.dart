import 'package:budget_buddy/features/data/model/account.dart';
import 'package:budget_buddy/features/data/model/account_group.dart';
import 'package:flutter/material.dart';

class AccountGridView extends StatelessWidget {
  const AccountGridView({
    super.key,
    required this.mappedAccount,
    required this.onItemPressed,
  });

  final Map<AccountGroup, List<Account>> mappedAccount;
  final void Function(String?, String?) onItemPressed;

  List<Account> flattenAccount() {
    List<Account> flattenedAccounts = [];
    for (MapEntry entry in mappedAccount.entries) {
      flattenedAccounts.addAll(entry.value);
    }
    return flattenedAccounts;
  }

  @override
  Widget build(BuildContext context) {

    List<Account> flattenedAccounts = flattenAccount();

    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 64,
          crossAxisCount: 3,
        ),
        itemCount: flattenedAccounts.length,
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
                flattenedAccounts.elementAt(index).name,
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () => onItemPressed(
              flattenedAccounts.elementAt(index).group.name,
              flattenedAccounts.elementAt(index).name,
            ),
          );
        },
      ),
    );
  }
}
