import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final Dio dio = Dio();
  List<dynamic> events = [];

  @override
  void initState() {
    super.initState();
    fetchevents(); // Fetch token when the page is loaded
  }

  Future<void> fetchevents() async {
    final url = 'https://nimbus-inventoey-backend-25.onrender.com/api/events';

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          events =
              data['event']; // Assuming the response contains 'event' field
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
    return ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: events.length,
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
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  child: Container(
                    height: screenheight * 0.25,
                    width: screenwidth,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                events[index]["image"]),
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
                  events[index]["name"],
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
                  '${events[index]["date"]} ${events[index]["time"]}',
                  style: GoogleFonts.inika(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      // ignore: deprecated_member_use
                      color: Color(0xff2E2514).withOpacity(0.5)),
                ),
              ),
            ],
          );
        });
  }
}
