import 'package:budget_buddy/nav/tabs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabNavigator extends StatefulWidget {
  const TabNavigator({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  int _locationToTabIndex(String location) {
    final index =
        tabs.indexWhere((t) => location.startsWith(t.initialLocation));
    return index < 0 ? 0 : index;
  }

  void _onItemTapped(BuildContext context, int tabIndex) {
    if (tabIndex != _currentIndex) {
      context.go(tabs[tabIndex].initialLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: tabs,
        onTap: (index) => {_onItemTapped(context, index)},
      ),
    );
  }
}
