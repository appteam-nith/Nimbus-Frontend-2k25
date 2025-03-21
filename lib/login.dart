import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_2K25/auth.dart';
import 'package:nimbus_2K25/bottomNavBar.dart';
import 'package:nimbus_2K25/sign_up.dart';
import 'package:nimbus_2K25/widgets/custom_feild.dart';
import 'package:nimbus_2K25/widgets/events.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  // Login Function
  Future<void> loginUser(String email, String password) async {
    final url = "https://nimbusbackend-l4ve.onrender.com/api/users/login";

    try {
      final response = await _dio.post(
        url,
        data: {"email": email, "password": password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        print(response.data);
        String token = response.data['accessToken'];
        String role = response.data['user']['role'];

        print("Login successful");
        if (token.isNotEmpty) {
          print("access token is ${token}");
          await AuthService.storeToken(token, role);
          await AuthService.storeId(response.data['user']['id']);
        } else {
          print("⚠️ Token is null or empty!");
        }

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => BottomNavigationBarPage()),
        );
      } else {
        throw Exception(response.data['message'] ?? "Login failed");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed. Check credentials.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      resizeToAvoidBottomInset: false, // ✅ Fix keyboard overflow issue
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.15),
            child: Text(
              "Welcome to Archway",
              style: GoogleFonts.inika(
                fontWeight: FontWeight.bold,
                fontSize: screenHeight * 0.039,
              ),
            ),
          ),
          Text(
            "Sign In to access your account",
            style: GoogleFonts.domine(
                fontWeight: FontWeight.w300, fontSize: 18.82),
          ),
          // SizedBox(height: screenHeight * 0.05),

          // ✅ Form for Email and Password
          Stack(children: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.07),
              child: Center(
                child: SizedBox(
                  height: screenHeight * 0.32,
                  width: screenWidth * 0.8,
                  child: Image.asset(
                    "assets/Essential - a man holding phone and social icons around him (PNG) (5).png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    children: [
                      buildTextField(
                        label: "Email",
                        controller: emailController,
                        keyboardType: TextInputType
                            .emailAddress, // ✅ Corrected input type
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      buildTextField(
                        isPassword: true,
                        label: "Password",
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ]),
          // Padding(
          //   padding: EdgeInsets.only(top: screenHeight * 0.07),
          //   child: Center(
          //     child: SizedBox(
          //       height: screenHeight * 0.32,
          //       width: screenWidth * 0.8,
          //       child: Image.asset(
          //         "assets/Essential - a man holding phone and social icons around him (PNG) (5).png",
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(height: screenHeight * 0.03),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: GoogleFonts.domine(
                  color: Color(0xff14142E).withOpacity(0.62),
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
                child: Text(
                  "Sign Up",
                  style: GoogleFonts.domine(
                    color: Color(0xffEE453C),
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          // ✅ Sign In Button
          Padding(
            padding: EdgeInsets.only(
                bottom: screenHeight * 0.05, top: screenHeight * 0.01),
            child: Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.065,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(35)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLoading ? Colors.grey : Color(0xffEE453C),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          loginUser(
                              emailController.text, passwordController.text);
                        }
                      },
                child: isLoading
                    ? buildLoadingAnimation() // ✅ Show loading indicator
                    : Text(
                        "Sign In",
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
    );
  }
}
//
