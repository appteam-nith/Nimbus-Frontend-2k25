import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_2K25/.env';
import 'package:nimbus_2K25/auth.dart';
import 'package:nimbus_2K25/paymentsuccess.dart';
import 'package:nimbus_2K25/widgets/events.dart';

class PayPage extends StatefulWidget {
  final String clubName;
  final String clubId;
  final String clubImage;

  const PayPage(
      {super.key,
      required this.clubName,
      required this.clubId,
      required this.clubImage});

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  final TextEditingController _amountController = TextEditingController();
  final Dio _dio = Dio();
  bool _isLoading = false;
  int userBalance = 0; // Store user balance

  @override
  void initState() {
    super.initState();
    _fetchUserBalance(); // Fetch balance when screen loads
  }

  Future<void> _fetchUserBalance() async {
    String? userId = await AuthService.getId();
    String? token = await AuthService.getToken(); // Fetch the token
    print("Token: $token");
    final url = "${BackendUrl}/api/users/$userId";

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Pass the token here
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          userBalance = response.data['balance'] ?? 0;
        });
      }
      print("Balance: $userBalance");
    } catch (e) {
      print("Error fetching balance: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch balance: $e')),
      );
    }
  }

  Future<void> _payToClub(String clubId, int amount) async {
    String? id = await AuthService.getId();
    if (amount > userBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient balance!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = "${BackendUrl}/api/transactions/transfer-to-club";

    try {
      final response = await _dio.post(
        url,
        data: {
          "userId": id,
          "clubId": clubId,
          "amount": amount,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final transactionId = response.data['transactionId'] ?? 'N/A';
        final newBalance = userBalance - amount;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessPage(
              amount: amount,
              clubName: widget.clubName,
              transactionId: transactionId,
              newBalance: newBalance,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Not enough balance!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not enough balance!')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)])),
          child: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                size: 30,
              ), // Change this to any icon you want
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: SafeArea(
                child: Text("PayToClub",
                    style: GoogleFonts.inika(fontSize: screenWidth * 0.065))),
            centerTitle: true,
            actions: [],
          ),
        ),
      ),
      backgroundColor: const Color(0xffFFFFFF),
      body: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)])),
        child: Stack(
          children: [
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         Container(
            //           height: screenHeight * 0.4,
            //           width: screenWidth * 0.8,
            //           decoration: BoxDecoration(
            //               color: Colors.transparent,
            //               image: DecorationImage(
            //                   fit: BoxFit.fitWidth,
            //                   image: AssetImage(
            //                       "assets/Essential - money (PNG) (1).png"))),
            //         ),
            //       ],
            //     ),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Padding(
            //           padding: EdgeInsets.only(left: screenWidth * 0.2),
            //           child: Container(
            //             height: screenHeight * 0.35,
            //             width: screenWidth * 0.8,
            //             decoration: BoxDecoration(
            //                 color: Colors.transparent,
            //                 image: DecorationImage(
            //                     fit: BoxFit.fitWidth,
            //                     image: AssetImage(
            //                         "assets/Essential - money (PNG) (1).png"))),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.04),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xff383838).withOpacity(0.7),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.all(Radius.circular(screenWidth * 0.5)),
                      child: Image(
                          fit: BoxFit.fitWidth,
                          image: CachedNetworkImageProvider(widget.clubImage)),
                    ),
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
                Container(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), // Subtle background
                    border: Border.all(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      hintStyle: GoogleFonts.inika(
                        color: Colors.white54,
                        fontSize: 22,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12), // Better spacing
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Balance : $userBalance",
                  style: GoogleFonts.inika(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
                _isLoading ? buildLoadingAnimation() : const SizedBox(),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.08),
                  child: SizedBox(
                    width: screenWidth,
                    height: screenHeight * 0.06,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                final inputText = _amountController.text.trim();
                                final amount = int.tryParse(inputText);

                                if (amount == null || amount <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please enter a valid amount'),
                                    ),
                                  );
                                  return;
                                }

                                _payToClub(widget.clubId, amount);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3183B2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
