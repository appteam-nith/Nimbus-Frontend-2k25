// ignore: file_names
// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nimbus_user/auth.dart';
import 'package:nimbus_user/navbar.dart';
import 'package:nimbus_user/widgets/events.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> events = [];
  List<dynamic> event = [];
  final Dio _dio = Dio();
  String? ROLE = '';
  String selectedImageUrl = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    fetchevent();
    fetchevents();
  }

  Future<void> fetchevents() async {
    final url = 'https://nimbus-inventoey-backend-25.onrender.com/api/events';

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          event = data['event']; // Assuming the response contains 'event' field
        });
      } else {
        print("Failed to load events: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }

  // Method to add event via API
  Future<void> _addEvent(Map<String, String> eventData) async {
    final apiUrl =
        "https://nimbusbackend-l4ve.onrender.com/api/events"; // Replace with your actual API URL
    final Dio _dio = Dio();
    String? token = await AuthService.getToken();

    try {
      final response = await _dio.post(
        apiUrl,
        data: eventData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Using token
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Event added successfully!");
        fetchevent();
      } else {
        print("Failed to add event: ${response.statusCode}");
      }
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  Future<void> fetchevent() async {
    final url = 'https://nimbusbackend-l4ve.onrender.com/api/events';
    String? role = await AuthService.getRole();

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          events = data;
          // Assuming the response contains 'event' field
        });
        ROLE = role;
        print(events);
        print(role);
      } else {
        print("Failed to load events: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }

  static const String clientId = 'da93df6129d96c5';

  final TextEditingController nameController = TextEditingController();

  // Function to upload an image to Imgur
  Future<String> uploadImageToImgur(File image) async {
    try {
      final uri = Uri.parse('https://api.imgur.com/3/image');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Client-ID $clientId'
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      // Send the request and get the response
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(responseData.body);
        return data['data']['link']; // Return the image URL
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  // Method to show the dialog for adding an event
  void _showChangeDialog(String clubAdminId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Add Event',
          style: GoogleFonts.inclusiveSans(fontSize: 24),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Event Name Input Field
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 0),
                    labelText: "Event Name",
                    labelStyle: GoogleFonts.poppins(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),

                // // Image Upload Section
                // GestureDetector(
                //   onTap: () async {
                //     final pickedFile =
                //         await _picker.pickImage(source: ImageSource.gallery);
                //     if (pickedFile != null) {
                //       setState(() {
                //         selectedImageUrl = "Uploading..."; // Show loading
                //       });

                //       // Upload the selected image to Imgur
                //       File imageFile = File(pickedFile.path);
                //       String uploadedImageUrl =
                //           await uploadImageToImgur(imageFile);

                //       setState(() {
                //         selectedImageUrl = uploadedImageUrl;
                //       });
                //     }
                //   },
                //   child: Container(
                //     margin: EdgeInsets.symmetric(vertical: 20),
                //     width: 100,
                //     height: 100,
                //     decoration: BoxDecoration(
                //       color: Colors.grey[200],
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     child: Center(
                //       child: selectedImageUrl == "Uploading..."
                //           ? CircularProgressIndicator(
                //               color: Colors.black) // Loading indicator
                //           : selectedImageUrl.isNotEmpty
                //               ? CachedNetworkImage(
                //                   imageUrl: selectedImageUrl,
                //                   fit: BoxFit.cover,
                //                   height: 60,
                //                   width: 60,
                //                   placeholder: (context, url) => Center(
                //                     child: CircularProgressIndicator(),
                //                   ),
                //                   errorWidget: (context, url, error) =>
                //                       Icon(Icons.error, color: Colors.red),
                //                 )
                //               : Icon(Icons.image,
                //                   size: 40), // Default image icon
                //     ),
                //   ),
                // ),

                // Date Picker
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                      labelStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text(
                      selectedDate != null
                          ? DateFormat('dd MMM').format(selectedDate!)
                          : "Select a date", // Custom date format (06 Jan)
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Time Picker
                GestureDetector(
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null && pickedTime != selectedTime) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Select Time',
                      labelStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text(
                      selectedTime != null
                          ? DateFormat('hh:mm a').format(DateTime(0, 0, 0,
                              selectedTime!.hour, selectedTime!.minute))
                          : "Select a time", // Custom time format (09:00 PM)
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black),
            ),
          ),
          // Submit Button
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final imageUrl = selectedImageUrl.trim();
              final date = selectedDate != null
                  ? DateFormat('dd MMM').format(selectedDate!)
                  : null;
              final time = selectedTime != null
                  ? DateFormat('hh:mm a').format(DateTime(
                      0, 0, 0, selectedTime!.hour, selectedTime!.minute))
                  : null;

              if (name.isNotEmpty && date != null && time != null) {
                // Call the API to add the new event
                final newEvent = {
                  '_id': clubAdminId,
                  'name': name,
                  'description': '$date $time'
                };

                // Add the new event and refresh the event list
                await _addEvent(newEvent);

                nameController.clear;

                // Close the dialog
                Navigator.of(context).pop();

                // Refresh the events list
                fetchevent();
              } else {
                // Show error if any field is missing
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all fields!')),
                );
              }
            },
            child: Text(
              "Submit",
              style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      drawer: Container(
        height: screenheight,
        width: screenwidth * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  'John Doe',
                  style: GoogleFonts.domine(color: Colors.black),
                ),
                accountEmail: Text('john.doe@example.com',
                    style: GoogleFonts.domine(color: Colors.black)),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/Ellipse 390 (2).png'),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                leading: FaIcon(Icons.history),
                title: Text(
                  'Transaction History',
                  style: GoogleFonts.domine(color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Navbar()));
                },
              ),
              ListTile(
                leading: FaIcon(Icons.account_balance),
                title: Text(
                  'Acoout Balance',
                  style: GoogleFonts.domine(color: Colors.black),
                ),
                onTap: () => {},
              ),
              ListTile(
                leading: FaIcon(Icons.settings),
                title: Text(
                  'Settings',
                  style: GoogleFonts.domine(color: Colors.black),
                ),
                onTap: () => {},
              ),
              ListTile(
                leading: FaIcon(Icons.developer_board),
                title: Text(
                  'Developers',
                  style: GoogleFonts.domine(color: Colors.black),
                ),
                onTap: () => {},
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenheight * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: screenheight * 0.4,
                      width: screenwidth * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage(
                                  "assets/Essential - a man holding phone and social icons around him (PNG) (1).png"))),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenheight * 0.3,
                width: screenwidth * 0.8,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                            "assets/Essential - Emotion workflow man (PNG).png"))),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SafeArea(
                      child: Row(
                        children: [
                          Container(
                            height: screenheight * 0.06,
                            width: screenwidth * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image:
                                        AssetImage("assets/Mask group.png"))),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: screenwidth * 0.45),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.notifications_outlined,
                                  size: screenwidth * 0.07,
                                )),
                          ),
                          Builder(
                            builder: (context) {
                              return IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                icon: FaIcon(FontAwesomeIcons.bars,
                                    size: screenwidth * 0.06),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenwidth * 0.05, top: screenwidth * 0.05),
                  child: Text(
                    "Good Morning ,",
                    style: GoogleFonts.inika(
                        fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenwidth * 0.05),
                  child: Text(
                    "Avinash",
                    style: GoogleFonts.inika(
                        fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenwidth * 0.05, top: screenheight * 0.05),
                  child: Text(
                    "Upcoming Events",
                    style: GoogleFonts.inika(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xff40392B)),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight:
                        screenheight * 3, // Limit height to 50% of screen
                  ),
                  child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: event.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenheight * 0.02,
                                left: screenheight * 0.03,
                                right: screenheight * 0.03,
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                child: Container(
                                  height: screenheight * 0.25,
                                  width: screenwidth,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              event[index]["image"]),
                                          fit: BoxFit.fitHeight)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenheight * 0.005,
                                left: screenheight * 0.03,
                              ),
                              child: Text(
                                event[index]["name"],
                                style: GoogleFonts.inika(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xff40392B)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenheight * 0.005,
                                left: screenheight * 0.03,
                              ),
                              child: Text(
                                '${event[index]["date"]} ${event[index]["time"]}',
                                style: GoogleFonts.inika(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    // ignore: deprecated_member_use
                                    color: Color(0xff2E2514).withOpacity(0.5)),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: screenwidth * 0.05, top: screenheight * 0.05),
                      child: Text(
                        "Upcoming Clubs Workshops",
                        style: GoogleFonts.inika(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xff40392B)),
                      ),
                    ),
                    if (ROLE == "clubAdmin")
                      Padding(
                          padding: EdgeInsets.only(
                              left: screenwidth * 0.05,
                              top: screenheight * 0.05),
                          child: IconButton(
                              onPressed: () {
                                _showChangeDialog("679cc585da460f33363d9abe");
                              },
                              icon: Icon(
                                Icons.add,
                                size: 30,
                                weight: 400,
                              ))),
                  ],
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight:
                        screenheight * 3, // Limit height to 50% of screen
                  ),
                  child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenheight * 0.02,
                                left: screenheight * 0.03,
                                right: screenheight * 0.03,
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                child: Container(
                                  height: screenheight * 0.25,
                                  width: screenwidth,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              "https://media.istockphoto.com/id/2078490118/photo/businessman-using-laptop-to-online-payment-banking-and-online-shopping-financial-transaction.webp?a=1&b=1&s=612x612&w=0&k=20&c=gFVtiayH02VWwnw3auJt-duSGp-kM4ZLu9OCPvHHNrU="),
                                          fit: BoxFit.fitHeight)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenheight * 0.005,
                                left: screenheight * 0.03,
                              ),
                              child: Text(
                                events[index]["name"],
                                style: GoogleFonts.inika(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xff40392B)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenheight * 0.005,
                                left: screenheight * 0.03,
                              ),
                              child: Text(
                                '${events[index]["description"]}}',
                                style: GoogleFonts.inika(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    // ignore: deprecated_member_use
                                    color: Color(0xff2E2514).withOpacity(0.5)),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: screenwidth * 0.1),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: screenwidth * 0.25),
                            child: Container(
                              height: screenwidth * 0.5,
                              width: screenwidth * 0.25,
                              decoration: BoxDecoration(
                                  color: Color(0xffBCCBDC),
                                  borderRadius: BorderRadius.only(
                                      topRight:
                                          Radius.circular(screenwidth * 0.3),
                                      bottomRight:
                                          Radius.circular(screenwidth * 0.3))),
                            ),
                          ),
                          Container(
                            height: screenwidth * 0.4,
                            width: screenwidth * 0.5,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: screenheight * 0.25),
                            child: Container(
                              height: screenwidth * 0.5,
                              width: screenwidth * 0.25,
                              decoration: BoxDecoration(
                                  color: Color(0xffBCCBDC),
                                  borderRadius: BorderRadius.only(
                                      topLeft:
                                          Radius.circular(screenwidth * 0.4),
                                      bottomLeft:
                                          Radius.circular(screenwidth * 0.4))),
                            ),
                          )
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: screenheight * 0.12),
                          child: Container(
                            height: screenwidth * 0.65,
                            width: screenwidth * 0.65,
                            decoration: BoxDecoration(
                                color: Color(0xff597EAA),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(screenwidth * 0.5))),
                            child: Center(
                              child: Text(
                                "Stay Tuned for\n latest \n Workshops and \n Events",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inika(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
