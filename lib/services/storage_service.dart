// storage_service.dart
// Central wrapper around SharedPreferences. Every screen that needs to
// read/write local data goes through this service so persistence logic
// lives in one place (this is the file to link for the "local storage
// implementation" checklist item).

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // ---------- Keys ----------
  static const String kFavoritesKey = 'favorite_workout_ids';
  static const String kCompletedKey = 'completed_workout_ids';
  static const String kProfileNameKey = 'profile_name';
  static const String kProfileUsernameKey = 'profile_username';
  static const String kProfileAgeKey = 'profile_age';
  static const String kProfileCountryKey = 'profile_country';
  static const String kDarkModeKey = 'dark_mode_enabled';
  static const String kUsersKey = 'registered_users'; // JSON map username->password

  // ---------- Favorites ----------
  static Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(kFavoritesKey) ?? [];
  }

  static Future<void> toggleFavorite(String workoutId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(kFavoritesKey) ?? [];
    if (current.contains(workoutId)) {
      current.remove(workoutId);
    } else {
      current.add(workoutId);
    }
    await prefs.setStringList(kFavoritesKey, current);
  }

  // ---------- Completed workouts (Home screen Done/Incomplete split) ----------
  static Future<List<String>> getCompletedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(kCompletedKey) ?? [];
  }

  static Future<void> setCompletedIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(kCompletedKey, ids);
  }

  // ---------- Profile / Settings ----------
  static Future<void> saveProfile({
    required String name,
    required String username,
    required String age,
    required String country,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kProfileNameKey, name);
    await prefs.setString(kProfileUsernameKey, username);
    await prefs.setString(kProfileAgeKey, age);
    await prefs.setString(kProfileCountryKey, country);
  }

  static Future<Map<String, String>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(kProfileNameKey) ?? 'Alex Johnson',
      'username': prefs.getString(kProfileUsernameKey) ?? 'alexfit',
      'age': prefs.getString(kProfileAgeKey) ?? '25',
      'country': prefs.getString(kProfileCountryKey) ?? 'Australia',
    };
  }

  static Future<void> setDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kDarkModeKey, enabled);
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kDarkModeKey) ?? false;
  }

  // ---------- Registered users (used by AuthService for signup/login) ----------
  static Future<Map<String, String>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(kUsersKey);
    if (raw == null) return {};
    return Map<String, String>.from(jsonDecode(raw));
  }

  static Future<void> saveUsers(Map<String, String> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kUsersKey, jsonEncode(users));
  }

  /// Returns every key/value currently stored, as raw strings.
  /// Used by the local-storage debug screen so you can screenshot the
  /// literal persisted data (evidence-persistence.png).
  static Future<Map<String, String>> getAllRaw() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final Map<String, String> result = {};
    for (final key in keys) {
      final value = prefs.get(key);
      result[key] = value.toString();
    }
    return result;
  }
}
