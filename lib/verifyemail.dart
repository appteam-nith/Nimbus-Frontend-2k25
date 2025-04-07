import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_2K25/.env';
import 'package:nimbus_2K25/login.dart';
import 'package:nimbus_2K25/widgets/events.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  final String username;
  final String password;
  final String roll;

  const VerifyEmailPage({
    super.key,
    required this.email,
    required this.username,
    required this.password,
    required this.roll,
  });

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _canResendEmail = true; // Track resend button state
  Timer? _timer;
  DateTime? _lastEmailSentTime; // Track last sent time
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _startEmailVerificationCheck();
  }

  // Check if email is verified every 3 seconds
  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _auth.currentUser?.reload();
      final user = _auth.currentUser;

      if (user != null && user.emailVerified) {
        timer.cancel(); // Stop checking when verified
        setState(() {});

        if (mounted) {
          await sendDataToBackend();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Your email has been verified!")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
          );
        }
      }
    });
  }

  // Send user data to backend after email verification
  Future<void> sendDataToBackend() async {
    String url = "${BackendUrl}/api/users/register";

    try {
      final response = await _dio.post(
        url,
        data: {
          "email": widget.email,
          "name": widget.username,
          "password": widget.password,
          "rollNo": widget.roll,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 201) {
        debugPrint("User registered in backend successfully");
      } else {
        throw Exception(response.data['message'] ?? "Registration failed");
      }
    } catch (e) {
      debugPrint("Backend error: $e");
    }
  }

  // Resend verification email with 30s cooldown
  Future<void> _resendVerificationEmail() async {
    final now = DateTime.now();

    if (_lastEmailSentTime != null &&
        now.difference(_lastEmailSentTime!).inSeconds < 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please wait 30 seconds before resending.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _canResendEmail = false;
    });

    try {
      await _auth.currentUser?.sendEmailVerification();
      _lastEmailSentTime = now; // Update last sent time

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Verification email resent. Please check your inbox.")),
      );

      // Reactivate button after 30 seconds
      Future.delayed(const Duration(seconds: 30), () {
        if (mounted) {
          setState(() => _canResendEmail = true);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop the timer when leaving the page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verify Your Email",
                style: GoogleFonts.inika(
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight * 0.039,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "A verification email has been sent to your email address.\nPlease check your inbox.",
                textAlign: TextAlign.center,
                style: GoogleFonts.domine(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              _isLoading
                  ? buildLoadingAnimation()
                  : SizedBox(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.065,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canResendEmail
                              ? const Color(0xffEE453C)
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                        onPressed:
                            _canResendEmail ? _resendVerificationEmail : null,
                        child: Text(
                          _canResendEmail
                              ? "Resend Verification Email"
                              : "Please wait...",
                          style: GoogleFonts.domine(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
