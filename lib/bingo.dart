import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flip_card/flip_card.dart';
import 'package:nimbus_2K25/auth.dart';
import 'package:nimbus_2K25/qrview.dart';
import 'package:dio/dio.dart';
import 'package:nimbus_2K25/widgets/events.dart';

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
      fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: buildLoadingAnimation(),
              )
            : tasks.isEmpty
                ? _buildNoTasksUI() // Call the method for UI when no tasks are assigned
                : Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              final taskId = task['_id'] ?? '';
                              final taskName = task['title'] ?? 'No title';
                              final taskDescription = task['description'] ?? '';
                              final qrCode = task['qrCode']['code'] ?? 'N/A';
                              final isCompleted = task['status'] == 'completed';

                              bool shouldFlip = isCompleted &&
                                  !completedTasks.contains(taskId);
                              if (shouldFlip) {
                                completedTasks.add(taskId);
                              }

                              return FlipCard(
                                key: ValueKey(taskId),
                                flipOnTouch: isCompleted,
                                front: _buildTaskCard(taskName, taskDescription,
                                    qrCode, isCompleted),
                                back: _buildCompletedCard(taskName),
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
      bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (Like Instagram Post)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // Task Icon
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    radius: 25,
                    child: Icon(Icons.task_alt, color: Colors.blue, size: 28),
                  ),
                  SizedBox(width: 10),
                  // Task Title
                  Expanded(
                    child: Text(
                      taskName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Status
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isCompleted ? "Completed" : "Pending",
                      style: TextStyle(
                        color: isCompleted ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Task Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/Beige Floral Page Border_20250304_223925_0000 1.png",
                width: double.infinity,
                height: 200,
                fit: BoxFit.fitHeight,
              ),
            ),

            // Task Description
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                isCompleted ? "This task has been completed." : taskDescription,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // QR Code Scanner Button
            if (!isCompleted)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: Icon(Icons.qr_code_scanner, color: Colors.white),
                    label:
                        Text("Scan QR", style: TextStyle(color: Colors.white)),
                    onPressed: () => openQRScanner(taskName, qrCode),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedCard(String taskName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Image.asset(
              "assets/Beige Floral Page Border_20250304_223925_0000 1.png",
              width: double.infinity,
              height: 200,
              fit: BoxFit.fitHeight,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Completed",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              taskName,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

Widget _buildNoTasksUI() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Task Empty Illustration

        SizedBox(height: 20),

        // Text Message
        Text(
          "No tasks assigned yet!",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 10),

        // Subtext
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Stay tuned! Once tasks are assigned, they will appear here.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    ),
  );
}
