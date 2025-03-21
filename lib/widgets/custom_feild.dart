import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class buildTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final bool isPassword;
  final TextInputType keyboardType;

  const buildTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.validator,
    this.isPassword = false,
    required this.keyboardType,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<buildTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(35)),
      child: Container(
        color: const Color(0xffCFE7F4),
        width: screenWidth * 0.94,
        child: TextFormField(
          validator: widget.validator,
          obscureText: widget.isPassword ? _isObscured : false,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.label,
            hintStyle: GoogleFonts.domine(
              fontSize: 18,
              color: const Color(0xff14142E).withOpacity(0.7),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16),
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
            // 👁️ Eye Icon to Toggle Password Visibility
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured; // Toggle visibility
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
