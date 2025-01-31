import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BalanceScreen(),
    );
  }
}

class BalanceScreen extends StatelessWidget {
  BalanceScreen({super.key});

  final List<Map<String, dynamic>> transactions = [
    {
      'date': 'Today',
      'data': [
        {'type': 'debit', 'amount': '-12.00 USD', 'time': '20:37'},
        {'type': 'credit', 'amount': '+12.00 USD', 'time': '20:37'},
        {'type': 'credit', 'amount': '+12.00 USD', 'time': '20:37'},
        {'type': 'debit', 'amount': '-12.00 USD', 'time': '20:37'},
      ]
    },
    {
      'date': 'Yesterday',
      'data': [
        {'type': 'debit', 'amount': '-12.00 USD', 'time': '20:37'},
        {'type': 'credit', 'amount': '+12.00 USD', 'time': '20:37'},
      ]
    },
    {
      'date': 'Day Before Yesterday',
      'data': [
        {'type': 'debit', 'amount': '-12.00 USD', 'time': '20:37'},
        {'type': 'credit', 'amount': '+12.00 USD', 'time': '20:37'},
      ]
    },
  ];

  Widget _buildTransactionCard(String type, String amount, String time) {
    bool isDebit = type == 'debit';
    return Card(
      color: Color(0xffCDC8C8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isDebit ? Icons.north_east : Icons.south_west,
                color: Colors.black,
                size: 30,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DSC",
                  style: GoogleFonts.inika(
                      color: Color(0xff606060),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  isDebit ? "Debit" : "Credit",
                  style: GoogleFonts.inika(
                      fontSize: 15,
                      color: isDebit
                          ? Color(0xffE70000)
                          : const Color(0xff00C106)),
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: GoogleFonts.inika(
                    color:
                        isDebit ? Color(0xffE70000) : const Color(0xff00C106),
                    fontSize: 20,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.inika(
                    color: Color(0xff606060),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: screenwidth * 0.2, left: screenwidth * 0.1),
              child: Text("Balance", style: GoogleFonts.inika(fontSize: 30)),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenwidth * 0.05,
                right: screenwidth * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: transactions.map((transaction) {
                  return Card(
                    color: Color(0xffF4F4F4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(transaction['date'],
                              style: GoogleFonts.inika(
                                color: Color(0xff555555),
                                fontSize: 24,
                              )),
                          SizedBox(height: 10),
                          ...List<Map<String, dynamic>>.from(
                                  transaction['data'])
                              .map((t) => _buildTransactionCard(
                                  t['type'], t['amount'], t['time']))
                              .toList(),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bottom Bar
          BottomAppBar(
            color: Color(0xffDAEBFF),
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Home Icon
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home, color: Color(0xff4A90E2), size: 30),
                        SizedBox(height: 4),
                        Text(
                          'Home',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff4A90E2)),
                        ),
                      ],
                    ),
                  ),
                  // Spacer for Central Button
                  Expanded(
                    child: SizedBox.shrink(),
                  ),
                  // Transactions Icon
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.swap_horiz,
                            color: Color(0xff555555).withOpacity(0.62),
                            size: 30),
                        SizedBox(height: 4),
                        Text(
                          'Transactions',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xff555555).withOpacity(0.62)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Central Circle Button
          Positioned(
            bottom: 50, // Adjust position above the bottom bar
            left: screenwidth * 0.4,
            child: GestureDetector(
              onTap: () {
                // Add your action here
              },
              child: ClipRRect(
                  child: Container(
                height: 98,
                width: 98,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xff4A90E2), width: 5),
                ),
                child: Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Color(0xff4A90E2),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255)!,
                        width: 5),
                  ),
                  child: Icon(Icons.add,
                      color: const Color.fromARGB(255, 11, 11, 11), size: 50),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
