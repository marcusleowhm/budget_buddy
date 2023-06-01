import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:budget_buddy/nav/tab_navigator_item.dart';
import 'package:flutter/material.dart';

List<TabNavigatorItem> tabs = [
  TabNavigatorItem(
      initialLocation: '/${routes[MainRoutes.dashboard]}',
      icon: const Icon(Icons.monitor),
      label: '${labels[MainRoutes.dashboard]}'),
  TabNavigatorItem(
      initialLocation: '/${routes[MainRoutes.statistics]}',
      icon: const Icon(Icons.bar_chart),
      label: '${labels[MainRoutes.statistics]}'),
  TabNavigatorItem(
      initialLocation: '/${routes[MainRoutes.ledger]}',
      icon: const Icon(Icons.edit),
      label: '${labels[MainRoutes.ledger]}'),
  TabNavigatorItem(
      initialLocation: '/${routes[MainRoutes.balance]}',
      icon: const Icon(Icons.account_balance),
      label: '${labels[MainRoutes.balance]}'),
  TabNavigatorItem(
      initialLocation: '/${routes[MainRoutes.more]}',
      icon: const Icon(Icons.more_horiz),
      label: '${labels[MainRoutes.more]}'),
];
