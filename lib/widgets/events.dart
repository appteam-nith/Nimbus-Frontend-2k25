import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:dots_indicator/dots_indicator.dart';

import 'package:nimbus_2K25/.env';
import 'quizz.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List events = [];
  bool isLoading = true;
  bool hasError = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      var response = await Dio().get('${BackendUrl}/api/events');
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
              : _buildCarouselSlider(),
    );
  }

  Widget _buildCarouselSlider() {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.black, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    "Featured Quizzes",
                    style: GoogleFonts.inika(
                      fontSize: screenWidth * 0.065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: FlutterCarousel.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index, realIndex) {
                    final event = events[index];
                    return AnimatedScale(
                      scale: currentIndex == index ? 1.0 : 0.95,
                      duration: const Duration(milliseconds: 300),
                      child: _buildCarouselCard(event),
                    );
                  },
                  options: CarouselOptions(
                    height: 360,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    viewportFraction: 0.8,
                    showIndicator: false,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    onPageChanged: (index, reason) {
                      setState(() => currentIndex = index);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            DotsIndicator(
              dotsCount: events.length,
              position: currentIndex.toDouble(),
              decorator: DotsDecorator(
                activeColor: Colors.brown.shade800,
                color: Colors.brown.shade300,
                size: const Size.square(8.0),
                activeSize: const Size(12.0, 8.0),
                spacing: const EdgeInsets.symmetric(horizontal: 4.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselCard(Map<String, dynamic> event) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(eventId: event['eventId']),
          ),
        );
      },
      child: AnimatedContainer(
        width: screenwidth * 0.75,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInCubic,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.brown.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.brown.shade100,
              child: Icon(Icons.quiz, size: 30, color: Colors.brown.shade800),
            ),
            const SizedBox(height: 14),
            Text(
              event['club'] ?? 'No Club',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade900,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event['eventName'],
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.brown.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.brown.shade800, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 50),
          SizedBox(height: 8),
          Text(
            "Failed to load events.",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isLoading = true;
                hasError = false;
              });
              fetchEvents();
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
      fit: BoxFit.cover,
      child: SizedBox(
        height: 80,
        width: 120,
        child: Lottie.asset("assets/Animation - 1742550809348.json"),
      ),
    ),
  );
}
