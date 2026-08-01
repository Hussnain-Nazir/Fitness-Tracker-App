// settings_screen.dart
// This is the file to link for the "settings screen implementation"
// checklist item (evidence-settings-screen.png). Profile fields load from
// and save to real local storage via StorageService.

import 'package:flutter/material.dart';
import '../services/storage_service.dart';

const Color kPrimaryGreen = Color(0xFF00C896);
const Color kBackground = Color(0xFFF6F8FB);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool isLoading = true;
  bool justSaved = false;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final ageController = TextEditingController();
  String selectedCountry = 'Australia';

  final List<String> countries = const [
    'Australia',
    'United States',
    'United Kingdom',
    'Canada',
    'Pakistan',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await StorageService.getProfile();
    final dark = await StorageService.getDarkMode();
    if (!mounted) return;
    setState(() {
      nameController.text = profile['name']!;
      usernameController.text = profile['username']!;
      ageController.text = profile['age']!;
      selectedCountry = profile['country']!;
      darkMode = dark;
      isLoading = false;
    });
  }

  Future<void> _save() async {
    await StorageService.saveProfile(
      name: nameController.text,
      username: usernameController.text,
      age: ageController.text,
      country: selectedCountry,
    );
    await StorageService.setDarkMode(darkMode);

    if (!mounted) return;
    setState(() => justSaved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved to local storage.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: kBackground,
        body: Center(child: CircularProgressIndicator(color: kPrimaryGreen)),
      );
    }

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        title: const Text('Settings',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionHeader(title: 'Personal Info'),
            Card(
              elevation: 1,
              shadowColor: Colors.black.withOpacity(0.05),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _field(label: 'Name', controller: nameController, icon: Icons.person_outline),
                    const SizedBox(height: 14),
                    _field(
                        label: 'Username',
                        controller: usernameController,
                        icon: Icons.alternate_email),
                    const SizedBox(height: 14),
                    _field(
                        label: 'Age',
                        controller: ageController,
                        icon: Icons.cake_outlined,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.public, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedCountry,
                            decoration: InputDecoration(
                              labelText: 'Country',
                              filled: true,
                              fillColor: kBackground,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: countries
                                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (value) => setState(() => selectedCountry = value!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _SectionHeader(title: 'Preferences'),
            Card(
              elevation: 1,
              shadowColor: Colors.black.withOpacity(0.05),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Switch between light and dark theme'),
                secondary: const Icon(Icons.dark_mode_outlined),
                activeThumbColor: kPrimaryGreen,
                value: darkMode,
                onChanged: (value) => setState(() => darkMode = value),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _save,
              child: const Text('Save Changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: kBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.grey)),
    );
  }
}
