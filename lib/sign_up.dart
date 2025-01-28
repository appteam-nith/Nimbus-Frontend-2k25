import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_user/widgets/custom_feild.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: screenheight * 0.18),
            child: Center(
              child: SizedBox(
                height: screenheight * 0.4,
                width: screenwidth * 0.8,
                child: Image(
                    fit: BoxFit.cover,
                    image: AssetImage(
                        "assets/Essential - a man holding phone and social icons around him (PNG) (5).png")),
              ),
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenheight * 0.15),
                  child: Text(
                    "Welcome to Archway",
                    style: GoogleFonts.inika(
                        fontWeight: FontWeight.bold,
                        fontSize: screenheight * 0.039),
                  ),
                ),
                Center(
                  child: Text(
                    "Sign Up to access your account",
                    style: GoogleFonts.domine(
                        fontWeight: FontWeight.w300, fontSize: 18.82),
                  ),
                ),
                SizedBox(
                  height: screenheight * 0.12,
                ),
                isLoading
                    ? CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : Form(
                        key: _formKey,
                        child: Column(children: [
                          // Username field
                          buildTextField(
                              context: context,
                              label: "Email",
                              controller: usernameController,
                              keyboardType: TextInputType.numberWithOptions()),
                          SizedBox(
                            height: screenheight * 0.015,
                          ),
                          buildTextField(
                              context: context,
                              label: "Username",
                              controller: usernameController,
                              keyboardType: TextInputType.numberWithOptions()),
                          SizedBox(
                            height: screenheight * 0.015,
                          ),
                          // Password field
                          buildTextField(
                              context: context,
                              label: "Password",
                              controller: passwordController,
                              keyboardType: TextInputType.numberWithOptions()),
                        ])),
                SizedBox(
                  height: screenheight * 0.06,
                  width: screenwidth * 0.9,
                  child: Image(
                      fit: BoxFit.contain,
                      image: AssetImage("assets/Divider.png")),
                ),
                SizedBox(
                  height: screenheight * 0.06,
                  width: screenwidth,
                  child: Image(
                      fit: BoxFit.contain,
                      image:
                          AssetImage("assets/buttonOutlinedStandard (2).png")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Already have an account?",
                      style: GoogleFonts.domine(
                          color: Color(0xff14142E).withOpacity(0.62),
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Sign In   ",
                        style: GoogleFonts.domine(
                            color: Color(0xffEE453C),
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                    )
                  ],
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: screenheight * 0.05),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(35)),
                    width: screenwidth * 0.9,
                    height: screenheight * 0.065,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffEE453C),
                        ),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(),
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.domine(
                                fontSize: 20, color: Color(0xffFAFAFF)),
                          ),
                        )),
                  ),
                ),
              ]),
        ],
      ),
    );
  }
}
