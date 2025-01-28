import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<String> images = [
    "assets/A modern conference room filled with attendees engaged in discussions about technology and innovation..png",
    "assets/A modern conference room filled with attendees engaged in discussions about technology and innovation..png",
    "assets/A modern conference room filled with attendees engaged in discussions about technology and innovation..png"
  ];

  List<String> titles = [
    "Title 1",
    "Title 2",
    "Title 3",
  ];

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: images.length,
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
                    height: screenheight * 0.2,
                    width: screenwidth,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                            image: AssetImage(images[index]),
                            fit: BoxFit.fitWidth)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: screenheight * 0.005,
                  left: screenheight * 0.03,
                ),
                child: Text(
                  titles[index],
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
                  titles[index],
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
