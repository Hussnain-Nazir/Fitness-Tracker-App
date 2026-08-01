// favorites_screen.dart
// Reads the favorite workout IDs back out of SharedPreferences via
// StorageService and renders them. This screen is the clearest place to
// screenshot for "data stored in the app's front end as well as in local
// storage" (evidence-integrateScreen-persistence.png) — favorite a workout
// on the Detail screen, then come here (or restart the app) and see it
// still shows up.

import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/storage_service.dart';

const Color kPrimaryGreen = Color(0xFF00C896);
const Color kAccentBlue = Color(0xFF0575E6);
const Color kBackground = Color(0xFFF6F8FB);

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Workout> favoriteWorkouts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ids = await StorageService.getFavoriteIds();
    if (!mounted) return;
    setState(() {
      favoriteWorkouts = kAllWorkouts.where((w) => ids.contains(w.id)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kPrimaryGreen, kAccentBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 44, color: kPrimaryGreen),
                      ),
                      const SizedBox(height: 12),
                      const Text('My Profile',
                          style: TextStyle(
                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text('${favoriteWorkouts.length} saved workout(s)',
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Text('My Favorite Workouts',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              if (isLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator(color: kPrimaryGreen)),
                  ),
                )
              else if (favoriteWorkouts.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No favorites yet.\nTap the heart on a workout\'s detail screen to save it here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final workout = favoriteWorkouts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        child: Card(
                          elevation: 1,
                          shadowColor: Colors.black.withOpacity(0.05),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            leading: CircleAvatar(
                              backgroundColor: kPrimaryGreen.withOpacity(0.12),
                              child: const Icon(Icons.fitness_center, color: kPrimaryGreen),
                            ),
                            title: Text(workout.title,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text('${workout.category} · ${workout.duration}'),
                            trailing: const Icon(Icons.favorite,
                                color: Colors.redAccent, size: 20),
                          ),
                        ),
                      );
                    },
                    childCount: favoriteWorkouts.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
