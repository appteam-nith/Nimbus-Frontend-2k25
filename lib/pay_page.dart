import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PayPage extends StatefulWidget {
  final String clubName;
  final String clubId;

  const PayPage({
    super.key,
    required this.clubName,
    required this.clubId,
  });

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  final TextEditingController _amountController = TextEditingController();
  final Dio _dio = Dio();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> payToClub(String clubId, int amount) async {
    setState(() {
      _isLoading = true;
    });

    final url =
        "https://nimbusbackend-l4ve.onrender.com/api/transactions/transfer-to-club";

    try {
      final response = await _dio.post(
        url,
        data: {
          "rollNo": "2055", // Replace with a dynamic value if needed
          "clubId": clubId,
          "amount": amount,
        },
        options: Options(headers: {'Content-Typ': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData['message'] ?? 'Payment successful')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${response.statusMessage}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.8,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage(
                              "assets/Essential - money (PNG) (1).png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: screenWidth * 0.2),
                        child: Center(
                          child: Text(
                            "Pay",
                            style: GoogleFonts.inika(fontSize: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenWidth * 0.19),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xff3183B2),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Image(image: AssetImage("assets/Ellipse 390 (2).png")),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Paying",
                textAlign: TextAlign.center,
                style: GoogleFonts.inika(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                widget.clubName,
                textAlign: TextAlign.center,
                style: GoogleFonts.inika(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  hintStyle: GoogleFonts.inika(
                    color: Colors.grey.shade500,
                    fontSize: 24,
                  ),
                  border: InputBorder.none,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.13,
              ),
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : Text(
                      "hello",
                      style: TextStyle(color: Colors.white),
                    ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.08),
                child: SizedBox(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            final inputText = _amountController.text.trim();
                            final amount = int.tryParse(inputText);

                            if (amount == null || amount <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a valid amount'),
                                ),
                              );
                              return;
                            }

                            payToClub(widget.clubId, amount);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3183B2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Proceed To Pay",
                        style: GoogleFonts.inika(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
