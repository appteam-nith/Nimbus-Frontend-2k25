import 'package:flutter/material.dart';
import 'package:nimbus_2K25/auth.dart';
import 'package:nimbus_2K25/bottomNavBar.dart';
import 'package:nimbus_2K25/login.dart';

void main() {
  runApp(const MyApp());
}

//
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: EventPage()

      home: const SplashScreen(), // Start with SplashScreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Zoom-in animation
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward(); // Start animation

    _navigateAfterDelay(); // Handle navigation
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2)); // Wait for splash
    bool isLoggedIn = await _checkIfLoggedIn(); // Check login status

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isLoggedIn ? const BottomNavigationBarPage() : const SignIn(),
          // BottomNavigationBarPage(),
          // EventPage()
        ),
      );
    }
  }

  Future<bool> _checkIfLoggedIn() async {
    String? token = await AuthService.getToken(); // Use AuthService

    debugPrint("Token found !!"); // Debugging log

    return token != null && token.isNotEmpty;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Image.asset(
            'assets/Beige Floral Page Border_20250304_223925_0000 1 (1).png', // Ensure this asset exists
            height: 150,
            width: 150,
          ),
        ),
      ),
    );
  }
}
