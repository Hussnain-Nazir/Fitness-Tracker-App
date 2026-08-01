// settings_menu_screen.dart
// This is the file to link for the "settings menu implementation" checklist
// item. The gear icon in the bottom nav (see home_shell.dart) is
// evidence-menu-icon.png; the list of items below is evidence-menu-items.png.

import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';
import 'storage_debug_screen.dart';
import 'login_screen.dart';

const Color kPrimaryGreen = Color(0xFF00C896);
const Color kAccentBlue = Color(0xFF0575E6);
const Color kBackground = Color(0xFFF6F8FB);

class SettingsMenuScreen extends StatelessWidget {
  const SettingsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        title: const Text('Menu',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _MenuTile(
              icon: Icons.person_outline,
              label: 'Personal Info',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
            _MenuTile(
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
            ),
            _MenuTile(
              icon: Icons.storage_outlined,
              label: 'Local Storage (debug)',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StorageDebugScreen()),
              ),
            ),
            const Divider(height: 32),
            _MenuTile(
              icon: Icons.logout,
              label: 'Sign Out',
              color: Colors.redAccent,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
