import 'package:budget_buddy/mock/account.dart';
import 'package:flutter/material.dart';

class AccountList extends StatelessWidget {
  const AccountList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        child: Container(
          child: Column(
            children: [
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: accountGroups.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(index.toString()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
