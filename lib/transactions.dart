import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xffFFFFFF),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: screenwidth * 0.05,
                  top: screenwidth * 0.1,
                  left: screenwidth * 0.1),
              child:
                  Text("Redeem Coins", style: GoogleFonts.inika(fontSize: 30)),
            ),
            Stack(
              children: [
                SizedBox(
                    width: screenwidth,
                    height: screenwidth,
                    child: Image(
                      image: AssetImage("assets/Essential - money (PNG).png"),
                    )),
                Row(
                  children: [
                    SizedBox(
                        width: screenwidth * 0.45,
                        child: Image(
                          image: AssetImage("assets/Ellipse 873 (1).png"),
                        )),
                    SizedBox(
                        width: screenwidth * 0.55,
                        child: Image(
                            image:
                                AssetImage("assets/Rectangle 4191 (1).png"))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Card(
                        color: Color(0xffE2EFFF),
                        child: SizedBox(
                          height: screenheight * 0.12,
                          width: screenwidth * 0.9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  "\$ 12,345.67",
                                  style: GoogleFonts.robotoSerif(
                                    fontSize: 34,
                                    color: Color(0xff69FFA7),
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
                      height: screenheight * 0.02,
                    ),
                    Center(
                      child: Card(
                        color: Color(0xffE2EFFF),
                        child: SizedBox(
                            height: screenheight * 0.12,
                            width: screenwidth * 0.9,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    "\$ 12,345.67",
                                    style: GoogleFonts.robotoSerif(
                                      fontSize: 34,
                                      color: Color(0xffFF8585),
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
        ));
  }
}
