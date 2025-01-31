import 'package:flutter/material.dart';
import 'package:nimbus_user/HomePage.dart';
import 'package:nimbus_user/all_transactions.dart';
import 'package:nimbus_user/clubs_list.dart';
import 'package:nimbus_user/login.dart';

class BottomNavigationBarpage extends StatefulWidget {
  const BottomNavigationBarpage({super.key});

  @override
  State<BottomNavigationBarpage> createState() => _HomepageState();
}

class _HomepageState extends State<BottomNavigationBarpage> {
  int _pageIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SignIn(),
    BalanceScreen(),
    ClubsList()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event, size: 30),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event, size: 30),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 30),
            label: 'Events',
          ),
        ],
      ),
    );
  }
}
