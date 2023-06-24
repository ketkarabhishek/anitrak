import 'package:anitrak/src/pages/dashboard_page.dart';
import 'package:anitrak/src/pages/library_page.dart';
import 'package:anitrak/src/pages/more_page.dart';
import 'package:anitrak/src/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin<App> {
  int _currentIndex = 0;
  late AnimationController _hide;

  @override
  void initState() {
    super.initState();
    _hide = AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hide.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _hide.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if ((notification.depth == 0 && _currentIndex != 2) ||
        (_currentIndex == 2 && notification.depth != 0)) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            _hide.forward();
            break;
          case ScrollDirection.reverse:
            _hide.reverse();
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  Widget _bottomNavBar(BuildContext context) {
    return ClipRect(
      child: SizeTransition(
        sizeFactor: _hide,
        axisAlignment: -1.0,
        axis: Axis.vertical,
        child: NavigationBar(
          selectedIndex: _currentIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              label: "Dashboard",
            ),
            NavigationDestination(
              icon: Icon(Icons.list_outlined),
              label: "Library",
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              label: "Search",
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz_outlined),
              label: "More",
            ),
          ],
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _currentIndex,
            children: const [
              DashboardPage(),
              LibraryPage(),
              SearchPage(),
              MorePage(),
            ],
          ),
        ),
        bottomNavigationBar: _bottomNavBar(context),
      ),
    );
  }
}
