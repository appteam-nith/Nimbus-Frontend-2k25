import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_2K25/auth.dart';
import 'package:nimbus_2K25/pay_page.dart';

class ClubsList extends StatefulWidget {
  const ClubsList({super.key});

  @override
  State<ClubsList> createState() => _ClubsListState();
}

class _ClubsListState extends State<ClubsList> {
  final Dio _dio = Dio();
  bool isloading = true;
  List<dynamic> clubs = [];

  @override
  void initState() {
    super.initState();

    getclubs();
  }

  void getclubs() async {
    final url = 'https://nimbusbackend-l4ve.onrender.com/api/clubs';
    String? token = await AuthService.getToken();
    try {
      final response = await _dio.get(url,
          options: Options(headers: {'Authorization': "Bearer $token"}));
      if (response.statusCode == 200) {
        final data = response.data;
        print(data);
        setState(() {
          clubs = data;
          isloading = false;
        });
      } else {
        print("try again");
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
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)])),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: screenheight * 0.4,
                        width: screenwidth * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: AssetImage(
                                    "assets/Essential - money (PNG) (1).png"))),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: screenwidth * 0.2),
                        child: Container(
                          height: screenheight * 0.35,
                          width: screenwidth * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage(
                                      "assets/Essential - money (PNG) (1).png"))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SafeArea(
                      child: Text("PayZone",
                          style: GoogleFonts.inika(
                              fontSize: screenwidth * 0.065))),
                  Flexible(
                    child: isloading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(top: screenheight * 0),
                            shrinkWrap: true,
                            itemCount: clubs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenheight * 0.015,
                                      horizontal: screenheight * 0.015),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xff383838)
                                                .withOpacity(0.5),
                                            width: 3), // Bottom border
                                        left: BorderSide(
                                            color: Color(0xff383838)
                                                .withOpacity(0.5),
                                            width: 2), // Left border
                                        right: BorderSide(
                                            color: Color(0xff383838)
                                                .withOpacity(0.5),
                                            width: 2), // Right border
                                        top: BorderSide(
                                            color: Color(0xff383838)
                                                .withOpacity(0.5),
                                            width: 0.5), // No top border
                                      ), // Rounded corners
                                    ),
                                    // Background color
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Name text
                                          Text(
                                            clubs[index]["name"],
                                            style: GoogleFonts.domine(
                                              fontSize: 20,
                                            ),
                                          ),
                                          // PAY Button
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PayPage(
                                                              clubName:
                                                                  clubs[index]
                                                                      ["name"],
                                                              clubId: clubs[
                                                                      index]
                                                                  ["_id"])));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(
                                                  0xff3183B2), // Button color
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                            ),
                                            child: Text(
                                              "PAY",
                                              style: GoogleFonts.domine(
                                                fontSize: 16,
                                                color:
                                                    Colors.white, // Text color
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
