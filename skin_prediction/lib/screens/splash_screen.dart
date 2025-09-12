import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'auth_screen.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      final isLoggedIn = await AuthService.isLoggedIn();
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.health_and_safety,
              size: 100,
              color: Colors.blue.shade600,
            ),
            const SizedBox(height: 20),
            Text(
              'Skin Disease Prediction',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'AI-Powered Skin Analysis',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(
              color: Colors.blue.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
