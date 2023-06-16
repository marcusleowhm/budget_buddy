import 'package:flutter/material.dart';

class CustomTabController extends StatefulWidget {
  const CustomTabController({
    super.key,
    this.initialIndex,
    required this.length,
    required this.tabs,
    required this.views,
  }) : assert(tabs.length == views.length);

  final int? initialIndex;
  final int length;
  final List<Widget> tabs;
  final List<Widget> views;

  @override
  State<CustomTabController> createState() => _CustomTabControllerState();
}

class _CustomTabControllerState extends State<CustomTabController>
    with SingleTickerProviderStateMixin {
  late int selectedIndex;
  late TabController _tabController;

  @override
  void initState() {
    _initController();
    _initInitialIndex();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initInitialIndex() {
    setState(() {
      selectedIndex = widget.initialIndex ?? 0;
      _tabController.index = selectedIndex;
    });
  }

  void _initController() {
    _tabController = TabController(length: widget.length, vsync: this);
    _tabController.addListener(_setPage);
  }

  //Listener function to help set page when user navigates
  void _setPage() {
    selectedIndex = _tabController.index;
    setState(() => _tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: widget.tabs,
        ),
        Builder(
          builder: (context) {
            return widget.views[selectedIndex];
          },
        )
      ],
    );
  }
}
