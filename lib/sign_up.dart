import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_user/login.dart';
import 'package:nimbus_user/widgets/custom_feild.dart';
import 'package:dio/dio.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  Future<void> registerUser(
      String email, String username, String password) async {
    final url = "https://nimbusbackend-l4ve.onrender.com/api/users/register";

    try {
      setState(() => isLoading = true);

      final response = await _dio.post(
        url,
        data: {
          "email": email,
          "name": username,
          "password": password,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration successful!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      } else {
        throw Exception(response.data['message'] ?? "Registration failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // ✅ Fix keyboard overflow issue
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        SizedBox(height: screenHeight*0.1,),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: Text(
                "Welcome to Archway",
                style: GoogleFonts.inika(
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight * 0.039,
                ),
              ),
            ),
            Text(
              "Sign Up to access your account",
              style:
                  GoogleFonts.domine(fontWeight: FontWeight.w300, fontSize: 18),
            ),
            SizedBox(height: screenHeight * 0.05),
        
            isLoading
                ? CircularProgressIndicator(color: Colors.black)
                : Stack(
        
        
                  children: [
                    Center(
              child: SizedBox(
                height: screenHeight * 0.32,
                width: screenWidth * 0.8,
                child: Image.asset(
                  "assets/Essential - a man holding phone and social icons around him (PNG) (5).png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
                    
                    Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              buildTextField(
                                context: context,
                                label: "Email",
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress, // ✅ Fixed
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              buildTextField(
                                context: context,
                                label: "Username",
                                controller: usernameController,
                                keyboardType: TextInputType.text, // ✅ Fixed
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              buildTextField(
                                context: context,
                                label: "Password",
                                controller: passwordController,
                                keyboardType: TextInputType.text, // ✅ Fixed
                              ),
                            ],
                          ),
                        ),
                      ),]
                  ),]
                ),
            SizedBox(height: screenHeight * 0.01),
            // Center(
            //   child: SizedBox(
            //     height: screenHeight * 0.32,
            //     width: screenWidth * 0.8,
            //     child: Image.asset(
            //       "assets/Essential - a man holding phone and social icons around him (PNG) (5).png",
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
        
            SizedBox(height: screenHeight * 0.01),
        
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  child: Text(
                    "Sign In",
                    style: GoogleFonts.domine(
                      color: Color(0xffEE453C),
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
        
            // ✅ Sign-Up Button with API Call
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
                            registerUser(
                              emailController.text,
                              usernameController.text,
                              passwordController.text,
                            );
                          }
                        },
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Sign Up",
                          style: GoogleFonts.domine(
                              fontSize: 20, color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
