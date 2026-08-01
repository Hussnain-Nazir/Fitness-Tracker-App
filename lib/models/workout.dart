// workout.dart
// Simple data model representing a single workout/exercise.

class Workout {
  final String id;
  final String title;
  final String category;
  final String duration;
  final String description;
  final String colorHex;

  const Workout({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.description,
    required this.colorHex,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'duration': duration,
        'description': description,
        'colorHex': colorHex,
      };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        id: json['id'],
        title: json['title'],
        category: json['category'],
        duration: json['duration'],
        description: json['description'],
        colorHex: json['colorHex'],
      );
}

/// Static seed data used across the app (Home, Detail, Favorites screens).
/// In a production app this would come from a database or API.
final List<Workout> kAllWorkouts = [
  const Workout(
    id: 'w1',
    title: 'Full Body Burn',
    category: 'Strength',
    duration: '30 min',
    colorHex: '#00C896',
    description:
        'A high-intensity full-body circuit designed to build strength and '
        'endurance. Mixes bodyweight exercises with short rest intervals to '
        'keep your heart rate up while targeting every major muscle group.',
  ),
  const Workout(
    id: 'w2',
    title: 'Morning Yoga Flow',
    category: 'Flexibility',
    duration: '20 min',
    colorHex: '#0575E6',
    description:
        'A gentle sequence of stretches and poses to wake up the body, '
        'improve flexibility, and center the mind before the day begins.',
  ),
  const Workout(
    id: 'w3',
    title: '5K Interval Run',
    category: 'Cardio',
    duration: '35 min',
    colorHex: '#FF7A00',
    description:
        'Alternating sprint and jog intervals designed to boost cardiovascular '
        'fitness and burn calories quickly. Great for building running speed.',
  ),
  const Workout(
    id: 'w4',
    title: 'Core & Abs Blast',
    category: 'Strength',
    duration: '15 min',
    colorHex: '#E53935',
    description:
        'A focused core routine targeting the abs, obliques, and lower back '
        'to build core stability and definition.',
  ),
];
