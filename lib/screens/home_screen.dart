// home_screen.dart
// This is the file to link for the "home screen implementation" checklist
// item. Mirrors the structure from the Habit Tracker lab (Incomplete/Done
// lists with swipe actions) but adapted to workouts, with completed-state
// persisted via StorageService (SharedPreferences).

import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/storage_service.dart';
import 'workout_detail_screen.dart';

const Color kPrimaryGreen = Color(0xFF00C896);
const Color kBackground = Color(0xFFF6F8FB);

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> completedIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompleted();
  }

  Future<void> _loadCompleted() async {
    final ids = await StorageService.getCompletedIds();
    if (!mounted) return;
    setState(() {
      completedIds = ids;
      isLoading = false;
    });
  }

  Future<void> _toggleCompleted(String workoutId, bool markCompleted) async {
    setState(() {
      if (markCompleted) {
        completedIds.add(workoutId);
      } else {
        completedIds.remove(workoutId);
      }
    });
    await StorageService.setCompletedIds(completedIds);
  }

  @override
  Widget build(BuildContext context) {
    final incomplete =
        kAllWorkouts.where((w) => !completedIds.contains(w.id)).toList();
    final completed =
        kAllWorkouts.where((w) => completedIds.contains(w.id)).toList();

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        // ---------- Logo in app header ----------
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: kPrimaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.fitness_center_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'FitTrack · ${widget.username}',
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryGreen))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('My Workouts',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                incomplete.isEmpty
                    ? const _EmptyState(
                        message: 'All workouts completed! Great job. 🎉')
                    : Column(
                        children: incomplete
                            .map((w) => _WorkoutTile(
                                  workout: w,
                                  isCompleted: false,
                                  onDismissed: () => _toggleCompleted(w.id, true),
                                ))
                            .toList(),
                      ),
                const Divider(height: 32),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('Completed ✅',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                completed.isEmpty
                    ? const _EmptyState(
                        message: 'Swipe left on a workout to mark it done.')
                    : Column(
                        children: completed
                            .map((w) => _WorkoutTile(
                                  workout: w,
                                  isCompleted: true,
                                  onDismissed: () => _toggleCompleted(w.id, false),
                                ))
                            .toList(),
                      ),
              ],
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ),
    );
  }
}

class _WorkoutTile extends StatelessWidget {
  final Workout workout;
  final bool isCompleted;
  final VoidCallback onDismissed;

  const _WorkoutTile({
    required this.workout,
    required this.isCompleted,
    required this.onDismissed,
  });

  Color get _color => Color(
      int.parse(workout.colorHex.replaceAll('#', '0xFF')));

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${workout.id}_$isCompleted'),
      direction: isCompleted
          ? DismissDirection.startToEnd
          : DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        decoration: BoxDecoration(
          color: isCompleted ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment:
            isCompleted ? Alignment.centerLeft : Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isCompleted ? Icons.undo : Icons.check, color: Colors.white),
            const SizedBox(width: 8),
            Text(isCompleted ? 'Swipe to Undo' : 'Swipe to Complete',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        color: _color.withOpacity(isCompleted ? 0.5 : 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          title: Text(
            workout.title.toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
          ),
          subtitle: Text(
            '${workout.category} · ${workout.duration}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          // ---------- Navigation icon -> Workout Detail screen ----------
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white, size: 18),
            tooltip: 'View details',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkoutDetailScreen(workout: workout),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
