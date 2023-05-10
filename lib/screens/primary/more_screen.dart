import 'package:budget_buddy/widgets/menu_group.dart';
import 'package:budget_buddy/widgets/menu_item.dart';
import 'package:budget_buddy/widgets/screen_scroll_wrapper.dart';
import 'package:budget_buddy/widgets/user_info.dart';
import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  void navigate(String route) {
    print('Navigate to $route');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ScreenScrollWrapper(
        children: [
          const UserInfo(),
          MenuGroup(
            groupLabel: 'General',
            children: [
              MenuItem(
                title: 'Item 1',
                action: () => navigate('route1'),
              ),
              MenuItem(
                title: 'Item 2',
                action: () => navigate('route2'),
              ),
            ],
          ),
          MenuGroup(
            groupLabel: 'Security',
            children: [
              MenuItem(
                title: 'Item 1',
                action: () => navigate('route3'),
              ),
              MenuItem(
                title: 'Item 1',
                action: () => navigate('route4'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
