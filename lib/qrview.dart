import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_2K25/auth.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  final String taskName;
  final String qrCode; // Task name passed from previous page

  QRViewExample({required this.taskName, required this.qrCode});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedData = "";
  bool isProcessing = false; // Prevent multiple API calls

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!isProcessing) {
        setState(() {
          scannedData = scanData.code ?? "";
          isProcessing = true; // Prevent duplicate requests
        });

        if (scannedData == widget.taskName) {
          await completeTask(widget.qrCode);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("QR Code does not match the task name!"),
              backgroundColor: Colors.orange,
            ),
          );
        }

        // Resume scanning after processing
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          isProcessing = false;
        });
      }
    });
  }

  Future<void> completeTask(String qrCode) async {
    try {
      String? token = await AuthService.getToken();
      var response = await Dio().post(
        'https://nimbusbackend-l4ve.onrender.com/api//tasks/complete',
        data: {"qrCode": qrCode},
        options: Options(headers: {'Authorization': "Bearer $token"}),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Task Completed: ${response.data['message']}",
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TaskCompletedScreen(reward: response.data["task"]['reward']),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error completing task"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 30,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            // Add QR icon
            SizedBox(width: 8), // Space between icon and text
            Text(
              "Scan QR Code for ${widget.taskName}",
              style:
                  GoogleFonts.inika(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Icon(Icons.qr_code_scanner, color: Colors.black),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
                if (isProcessing)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                scannedData.isNotEmpty
                    ? 'Scanned: $scannedData'
                    : 'Scan QR Code For Completing the task',
                style: GoogleFonts.labrada(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskCompletedScreen extends StatelessWidget {
  final int reward;

  TaskCompletedScreen({required this.reward});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 196, 195, 195),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 30,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            // Add QR icon
            SizedBox(width: 8), // Space between icon and text
            Text(
              "Successfully Completed Task !!",
              style:
                  GoogleFonts.inika(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Icon(Icons.thumb_up_rounded, color: Colors.black),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.celebration, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              "Congratulations!",
              style: GoogleFonts.k2d(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "You have successfully completed the task.",
              style: GoogleFonts.k2d(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Reward: \$${reward}",
              style: GoogleFonts.k2d(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
