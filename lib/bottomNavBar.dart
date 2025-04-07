import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_2K25/HomePage.dart';
import 'package:nimbus_2K25/bingo.dart';
import 'package:nimbus_2K25/clubs_list.dart';
import 'package:nimbus_2K25/widgets/events.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavigationBarPage extends StatefulWidget {
  const BottomNavigationBarPage({super.key});

  @override
  State<BottomNavigationBarPage> createState() => _HomepageState();
}

class _HomepageState extends State<BottomNavigationBarPage> {
  int _pageIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    EventPage(),
    ClubsList(),
    Bingo(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_pageIndex],
      bottomNavigationBar: Container(
        height: screenHeight * 0.085, // Increased height for better spacing
        decoration: const BoxDecoration(
          color:
              Color.fromARGB(255, 42, 42, 42), // Fixed Navbar Background Color
          borderRadius: BorderRadius.only(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SalomonBottomBar(
            currentIndex: _pageIndex,
            onTap: (index) => setState(() => _pageIndex = index),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey.shade400,
            curve: Curves.easeInOut,
            itemShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            items: [
              _buildNavItem("assets/Icon (8).png", "Home", screenHeight),
              _buildNavItem("assets/image 5 (3).png", "Quiz", screenHeight),
              _buildNavItem("assets/icons8-pay-48 1.png", "Pay", screenHeight),
              _buildNavItem("assets/Icon (9).png", "Bingo", screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  SalomonBottomBarItem _buildNavItem(
      String icon, String title, double screenHeight) {
    return SalomonBottomBarItem(
      icon: Image.asset(icon, scale: screenHeight * 0.006), // Larger icon size
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: screenHeight * 0.015,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      selectedColor: Colors.white,
    );
  }
}
