import 'package:budget_buddy/screens/primary/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:budget_buddy/screens/primary/dashboard_screen.dart';
import 'package:budget_buddy/screens/primary/statistics_screen.dart';
import 'package:budget_buddy/screens/primary/ledger_screen.dart';
import 'package:budget_buddy/screens/primary/account_screen.dart';

class RootNavigator extends StatefulWidget {
  const RootNavigator({super.key});

  @override
  State<RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<RootNavigator> {
  int _selectedIndex = 0;

  void _onTapped(int index) => setState(() => _selectedIndex = index);

  List<Widget> pages = <Widget>[
    const DashboardScreen(),
    const StatisticsScreen(),
    const LedgerScreen(),
    const AccountScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: pages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Statistics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: 'Ledger',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              label: 'Accounts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onTapped),
    );
  }
}
