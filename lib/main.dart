import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nimbus_2K25/auth.dart';
import 'package:nimbus_2K25/bottomNavBar.dart';
import 'package:nimbus_2K25/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 1));
    bool isLoggedIn = await _checkIfLoggedIn();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isLoggedIn ? const BottomNavigationBarPage() : const SignIn(),
        ),
      );
    }
  }

  Future<bool> _checkIfLoggedIn() async {
    String? token = await AuthService.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/Beige Floral Page Border_20250304_223925_0000 1 (1).png',
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}
