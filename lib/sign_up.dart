import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_2K25/login.dart';
import 'package:nimbus_2K25/verifyemail.dart';
import 'package:nimbus_2K25/widgets/custom_feild.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Dio _dio = Dio();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Function to register user in Firebase and send verification email
  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // Create user with Firebase
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Send email verification
      User? user = userCredential.user;
      await user?.sendEmailVerification();

      // Show email verification message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification email sent. Please check your inbox."),
        ),
      );

      // Navigate to verification page
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyEmailPage(
                    email: emailController.text.trim(),
                    username: usernameController.text.trim(),
                    roll: rollController.text.trim(),
                    password: passwordController.text.trim(),
                  )),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.2),
              Text(
                "Welcome to Archway",
                style: GoogleFonts.inika(
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight * 0.039,
                ),
              ),
              Text(
                "Sign Up to access your account",
                style: GoogleFonts.domine(
                    fontWeight: FontWeight.w300, fontSize: 18),
              ),
              SizedBox(height: screenHeight * 0.05),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextField(
                      label: "Email",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    buildTextField(
                      label: "Username",
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your username'
                          : null,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    buildTextField(
                      label: "Roll Number",
                      controller: rollController,
                      keyboardType: TextInputType.text,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your roll number'
                          : null,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    buildTextField(
                      label: "Password",
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter your password';
                        if (value.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: GoogleFonts.domine(
                        color: Colors.black.withOpacity(0.62),
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.domine(
                          color: const Color(0xffEE453C),
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                child: SizedBox(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.065,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isLoading ? Colors.grey : const Color(0xffEE453C),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                    ),
                    onPressed: isLoading ? null : registerUser,
                    child: Text(
                      isLoading ? "Processing..." : "Sign Up",
                      style:
                          GoogleFonts.domine(fontSize: 20, color: Colors.white),
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
