// signup_screen.dart
// Real signup logic: validates required fields and persists new users via
// AuthService/StorageService (SharedPreferences). Shows an inline error on
// failure (evidence: signup_error.png) and navigates to Home on success.

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/error_feedback.dart';
import 'home_shell.dart';
import 'login_screen.dart';

const Color kPrimaryGreen = Color(0xFF00C896);
const Color kAccentBlue = Color(0xFF0575E6);
const Color kBackground = Color(0xFFF6F8FB);

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isSubmitting = false;
  String? errorMessage;

  Future<void> _handleSignup() async {
    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    final error = await AuthService.register(
      name: _nameController.text,
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (error != null) {
      setState(() {
        errorMessage = error;
        isSubmitting = false;
      });
      return;
    }

    // Success: go straight to the Home shell, same flow as the lab
    // (Register -> Home via pushReplacement).
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeShell(username: _usernameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.08),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.directions_run_rounded,
                        color: kPrimaryGreen, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Start your fitness journey today',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Error banner shown after a failed submission
                    if (errorMessage != null) InlineFormError(message: errorMessage!),

                    _labeledField(
                      label: 'Name',
                      hint: 'Enter your full name',
                      icon: Icons.person_outline,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 16),
                    _labeledField(
                      label: 'Username',
                      hint: 'Choose a username',
                      icon: Icons.alternate_email,
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 16),
                    _labeledField(
                      label: 'Email',
                      hint: 'you@example.com',
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _passwordField(),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: isSubmitting ? null : _handleSignup,
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Sign Up',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: const Text('Login',
                              style: TextStyle(color: kAccentBlue, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _labeledField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            filled: true,
            fillColor: kBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            hintText: 'Create a password',
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
              onPressed: () => setState(() => obscurePassword = !obscurePassword),
            ),
            filled: true,
            fillColor: kBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
