import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_user/auth.dart';
import 'package:nimbus_user/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> event = [];
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchevents();
  }

  Future<void> fetchevents() async {
    final url = 'https://nimbus-inventoey-backend-25.onrender.com/api/events';

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          event = data['event'];
        });
      } else {
        print("Failed to load events: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      drawer: Container(
        height: screenheight,
        width: screenwidth * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  'John Doe',
                  style: GoogleFonts.domine(color: Colors.black),
                ),
                accountEmail: Text('john.doe@example.com',
                    style: GoogleFonts.domine(color: Colors.black)),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/Ellipse 390 (2).png'),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                leading: FaIcon(Icons.history),
                title: Text(
                  'Transaction History',
                  style: GoogleFonts.domine(color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Navbar()));
                },
              ),
              ListTile(
                leading: FaIcon(Icons.account_balance),
                title: Text(
                  'Account Balance',
                  style: GoogleFonts.domine(color: Colors.black),
                ),
                onTap: () => {},
              ),
              ListTile(
                leading: FaIcon(Icons.settings),
                title: Text(
                  'Settings',
                  style: GoogleFonts.domine(color: Colors.black),
                ),
                onTap: () => {},
              ),
              ListTile(
                leading: FaIcon(Icons.developer_board),
                title: Text(
                  'Developers',
                  style: GoogleFonts.domine(color: Colors.black),
                ),
                onTap: () => {},
              ),
              ListTile(
                leading: FaIcon(Icons.logout),
                title: Text(
                  'Log Out',
                  style: GoogleFonts.domine(color: Colors.black),
                ),
                onTap: () => {AuthService.clearToken(context)},
              ),
            ],
          ),
        ),
      ),
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
                height: screenheight * 0.3,
                width: screenwidth * 0.8,
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
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          // Padding(
                          //   padding: EdgeInsets.only(left: screenwidth * 0.45),
                          // child:
                          //  IconButton(
                          //     onPressed: () {},
                          //     icon: Icon(
                          //       Icons.notifications_outlined,
                          //       size: screenwidth * 0.07,
                          //     )),
                          // ),
                          SizedBox(
                            width: screenwidth * 0.5,
                          ),
                          Builder(
                            builder: (context) {
                              return IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                icon: FaIcon(FontAwesomeIcons.bars,
                                    size: screenwidth * 0.06),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //       left: screenwidth * 0.05, top: screenwidth * 0.05),
                //   child: Text(
                //     "Good Morning ,",
                //     style: GoogleFonts.inika(
                //         fontWeight: FontWeight.bold, fontSize: 26),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(left: screenwidth * 0.05),
                //   child: Text(
                //     "Avinash",
                //     style: GoogleFonts.inika(
                //         fontWeight: FontWeight.bold, fontSize: 26),
                //   ),
                // ),
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
                    maxHeight: screenheight * 3,
                  ),
                  child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: event.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenheight * 0.02,
                                left: screenheight * 0.03,
                                right: screenheight * 0.03,
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                child: Container(
                                  height: screenheight * 0.25,
                                  width: screenwidth,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              event[index]["image"]),
                                          fit: BoxFit.fitHeight)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenheight * 0.005,
                                left: screenheight * 0.03,
                              ),
                              child: Text(
                                event[index]["name"],
                                style: GoogleFonts.inika(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xff40392B)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenheight * 0.005,
                                left: screenheight * 0.03,
                              ),
                              child: Text(
                                '${event[index]["date"]} ${event[index]["time"]}',
                                style: GoogleFonts.inika(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xff2E2514).withOpacity(0.5)),
                              ),
                            ),
                          ],
                        );
                      }),
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
