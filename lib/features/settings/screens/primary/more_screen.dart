import 'package:budget_buddy/features/settings/components/general_group.dart';
import 'package:budget_buddy/features/settings/components/security_group.dart';
import 'package:budget_buddy/features/settings/components/signout_button.dart';
import 'package:budget_buddy/features/settings/components/style_group.dart';
import 'package:budget_buddy/features/settings/components/support_group.dart';
import 'package:budget_buddy/features/settings/widgets/menu_group.dart';
import 'package:budget_buddy/features/settings/components/user_info.dart';
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

  void navigate(String route) {
    print('Navigate to $route');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], //TODO change the background color here
      appBar: AppBar(title: const Text('More')),
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
