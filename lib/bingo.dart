import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_2K25/auth.dart';
import 'package:nimbus_2K25/qrview.dart';
import 'package:flip_card/flip_card.dart';

class Bingo extends StatefulWidget {
  const Bingo({super.key});

  @override
  _BingoState createState() => _BingoState();
}

class _BingoState extends State<Bingo> {
  List tasks = [];
  bool isLoading = true;
  Set<String> completedTasks = {};

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    String? userId = await AuthService.getId();
    String? userToken = await AuthService.getToken();

    try {
      var response = await Dio().get(
        'https://nimbusbackend-l4ve.onrender.com/api/tasks/user/$userId',
        options: Options(headers: {'Authorization': "Bearer $userToken"}),
      );

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          tasks = response.data['tasks'] ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void openQRScanner(String taskName, String qrCode) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRViewExample(taskName: taskName, qrCode: qrCode),
      ),
    );

    if (result == true) {
      fetchTasks(); // Refreshes the task list when coming back
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)],
          ),
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(color: Color(0xff383838)),
              )
            : Column(
                children: [
                  SafeArea(
                    child: Text(
                      "Bingo",
                      style: GoogleFonts.inika(fontSize: screenWidth * 0.065),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 0),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final taskId = task['_id'] ?? '';
                          final taskName = task['title'] ?? 'No title';
                          final taskDescription = task['description'] ?? '';
                          final qrCode = task['qrCode']['code'] ?? 'N/A';
                          final isCompleted = task['status'] == 'completed';

                          bool shouldFlip =
                              isCompleted && !completedTasks.contains(taskId);
                          if (shouldFlip) {
                            completedTasks.add(taskId);
                          }

                          return FlipCard(
                            key: ValueKey(taskId),
                            flipOnTouch: isCompleted,
                            front: _buildTaskCard(taskName, taskDescription,
                                qrCode, screenHeight, screenWidth, isCompleted),
                            back: _buildCompletedCard(
                                taskName, screenHeight, screenWidth),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTaskCard(String taskName, String taskDescription, String qrCode,
      double screenHeight, double screenWidth, bool isCompleted) {
    return Card(
      color: Colors.grey[300],
      elevation: 5,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/Beige Floral Page Border_20250304_223925_0000 1.png",
              height: screenHeight * 0.3,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              taskName,
              style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.02,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              isCompleted ? "Completed" : "${taskDescription}",
              style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.018,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            if (!isCompleted)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      openQRScanner(taskName, qrCode);
                    },
                    child: Container(
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.qr_code_scanner,
                          color: Colors.black, size: 30),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedCard(
      String taskName, double screenHeight, double screenWidth) {
    return Card(
      color: Colors.green[300],
      elevation: 5,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/Beige Floral Page Border_20250304_223925_0000 1.png",
              height: screenHeight * 0.3,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "Completed",
              style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.02,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              taskName,
              style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.018,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
