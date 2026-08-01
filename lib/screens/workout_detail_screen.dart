// workout_detail_screen.dart
// This is the file to link for the "detail screen implementation" checklist
// item. Reached by tapping the navigation icon on a Home screen workout
// card (evidence-detail-navigation.png). Displays full item info
// (evidence-detail-screen.png) and lets the user favorite the workout,
// which writes to real local storage via StorageService.

import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/storage_service.dart';

const Color kPrimaryGreen = Color(0xFF00C896);
const Color kAccentBlue = Color(0xFF0575E6);
const Color kBackground = Color(0xFFF6F8FB);

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;
  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteState();
  }

  Future<void> _loadFavoriteState() async {
    final favorites = await StorageService.getFavoriteIds();
    if (!mounted) return;
    setState(() => isFavorited = favorites.contains(widget.workout.id));
  }

  Future<void> _toggleFavorite() async {
    await StorageService.toggleFavorite(widget.workout.id);
    if (!mounted) return;
    setState(() => isFavorited = !isFavorited);
  }

  Color get _color =>
      Color(int.parse(widget.workout.colorHex.replaceAll('#', '0xFF')));

  @override
  Widget build(BuildContext context) {
    final workout = widget.workout;

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: _color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_color, kAccentBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.self_improvement,
                    color: Colors.white24, size: 140),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(workout.title,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700)),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: kPrimaryGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_outlined,
                                size: 16, color: kPrimaryGreen),
                            const SizedBox(width: 4),
                            Text(workout.duration,
                                style: const TextStyle(
                                    color: kPrimaryGreen, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(workout.category, style: const TextStyle(fontSize: 12)),
                    backgroundColor: kBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Description',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(workout.description,
                      style: const TextStyle(color: Colors.black87, height: 1.5)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Start Workout'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isFavorited ? Colors.red : Colors.black87,
                            side: BorderSide(
                                color: isFavorited ? Colors.red : Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: _toggleFavorite,
                          icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border),
                          label: Text(isFavorited ? 'Saved' : 'Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
