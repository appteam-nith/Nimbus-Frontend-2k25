import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dio/dio.dart';
import 'package:nimbus_2K25/login.dart';
import 'package:nimbus_2K25/widgets/custom_feild.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  bool isPasswordVisible = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rollController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  Future<void> registerUser() async {
    final url = "https://nimbusbackend-l4ve.onrender.com/api/users/register";

    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await _dio.post(
        url,
        data: {
          "email": emailController.text.trim(),
          "name": usernameController.text.trim(),
          "password": passwordController.text.trim(),
          "rollNo": rollController.text.trim(),
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      } else {
        throw Exception(response.data['message'] ?? "Registration failed");
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Error: ${e.response?.data['message'] ?? e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected error: $e")),
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
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.22,
                    width: screenWidth * 0.8,
                  ),
                  Image.asset(
                    "assets/Essential - a man holding phone and social icons around him (PNG) (5).png",
                    height: screenHeight * 0.40,
                    width: screenWidth,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.15),
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
                  SizedBox(height: screenHeight * 0.15),
                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: screenWidth * 0.005,
                      children: [
                        buildTextField(
                          context: context,
                          label: "Email",
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please enter your email';
                            if (!RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        buildTextField(
                          context: context,
                          label: "Username",
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please enter your username';
                            return null;
                          },
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        buildTextField(
                          context: context,
                          label: "Roll Number",
                          controller: rollController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please enter your roll number';
                            return null;
                          },
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        buildTextField(
                          context: context,
                          label: "Password",
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          isPassword: true,
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
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()),
                          );
                        },
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.domine(
                            color: const Color(0xffEE453C),
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
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
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                        onPressed: isLoading ? null : registerUser,
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.domine(
                              fontSize: 20,
                              color:
                                  isLoading ? Colors.black : Color(0xffFAFAFF)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
