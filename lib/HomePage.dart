// ignore: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_user/widgets/events.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenheight * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: screenheight * 0.4,
                      width: screenwidth * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage(
                                  "assets/Essential - a man holding phone and social icons around him (PNG) (1).png"))),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenheight * 0.4,
                width: screenwidth,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                            "assets/Essential - Emotion workflow man (PNG).png"))),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SafeArea(
                      child: Row(
                        children: [
                          Container(
                            height: screenheight * 0.06,
                            width: screenwidth * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image:
                                        AssetImage("assets/Mask group.png"))),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: screenwidth * 0.55),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.notifications_outlined,
                                  size: 30,
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenwidth * 0.05),
                  child: Text(
                    "Good Morning ,",
                    style: GoogleFonts.inika(
                        fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenwidth * 0.05),
                  child: Text(
                    "Avinash",
                    style: GoogleFonts.inika(
                        fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenwidth * 0.05, top: screenheight * 0.05),
                  child: Text(
                    "Upcoming Events",
                    style: GoogleFonts.inika(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xff40392B)),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight:
                        screenheight * 3, // Limit height to 50% of screen
                  ),
                  child: Events(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenwidth * 0.05, top: screenheight * 0.05),
                  child: Text(
                    "Upcoming Workshops",
                    style: GoogleFonts.inika(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xff40392B)),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight:
                        screenheight * 3, // Limit height to 50% of screen
                  ),
                  child: Events(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: screenwidth * 0.1),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: screenwidth * 0.25),
                            child: Container(
                              height: screenwidth * 0.5,
                              width: screenwidth * 0.25,
                              decoration: BoxDecoration(
                                  color: Color(0xffBCCBDC),
                                  borderRadius: BorderRadius.only(
                                      topRight:
                                          Radius.circular(screenwidth * 0.3),
                                      bottomRight:
                                          Radius.circular(screenwidth * 0.3))),
                            ),
                          ),
                          Container(
                            height: screenwidth * 0.4,
                            width: screenwidth * 0.5,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: screenheight * 0.25),
                            child: Container(
                              height: screenwidth * 0.5,
                              width: screenwidth * 0.25,
                              decoration: BoxDecoration(
                                  color: Color(0xffBCCBDC),
                                  borderRadius: BorderRadius.only(
                                      topLeft:
                                          Radius.circular(screenwidth * 0.4),
                                      bottomLeft:
                                          Radius.circular(screenwidth * 0.4))),
                            ),
                          )
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: screenheight * 0.12),
                          child: Container(
                            height: screenwidth * 0.65,
                            width: screenwidth * 0.65,
                            decoration: BoxDecoration(
                                color: Color(0xff597EAA),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(screenwidth * 0.5))),
                            child: Center(
                              child: Text(
                                "Stay Tuned for\n latest \n Workshops and \n Events",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inika(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
