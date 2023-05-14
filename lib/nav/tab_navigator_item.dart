import 'package:flutter/material.dart';

class TabNavigatorItem extends BottomNavigationBarItem {
  const TabNavigatorItem(
      {required this.initialLocation, required Widget icon, String? label})
      : super(icon: icon, label: label);

  final String initialLocation;
}
