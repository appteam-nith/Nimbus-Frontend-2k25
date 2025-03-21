import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_2K25/auth.dart';
import 'package:nimbus_2K25/widgets/events.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  String? balance;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchBalance();
  }

  void fetchBalance() async {
    String? fetchedBalance = await AuthService.getbalance();
    setState(() {
      balance = fetchedBalance ?? "0";
      loading = false; // Default to "0" if null
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xffFFFFFF),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)])),
          child: loading
              ? buildLoadingAnimation()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenheight * 0.05,
                    ),
                    Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: screenwidth,
                              height: screenwidth * 0.5,
                            ),
                            SizedBox(
                                width: screenwidth,
                                height: screenwidth,
                                child: Image(
                                  image: AssetImage(
                                      "assets/Essential - money (PNG).png"),
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Card(
                                color: Colors.white38,
                                child: SizedBox(
                                  height: screenheight * 0.12,
                                  width: screenwidth * 0.94,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: screenwidth * 0.025,
                                            left: screenwidth * 0.05),
                                        child: Text("Total Balance",
                                            style: GoogleFonts.robotoSerif(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: screenwidth * 0.025,
                                            left: screenwidth * 0.05),
                                        child: Text(
                                          "\$ $balance",
                                          style: GoogleFonts.robotoSerif(
                                            fontSize: 34,
                                            color: Color(0xff00C106),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenheight * 0.005,
                            ),
                            Center(
                              child: Card(
                                color: Colors.white38,
                                child: SizedBox(
                                    height: screenheight * 0.12,
                                    width: screenwidth * 0.94,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: screenwidth * 0.025,
                                              left: screenwidth * 0.05),
                                          child: Text("Total Spends",
                                              style: GoogleFonts.robotoSerif(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: screenwidth * 0.025,
                                              left: screenwidth * 0.05),
                                          child: Text(
                                            "\$ .....",
                                            style: GoogleFonts.robotoSerif(
                                              fontSize: 34,
                                              color: const Color(0xffE70000),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
        ));
  }
  //
}
