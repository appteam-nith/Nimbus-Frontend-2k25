import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_user/HomePage.dart';
import 'package:nimbus_user/all_transactions.dart';
import 'package:nimbus_user/clubs_list.dart';
import 'package:nimbus_user/login.dart';
import 'package:nimbus_user/widgets/events.dart';
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
    // SignIn(),
    EventPage(),
    BalanceScreen(),
    ClubsList(),
  
    
  ];

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_pageIndex],
      bottomNavigationBar: Container(
        height: screenheight * 0.12,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255), // Navbar background color
        ),
        child: SalomonBottomBar(
          currentIndex: _pageIndex,
          onTap: (index) => setState(() => _pageIndex = index),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade400,
          curve: Curves.easeInOut,
          items: [
            SalomonBottomBarItem(
              icon:
                  Icon(Icons.home, color: Color(0xff14252E).withOpacity(0.62)),
              title: Text(
                "Home",
                style: GoogleFonts.domine(fontSize: screenheight * 0.015),
              ),
              selectedColor: Colors.black,
            ),
            SalomonBottomBarItem(
              icon:
                  Icon(Icons.event, color: Color(0xff14252E).withOpacity(0.62)),
              title: Text(
                "Events",
                style: GoogleFonts.domine(fontSize: screenheight * 0.015),
              ),
              selectedColor: Colors.black,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.account_balance_wallet,
                  color: Color(0xff14252E).withOpacity(0.62)),
              title: Text(
                "Balance",
                style: GoogleFonts.domine(fontSize: screenheight * 0.015),
              ),
              selectedColor: Colors.black,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.settings, color: Color(0xff14252E)),
              title: Text(
                "Settings",
                style: GoogleFonts.domine(fontSize: screenheight * 0.015),
              ),
              selectedColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
