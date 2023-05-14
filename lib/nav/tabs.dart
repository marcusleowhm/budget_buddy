import 'package:budget_buddy/nav/tab_navigator_item.dart';
import 'package:flutter/material.dart';

const tabs = [
  TabNavigatorItem(
      initialLocation: '/dashboard',
      icon: Icon(Icons.monitor),
      label: 'Dashboard'),
  TabNavigatorItem(
      initialLocation: '/statistics',
      icon: Icon(Icons.bar_chart),
      label: 'Statistics'),
  TabNavigatorItem(
      initialLocation: '/ledger',
      icon: Icon(Icons.edit),
      label: 'Ledger'),
  TabNavigatorItem(
      initialLocation: '/balance',
      icon: Icon(Icons.account_balance),
      label: 'Balance'),
  TabNavigatorItem(
      initialLocation: '/more',
      icon: Icon(Icons.more_horiz),
      label: 'More'),
];
