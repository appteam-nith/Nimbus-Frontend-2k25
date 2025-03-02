import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nimbus_user/auth.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  final Dio _dio = Dio();
  List<dynamic> transactions = [];
  bool isLoading = true;
  bool isClubLoading = true; // Track club data loading state
  Map<String, String?> clubNames = {}; // Store club names by receiverId

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
      final response = await _dio.get(url,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': "application/json",
          }));

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          transactions = response.data['transactions'] ?? [];
        });

        // Fetch club data after transactions are fetched
        for (var transaction in transactions) {
          String receiverId = transaction['receiverId'];
          await fetchClubData(receiverId); // Fetch club data for each receiver
        }
        setState(() {
          isLoading = false; // Set loading to false after both data is fetched
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
    // Check if club data has already been fetched for this receiverId
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
        String clubName = response.data['name'] ?? "Unknown Club";
        setState(() {
          clubNames[clubId] = clubName;
        });
        print("✅ Club fetched successfully: $clubName");
      }
    } catch (e) {
      print("❌ Error fetching club: $e");
    }
  }

  Widget _buildTransactionCard(String type, String amount, String timestamp,
      String sender, String receiverId) {
    bool isDebit = type.toLowerCase() == "user";

    // Parse timestamp and format time
    DateTime dateTime = DateTime.parse(timestamp).toLocal();
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    // Get club name from the map if already fetched
    String clubName = clubNames[receiverId] ?? "BankTeam";

    return Card(
      color: Colors.white54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
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
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clubName, // Show the club name (either fetched or loading)
                  style: GoogleFonts.inika(
                    color: const Color(0xff606060),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // 
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
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Row(
                // 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SafeArea(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: screenWidth * 0.04),
                        child: Text(
                          "Transaction History",
                          style:
                              GoogleFonts.inika(fontSize: screenWidth * 0.065),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : transactions.isEmpty
                    ? Center(
                        child: const Text("No transactions found."),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenWidth * 0.03),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.01),
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
    );
  }
}
