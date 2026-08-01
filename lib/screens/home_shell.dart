// home_shell.dart
// Top-level container after login/signup. Holds the bottom navigation bar
// and switches between the four main tabs: Home, Favorites, Weather (API),
// and Settings Menu.

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'weather_screen.dart';
import 'settings_menu_screen.dart';

const Color kPrimaryGreen = Color(0xFF00C896);

class HomeShell extends StatefulWidget {
  final String username;
  const HomeShell({super.key, required this.username});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(username: widget.username),
      const FavoritesScreen(),
      const WeatherScreen(),
      const SettingsMenuScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => setState(() => currentIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: kPrimaryGreen.withOpacity(0.15),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.cloud_outlined), label: 'Weather'),
          // This is the settings-menu nav icon referenced by
          // evidence-menu-icon.png in the checklist.
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
