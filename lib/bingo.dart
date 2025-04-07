import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flip_card/flip_card.dart';
import 'package:nimbus_2K25/.env';
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
        '${BackendUrl}/api/tasks/user/$userId',
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
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
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
                      // 🔹 Task Header
                      const SizedBox(height: 12),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Icon(Icons.star_rounded,
                                  color: Colors.black, size: 28),
                              const SizedBox(width: 8),
                              Text(
                                "Bingo",
                                style: GoogleFonts.inika(
                                  fontSize: screenwidth * 0.065,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: ListView.builder(
                            shrinkWrap: true,
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

  Widget _buildTaskCard(
    String taskName,
    String taskDescription,
    String qrCode,
    bool isCompleted,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFCE3EC), // Blush pink
              Color(0xFFFFF1E6), // Warm ivory
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: const Color.fromARGB(255, 31, 31, 31).withOpacity(0.08),
              width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header Section
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🧊 Sleek Glassy Icon Capsule
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.12), width: 0.6),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.task_alt_rounded,
                        color: Color.fromARGB(179, 0, 0, 0), size: 26),
                  ),
                  const SizedBox(width: 12),

                  // 🔤 Task Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          taskName,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 28, 28, 28),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isCompleted
                              ? "You’ve completed this task"
                              : "Pending task",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color.fromARGB(137, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔘 Status Tag
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orangeAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isCompleted ? "Completed" : "Pending",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isCompleted
                            ? const Color.fromARGB(255, 13, 125, 71)
                            : const Color.fromARGB(255, 143, 89, 19),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🖼 Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                "assets/Beige Floral Page Border_20250304_223925_0000 1.png",
                width: double.infinity,
                height: 180,
                fit: BoxFit.fitHeight,
              ),
            ),

            // 📝 Description
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
              child: Text(
                isCompleted
                    ? "🎉 This task has been successfully completed!"
                    : taskDescription,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: const Color.fromARGB(179, 11, 4, 4),
                  height: 1.4,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // 🔳 QR Scan Button
            if (!isCompleted)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () => openQRScanner(taskName, qrCode),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 14),
                      elevation: 4,
                      shadowColor: Colors.black54,
                    ),
                    icon:
                        const Icon(Icons.qr_code_scanner, color: Colors.white),
                    label: Text(
                      "Scan QR",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
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
