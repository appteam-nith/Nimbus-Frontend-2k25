import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nimbus_2K25/auth.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  final Dio _dio = Dio();
  List<dynamic> transactions = [];
  bool isLoading = true;
  Map<String, String> clubNames = {}; // Store club names by receiverId

  @override
  void initState() {
    super.initState();
    getTransactionHistory();
  }

  Future<void> getTransactionHistory() async {
    String? userId = await AuthService.getId();
    final url = "https://nimbusbackend-l4ve.onrender.com/api/user/$userId";
    String? token = await AuthService.getToken();

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': "application/json",
        }),
      );

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> fetchedTransactions = response.data['transactions'] ?? [];

        setState(() {
          transactions = fetchedTransactions;
        });

        // Fetch club names for all unique receiverIds
        Set<String> receiverIds = fetchedTransactions
            .map((tx) => tx['receiverId'] as String?)
            .where((id) => id != null)
            .cast<String>()
            .toSet();

        await Future.wait(receiverIds.map((id) => fetchClubData(id)));

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching transactions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchClubData(String clubId) async {
    if (clubNames.containsKey(clubId)) return;

    final url = "https://nimbusbackend-l4ve.onrender.com/api/clubs/$clubId";
    String? token = await AuthService.getToken();

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': "application/json",
        }),
      );

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          clubNames[clubId] = response.data['name'] ?? "Unknown Club";
        });
      }
    } catch (e) {
      print("Error fetching club: $e");
    }
  }

  Widget _buildTransactionCard(String type, String amount, String timestamp,
      String sender, String receiverId) {
    bool isDebit = type.toLowerCase() == "user";

    // Parse timestamp safely
    DateTime? dateTime;
    try {
      dateTime = DateTime.parse(timestamp).toLocal();
    } catch (e) {
      dateTime = null;
    }
    String formattedTime = dateTime != null
        ? DateFormat('hh:mm a').format(dateTime)
        : "Invalid Date";

    // Get club name from the map
    String clubName = clubNames[receiverId] ?? "BankTeam";

    return Card(
      color: Colors.white38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 239, 239),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isDebit ? Icons.north_east : Icons.south_west,
                color: Colors.black,
                size: 30,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clubName,
                  style: GoogleFonts.inika(
                    color: const Color(0xff606060),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isDebit ? "Debit" : "Credit",
                  style: GoogleFonts.inika(
                      fontSize: 15,
                      color: isDebit
                          ? const Color(0xffE70000)
                          : const Color(0xff00C106)),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: GoogleFonts.inika(
                    color: isDebit
                        ? const Color(0xffE70000)
                        : const Color(0xff00C106),
                    fontSize: 20,
                  ),
                ),
                Text(
                  formattedTime,
                  style: GoogleFonts.inika(
                    color: const Color(0xff606060),
                    fontSize: 16,
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
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Center(
                child: Text(
                  "Transactions",
                  style: GoogleFonts.inika(fontSize: screenWidth * 0.065),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : transactions.isEmpty
                      ? const Center(
                          child: Text("No transactions found."),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenWidth * 0.03,
                          ),
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.01,
                              ),
                              child: _buildTransactionCard(
                                transaction["senderModel"] ?? "Unknown",
                                transaction["amount"].toString(),
                                transaction["timestamp"] ?? "N/A",
                                transaction["senderModel"] ?? "N/A",
                                transaction['receiverId'] ?? "N/A",
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
