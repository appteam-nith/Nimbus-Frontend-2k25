import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart'; // Using Lottie instead of Flare
import 'quizz.dart'; // Ensure this file is present for quiz navigation

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List events = [];
  bool isLoading = true;
  bool hasError = false;

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
          events = response.data;
          isLoading = false;
          hasError = false;
        });
      }
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? buildLoadingAnimation()
          : hasError
              ? _buildErrorState()
              : _buildEventList(),
    );
  }

  // 📌 Event list UI
  Widget _buildEventList() {
    return Container(
      decoration: BoxDecoration(
        gradient:
            LinearGradient(colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return _buildEventCard(event);
          },
        ),
      ),
    );
  }

  // 📌 Event card UI
  Widget _buildEventCard(Map<String, dynamic> event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(eventId: event['eventId']),
          ),
        );
      },
      child: Card(
        color: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            color: Colors.white70,
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(Icons.event, color: Colors.white),
              ),
              title: Text(
                event['club'] ?? 'No Club',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                event['eventName'],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xff383838),
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Color(0xff383838)),
            ),
          ),
        ),
      ),
    );
  }

  // 🔴 Error state with retry button
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 50),
          SizedBox(height: 8),
          Text(
            "Failed to load events.",
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isLoading = true;
                hasError = false;
                fetchEvents();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }
}

Widget buildLoadingAnimation() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)]),
    ),
    child: Center(
      child: Lottie.asset(
        "assets/Animation - 1742550809348.json",
        height: 150,
        width: 150,
      ),
    ),
  );
}

Widget buildLoadingAnimation2() {
  return Container(
    color: Colors.transparent,
    height: 80,
    width: 120,
    child: FittedBox(
      fit: BoxFit.cover, // ✅ Keeps animation inside the container
      child: SizedBox(
        height: 80, // ✅ Forces correct height
        width: 120,
        child: Lottie.asset(
          "assets/Animation - 1742550809348.json",
        ),
      ),
    ),
  );
}
