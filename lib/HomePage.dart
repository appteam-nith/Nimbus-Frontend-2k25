import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nimbus_2K25/auth.dart';
import 'package:nimbus_2K25/navbar.dart';
import 'package:nimbus_2K25/projects.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> event = [];
  final Dio _dio = Dio();
  String named = "";
  String emailed = "";
  bool isloading = true;
  String greeting = "";
  bool isUploadingImage = false;
  String errorMessage = '';
  final ImagePicker _picker = ImagePicker();
  String profile = "";

  @override
  void initState() {
    super.initState();
    fetchevents();
    greetings();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String? id = await AuthService.getId();
    final url = "https://nimbusbackend-l4ve.onrender.com/api/users/$id";
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
        final data = response.data;
        setState(() {
          named = data['name'];
          emailed = data['email'];
          profile = data['profilePicture'] ?? ""; // Fetch profile image
        });
        await AuthService.storeName(data['name']);
        await AuthService.storeEmail(data['email']);
        await AuthService.storebalance(data['balance'].toString());
      }
    } catch (e) {
      print("❌ Error fetching user data: $e");
    }
  }

  // Update profile picture in backend
  Future<void> updateProfileImage(String imageUrl) async {
    final url =
        "https://nimbusbackend-l4ve.onrender.com/api/users/profile/picture";
    String? token = await AuthService.getToken();

    try {
      final response = await _dio.post(
        url,
        data: {"imageUrl": imageUrl}, // Sending Image URL to backend
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': "application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          profile = imageUrl; // Update profile picture
        });
        print("✅ Profile updated successfully: $imageUrl");
      }
    } catch (e) {
      print("❌ Error updating profile image: $e");
    }
  }

  // Upload image to Imgur
  Future<void> uploadImageToImgur(File imageFile) async {
    const clientId = 'da93df6129d96c5'; // Replace with your Imgur client ID
    const url = 'https://api.imgur.com/3/upload';

    setState(() {
      isUploadingImage = true;
    });

    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path),
      });

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Client-ID $clientId',
          },
        ),
      );

      if (response.statusCode == 200) {
        final imageUrl = response.data['data']['link'];
        setState(() {
          profile = imageUrl;
        });
        await updateProfileImage(imageUrl); // Save URL to backend
      } else {
        setState(() {
          errorMessage = 'Failed to upload image.';
        });
      }
    } catch (e) {
      print("❌ Error uploading image: $e");
    }

    setState(() {
      isUploadingImage = false;
    });
  }

  Future<void> fetchevents() async {
    final url = 'https://nimbus-inventoey-backend-25.onrender.com/api/events';

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          event = data['event'];
          isloading = false;
        });
      } else {
        print("Failed to load events: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "Good Morning";
    if (hour >= 12 && hour < 18) return "Good Afternoon";
    return "Good Evening";
  }

  void greetings() {
    setState(() {
      greeting = getGreeting();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName:
                  Text(named, style: GoogleFonts.domine(color: Colors.black)),
              accountEmail:
                  Text(emailed, style: GoogleFonts.domine(color: Colors.black)),
              currentAccountPicture: GestureDetector(
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    await uploadImageToImgur(File(pickedFile.path));
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: profile.isNotEmpty
                      ? CachedNetworkImageProvider(profile)
                      : AssetImage("assets/profile-circled.512x512.png")
                          as ImageProvider,
                ),
              ),
              decoration: BoxDecoration(color: Colors.white),
            ),
            ListTile(
              leading: FaIcon(Icons.history),
              title: Text('Transaction History',
                  style: GoogleFonts.domine(color: Colors.black)),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Navbar(selectedindex: 0))),
            ),
            ListTile(
              leading: FaIcon(Icons.account_balance),
              title: Text('Account Balance',
                  style: GoogleFonts.domine(color: Colors.black)),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Navbar(selectedindex: 1))),
            ),
            ListTile(
              leading: FaIcon(Icons.build),
              title: Text('Projects',
                  style: GoogleFonts.domine(color: Colors.black)),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProjectsPage())),
            ),
            ListTile(
              leading: FaIcon(Icons.logout),
              title: Text('Log Out',
                  style: GoogleFonts.domine(color: Colors.black)),
              onTap: () => AuthService.clearToken(context),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)])),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: screenheight * 0.1,
                      right: screenwidth * 0.02,
                      bottom: screenheight * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: screenheight * 0.4,
                        width: screenwidth * 0.75,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: screenwidth * 0.02,
                            ),
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.bars,
                                    size: screenwidth * 0.06,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: screenwidth * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenwidth * 0.04),
                    child: Text("$greeting, \n$named",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inika(
                            fontSize: screenwidth * 0.065,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenwidth * 0.05, top: screenheight * 0.03),
                    child: Text(
                      "Upcoming Events",
                      style: GoogleFonts.inika(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: Color(0xff40392B)),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenheight * 3,
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
                                  left: screenheight * 0.015,
                                  right: screenheight * 0.015,
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  child: Container(
                                    decoration:
                                        BoxDecoration(color: Colors.white38),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: isloading
                                          ? CircularProgressIndicator(
                                              color: Color(0xff383838),
                                            )
                                          : Container(
                                              height: screenheight * 0.25,
                                              width: screenwidth,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 119, 86, 86),
                                                  image: DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              event[index]
                                                                  ["image"]),
                                                      fit: BoxFit.fitHeight)),
                                            ),
                                    ),
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
                                      color:
                                          Color(0xff2E2514).withOpacity(0.5)),
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
                                  EdgeInsets.only(bottom: screenwidth * 0.32),
                              child: Container(
                                height: screenwidth * 0.5,
                                width: screenwidth * 0.25,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 133, 143, 153),
                                    borderRadius: BorderRadius.only(
                                        topRight:
                                            Radius.circular(screenwidth * 0.3),
                                        bottomRight: Radius.circular(
                                            screenwidth * 0.3))),
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
                              padding:
                                  EdgeInsets.only(top: screenheight * 0.25),
                              child: Container(
                                height: screenwidth * 0.5,
                                width: screenwidth * 0.25,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 133, 143, 153),
                                    borderRadius: BorderRadius.only(
                                        topLeft:
                                            Radius.circular(screenwidth * 0.4),
                                        bottomLeft: Radius.circular(
                                            screenwidth * 0.4))),
                              ),
                            )
                          ],
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: screenheight * 0.12),
                            child: Container(
                              height: screenwidth * 0.63,
                              width: screenwidth * 0.63,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 80, 109, 146),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(screenwidth * 0.5))),
                              child: Center(
                                child: Text(
                                  "Stay Tuned for\n latest \n Workshops and \n Events",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inika(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
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
      ),
    );
  }
}
//
