import 'package:flutter/material.dart';
import 'package:nimbus_user/all_transactions.dart';
import 'package:nimbus_user/transactions.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Navbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BalanceScreen(),
    const Transactions(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xffDAEBFF),
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                Icons.arrow_back_ios,
                "Transactions",
                0,
                isSelected: _selectedIndex == 0,
              ),
              const SizedBox(
                  width:
                      40), // This space will remain for the floating action button
              _buildNavItem(
                Icons.account_balance,
                "Balance",
                1,
                isSelected: _selectedIndex == 1,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff4A90E2),
        shape: const CircleBorder(),
        onPressed: () {
          // Add your action here
        },
        child: const Icon(Icons.add, color: Colors.white, size: 40),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// Builds a navigation item. If the label is "Transactions", it displays
  /// a column with a back arrow and a forward arrow.
  Widget _buildNavItem(IconData icon, String label, int pageIndex,
      {bool isSelected = false}) {
    Widget iconWidget;

    // For the "Transactions" tab, display two arrows in a column.
    if (label.toLowerCase() == "transactions") {
      iconWidget = Image(
          image: isSelected
              ? AssetImage("assets/Icon (3).png")
              : AssetImage("assets/Icon (1).png"));
    } else {
      // For other tabs, use the provided icon.
      iconWidget = Icon(
        icon,
        size: 30,
        color: isSelected
            ? const Color(0xff4A90E2)
            : const Color(0xff555555).withOpacity(0.62),
      );
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(pageIndex),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isSelected
                    ? const Color(0xff4A90E2)
                    : const Color(0xff555555).withOpacity(0.62),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
