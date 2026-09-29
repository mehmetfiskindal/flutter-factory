import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

{{#include_offline}}{{^is_native}}import '../offline/offline_banner.dart';
{{/is_native}}
{{/include_offline}}
import 'route_paths.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.child,
    this.offlineBanner,
    super.key,
  });

  final Widget child;
  final Widget? offlineBanner;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: {{#include_offline}}Column(
        children: [
          {{#is_native}}offlineBanner!,{{/is_native}}{{^is_native}}offlineBanner ?? const OfflineBanner(),{{/is_native}}
          Expanded(child: child),
        ],
      ){{/include_offline}}{{^include_offline}}child{{/include_offline}},
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(location),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.goNamed(RouteNames.home);
            case 1:
              context.goNamed(RouteNames.settings);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _selectedIndex(String location) {
    return switch (location) {
      RoutePaths.settings => 1,
      _ => 0,
    };
  }
}
