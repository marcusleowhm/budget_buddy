import 'package:budget_buddy/features/configuration/components/general_group.dart';
import 'package:budget_buddy/features/configuration/components/security_group.dart';
import 'package:budget_buddy/features/configuration/components/signout_button.dart';
import 'package:budget_buddy/features/configuration/components/style_group.dart';
import 'package:budget_buddy/features/configuration/components/support_group.dart';
import 'package:budget_buddy/features/configuration/components/user_info.dart';
import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';

//Reference https://x-wei.github.io/flutter_catalog/#/minified:a8F

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool isDarkMode = false;
  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], //TODO change the background color here
      appBar: AppBar(title: Text('${titles[MainRoutes.more]}')),
      body: ListView(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        children: [
          const UserInfo(),
          const Divider(),
          const GeneralGroup(),
          const StyleGroup(),
          const SecurityGroup(),
          const SupportGroup(),
          const SignOutButton(),
          ListTile(
            title: Text(
              'v0.0.1',
              style: TextStyle(color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
