// weather_screen.dart
// Displays REAL data fetched from the Open-Meteo API via WeatherService.
// This is the screen to screenshot for evidence-api-ux.png.

import 'package:flutter/material.dart';
import '../services/weather_service.dart';

const Color kPrimaryGreen = Color(0xFF00C896);
const Color kAccentBlue = Color(0xFF0575E6);
const Color kBackground = Color(0xFFF6F8FB);
const Color kErrorRed = Color(0xFFE53935);

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<WeatherResult> _futureWeather;

  @override
  void initState() {
    super.initState();
    _futureWeather = WeatherService.fetchCurrentWeather();
  }

  void _retry() {
    setState(() {
      _futureWeather = WeatherService.fetchCurrentWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        title: const Text('Live Weather',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<WeatherResult>(
          future: _futureWeather,
          builder: (context, snapshot) {
            // ---------- Loading state ----------
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(
                children: const [
                  _ShimmerCard(),
                  SizedBox(height: 12),
                  _ShimmerCard(),
                ],
              );
            }

            // ---------- Error fallback state ----------
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 56, color: kErrorRed),
                    const SizedBox(height: 16),
                    const Text('Unable to load live weather data',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    const Text('Check your internet connection and try again.',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryGreen,
                        foregroundColor: Colors.white,
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _retry,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // ---------- Success state ----------
            final weather = snapshot.data!;
            return ListView(
              children: [
                _DataCard(
                  icon: Icons.wb_sunny_outlined,
                  title: 'Current Conditions',
                  value: '${weather.temperatureC.toStringAsFixed(1)}°C',
                  subtitle: weather.condition,
                  color: Colors.orange,
                ),
                const SizedBox(height: 12),
                _DataCard(
                  icon: Icons.air,
                  title: 'Wind Speed',
                  value: '${weather.windSpeedKmh.toStringAsFixed(1)} km/h',
                  subtitle: 'Live data from Open-Meteo API',
                  color: kAccentBlue,
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton.icon(
                    onPressed: _retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 12, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                Container(width: 150, height: 10, color: Colors.grey.shade300),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _DataCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
      ),
    );
  }
}
