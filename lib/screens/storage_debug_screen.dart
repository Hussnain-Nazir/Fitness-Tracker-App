// storage_debug_screen.dart
// Shows every key/value currently persisted in SharedPreferences. This is
// the easiest screen to screenshot for "evidence-persistence.png" — it
// proves data is really being written to local storage, not just held in
// memory. Favorite a workout or save your Settings profile, then open this
// screen (or restart the app first) to see the raw stored values.

import 'package:flutter/material.dart';
import '../services/storage_service.dart';

const Color kPrimaryGreen = Color(0xFF00C896);
const Color kBackground = Color(0xFFF6F8FB);

class StorageDebugScreen extends StatefulWidget {
  const StorageDebugScreen({super.key});

  @override
  State<StorageDebugScreen> createState() => _StorageDebugScreenState();
}

class _StorageDebugScreenState extends State<StorageDebugScreen> {
  Map<String, String> data = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final raw = await StorageService.getAllRaw();
    if (!mounted) return;
    setState(() {
      data = raw;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        title: const Text('Local Storage',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryGreen))
          : data.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Nothing stored yet.\nTry favoriting a workout or saving your profile in Settings, then come back here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: data.entries
                      .map(
                        (entry) => Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: 1,
                          shadowColor: Colors.black.withOpacity(0.05),
                          shape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(entry.key,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: kPrimaryGreen)),
                                const SizedBox(height: 4),
                                Text(entry.value, style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
    );
  }
}
