import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_2K25/all_transactions.dart';
import 'package:nimbus_2K25/clubs_list.dart';
import 'package:nimbus_2K25/transactions.dart';

class Navbar extends StatefulWidget {
  final int selectedindex;
  const Navbar({super.key, required this.selectedindex});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late int _selectedIndex;
  final List<Widget> _pages = [
    const BalanceScreen(),
    const Transactions(),
    const ClubsList()
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedindex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: screenHeight * 0.12,
        decoration: BoxDecoration(
          color: const Color(0xff383838),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                  "assets/Icon (6).png", "Transactions", 0, screenWidth),
              const SizedBox(width: 70), // Space for FAB
              _buildNavItem(
                  "assets/pngegg (1) 1.png", "Balance", 1, screenWidth),
            ],
          ),
        ),
      ),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          color: const Color(0xff383838),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: 80,
              height: 80,
              child: FloatingActionButton(
                backgroundColor: const Color(0xff383838),
                shape: const CircleBorder(
                  side: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                elevation: 10,
                onPressed: () {
                  _onItemTapped(2); // Correctly switch to ClubsList page
                },
                child: const Icon(Icons.add, color: Colors.white, size: 40),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(
      String icon, String title, int index, double screenWidth) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(icon,
                scale: screenWidth * 0.008,
                color: isSelected ? Colors.white : Colors.grey.shade400),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
