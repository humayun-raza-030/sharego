import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  static const _tabs = [
    _TabItem(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home, path: '/'),
    _TabItem(label: 'Trips', icon: Icons.flight_takeoff_outlined, activeIcon: Icons.flight_takeoff, path: '/trip/manage'),
    _TabItem(label: 'Market', icon: Icons.store_mall_directory_outlined, activeIcon: Icons.store_mall_directory, path: '/market'),
    _TabItem(label: 'Messages', icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, path: '/chat'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/market')) return 2;
    if (location.startsWith('/trip')) return 1;
    if (location.startsWith('/chat')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          if (i != index) context.go(_tabs[i].path);
        },
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: _tabs
            .map((t) => BottomNavigationBarItem(
                  icon: Icon(t.icon),
                  activeIcon: Icon(t.activeIcon),
                  label: t.label,
                ))
            .toList(),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.label, required this.icon, required this.activeIcon, required this.path});
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String path;
}
