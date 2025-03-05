import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildTextField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  FormFieldValidator<String>? validator,
  bool isPassword = false,
  required TextInputType keyboardType,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(35)),
    child: Container(
      color: Color(0xffCFE7F4),
      width: screenWidth * 0.94,
      child: TextFormField(
        validator: validator,
        obscureText: isPassword,
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: GoogleFonts.domine(
              fontSize: 18, color: Color(0xff14142E).withOpacity(0.7)),
          contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: const BorderSide(
              width: 2,
              color: Color.fromARGB(255, 255, 246, 236),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: const BorderSide(
              width: 2,
              color: Color.fromARGB(255, 255, 246, 236),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: const BorderSide(
              width: 0.5,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
      ),
    ),
  );
}
