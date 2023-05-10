import 'package:budget_buddy/widgets/coloriser.dart';
import 'package:budget_buddy/widgets/menu_group.dart';
import 'package:budget_buddy/widgets/user_info.dart';
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
          const UserInfo(), //User information
          const Divider(),
          const MenuGroup(
            //General Setting
            title: 'General',
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(left: 30, right: 30),
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              )
            ],
          ),
          MenuGroup(
            //Look and Feel
            title: 'Look and Feel',
            children: [
              ListTile(
                onTap: () => toggleDarkMode(),
                contentPadding: const EdgeInsets.only(left: 30, right: 10),
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                trailing: Switch(
                    value: isDarkMode, onChanged: (value) => toggleDarkMode()),
              ),
              const Coloriser(),
              ListTile(
                leading: const Icon(Icons.brush_outlined),
                title: const Text('Color'),
                contentPadding: const EdgeInsets.only(left: 30, right: 25),
                trailing: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const MenuGroup(
            title: 'Security',
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(left: 30, right: 30),
                leading: Icon(Icons.email_outlined),
                title: Text('Change Email'),
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 30, right: 30),
                leading: Icon(Icons.lock_outline),
                title: Text('Change Password'),
              )
            ],
          ),
          MenuGroup(
            title: 'Support',
            children: [
              const ListTile(
                contentPadding: EdgeInsets.only(left: 30, right: 30),
                leading: Icon(Icons.bug_report_outlined),
                title: Text('Report bug'),
              ),
              const ListTile(
                contentPadding: EdgeInsets.only(left: 30, right: 30),
                leading: Icon(Icons.feedback_outlined),
                title: Text('Feedback/Suggestion'),
              ),
              const ListTile(
                contentPadding: EdgeInsets.only(left: 30, right: 30),
                leading: Icon(Icons.help_outline),
                title: Text('Help'),
              ),
              const ListTile(
                contentPadding: EdgeInsets.only(left: 30, right: 30),
                leading: Icon(Icons.info_outline),
                title: Text('About'),
              ),
              ListTile(
                title: OutlinedButton(
                  onPressed: () {
                    print('Implement sign out');
                  }, //TODO implement Sign out
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.red)),
                    ),
                    foregroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).canvasColor,
                    ),
                    backgroundColor: const MaterialStatePropertyAll<Color>(
                      Colors.red,
                    ),
                  ),
                  child: const Text('Sign Out'),
                ),
              ),
              ListTile(
                  title: Text(
                'v0.0.1',
                style: TextStyle(color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ))
            ],
          ),
        ],
      ),
    );
  }
}
