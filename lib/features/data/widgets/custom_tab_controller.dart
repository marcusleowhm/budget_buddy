import 'package:expandable_page_view/expandable_page_view.dart';
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
  late PageController _pageController;

  @override
  void initState() {
    _initInitialIndex();
    _initController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _initInitialIndex() {
    setState(() {
      selectedIndex = widget.initialIndex ?? 0;
      // _tabController.index = selectedIndex;
    });
  }

  void _initController() {
    _tabController = TabController(length: widget.length, vsync: this);
    //Set the default tab
    setState(() => _tabController.index = selectedIndex);
    _tabController.addListener(_setTab);

    _pageController = PageController(initialPage: selectedIndex);
    _pageController.addListener(_setPage);
  }

  //Listener function to help set page when user navigates
  void _setTab() {
    if (_tabController.index != _pageController.page?.round()) {
      //Set page
      _pageController.animateToPage(_tabController.index,
          duration: const Duration(milliseconds: 100), curve: Curves.ease);
    }
  }

  void _setPage() {
    if (_tabController.index != _pageController.page?.round()) {
      _tabController.animateTo(_pageController.page?.round() ?? 0,
          duration: const Duration(milliseconds: 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: widget.tabs,
        ),
        ExpandablePageView(
          controller: _pageController,
          children: widget.views,
        ),
      ],
    );
  }
}
