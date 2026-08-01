// notifications_screen.dart
// This is the file to link for the notification-related checklist items.
// Uses NotificationService (flutter_local_notifications) for REAL device
// notifications:
//   - "Enable Notifications" requests OS permission
//   - "Send Test Notification Now" fires an instant alert
//   - "Schedule Reminder" schedules a real notification a few seconds out
//     (leave the app in the background / lock the screen to see it land —
//     that's your evidence-notification-alert.png).

import 'package:flutter/material.dart';
import '../services/notification_service.dart';

const Color kPrimaryGreen = Color(0xFF00C896);
const Color kAccentBlue = Color(0xFF0575E6);
const Color kBackground = Color(0xFFF6F8FB);

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _Reminder {
  final String title;
  final String time;
  final String date;
  bool enabled;

  _Reminder({required this.title, required this.time, required this.date, this.enabled = true});
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_Reminder> reminders = [
    _Reminder(title: 'Morning Run', time: '06:30 AM', date: 'Daily'),
    _Reminder(title: 'Hydration Check', time: '12:00 PM', date: 'Daily'),
    _Reminder(title: 'Evening Yoga', time: '07:00 PM', date: 'Mon, Wed, Fri', enabled: false),
    _Reminder(title: 'Weigh-In', time: '08:00 AM', date: 'Sundays'),
  ];

  bool isScheduling = false;

  Future<void> _enableNotifications() async {
    await NotificationService.requestPermission();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification permission requested.')),
    );
  }

  Future<void> _sendInstant() async {
    await NotificationService.showInstant(
      title: 'FitTrack Reminder',
      body: "Time for your workout — let's go! 💪",
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification sent — check your notification tray.')),
    );
  }

  Future<void> _scheduleReminder() async {
    setState(() => isScheduling = true);
    await NotificationService.scheduleReminder(
      id: 1,
      title: 'FitTrack Reminder',
      body: 'Your scheduled workout reminder is here!',
      secondsFromNow: 10,
    );
    if (!mounted) return;
    setState(() => isScheduling = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder scheduled for 10 seconds from now.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        title: const Text('Notifications',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---------- Real notification controls ----------
            Card(
              elevation: 1,
              shadowColor: Colors.black.withOpacity(0.05),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Notification Setup',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 4),
                    const Text(
                      'Grant permission, then test that real notifications work on this device.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: _enableNotifications,
                      icon: const Icon(Icons.lock_open_outlined),
                      label: const Text('Enable Notifications'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentBlue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _sendInstant,
                      icon: const Icon(Icons.notifications_active_outlined),
                      label: const Text('Send Test Notification Now'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryGreen,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: isScheduling ? null : _scheduleReminder,
                      icon: const Icon(Icons.schedule),
                      label: Text(isScheduling
                          ? 'Scheduling...'
                          : 'Schedule Reminder (fires in 10s)'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Upcoming Reminders',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...reminders.map((reminder) => _buildReminderCard(reminder)),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(_Reminder reminder) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (reminder.enabled ? kAccentBlue : Colors.grey).withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.access_time_rounded,
                  color: reminder.enabled ? kAccentBlue : Colors.grey),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reminder.title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: reminder.enabled ? Colors.black87 : Colors.grey)),
                  const SizedBox(height: 2),
                  Text('${reminder.time} · ${reminder.date}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Switch(
              value: reminder.enabled,
              activeThumbColor: kPrimaryGreen,
              onChanged: (value) => setState(() => reminder.enabled = value),
            ),
          ],
        ),
      ),
    );
  }
}
