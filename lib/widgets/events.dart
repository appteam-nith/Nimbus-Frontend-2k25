import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quizz.dart'; // Ensure this file is present for the quiz page navigation

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List events = [];
  bool isLoading = true; // To show a loading indicator while fetching events

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      var response =
          await Dio().get('https://nimbusbackend-l4ve.onrender.com/api/events');

      if (response.statusCode == 200) {
        setState(() {
          events = response.data; // Update events from API response
          isLoading = false; // Hide the loading indicator
        });
      }
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)]),
              ),
              child: Center(
                  child: CircularProgressIndicator(
                color: Color(0xff383838),
              ))) // Show loading indicator
          : Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)])),
              child: Column(
                children: [
                  SafeArea(
                      child: Text("Events",
                          style: GoogleFonts.inika(
                              fontSize: screenWidth * 0.065))),

                  // Events Grid
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GridView.builder(
                        padding: const EdgeInsets.only(top: 0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              screenWidth > 600 ? 2 : 1, // Responsive grid
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          final clubName = event['club'] ?? 'No Club';
                          final eventName = event['eventName'];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizPage(
                                      eventId:
                                          event['eventId']), // Pass eventId
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xff383838).withOpacity(0.5),
                                      width: 3), // Bottom border
                                  left: BorderSide(
                                      color: Color(0xff383838).withOpacity(0.5),
                                      width: 2), // Left border
                                  right: BorderSide(
                                      color: Color(0xff383838).withOpacity(0.5),
                                      width: 2), // Right border
                                  top: BorderSide(
                                      color: Color(0xff383838).withOpacity(0.5),
                                      width: 0.5), // No top border
                                ), // Round
                                color: Colors.transparent,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Circle Icon with gradient background
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color.fromARGB(
                                                255, 129, 124, 124),
                                            const Color.fromARGB(
                                                255, 23, 25, 26)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Icon(Icons.event,
                                          color: Colors.white, size: 30),
                                    ),
                                    SizedBox(width: 16),

                                    // Event Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            clubName,
                                            style: GoogleFonts.poppins(
                                              fontSize: screenHeight * 0.018,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            eventName,
                                            style: GoogleFonts.poppins(
                                              fontSize: screenHeight * 0.016,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Arrow for navigation
                                    Icon(Icons.arrow_forward_ios,
                                        color: Colors.black54, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
