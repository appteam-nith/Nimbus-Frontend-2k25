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
import 'package:nimbus_2K25/widgets/events.dart';

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
  bool isLoadingName = true;
  bool isloadingImage = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        setState(() {
          isLoadingName = false;
        });
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
        });

        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            isloadingImage = false;
          });
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
      key: _scaffoldKey,
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)],
          ),
        ),
        child: Stack(
          children: [
            // Column(
            //   children: [
            //     _buildHeaderImage(screenwidth, screenheight),
            //     _buildSecondImage(screenheight, screenwidth),
            //   ],
            // ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBarWithKey(screenwidth),
                  _buildGreeting(screenwidth),
                  _buildUpcomingEvents(screenheight, screenwidth),
                  _buildStayTunedSection(screenwidth),
                  Container(
                    height: screenheight * 0.3,
                    width: screenwidth,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)],
                      ),
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

  /// 🎨 **Header Image Section**
  Widget _buildHeaderImage(double screenwidth, double screenheight) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenheight * 0.1,
        right: screenwidth * 0.02,
        bottom: screenheight * 0.05,
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Image.asset(
          "assets/Essential - a man holding phone and social icons around him (PNG) (1).png",
          width: screenwidth * 0.75,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  /// 🎨 **Second Image Below**
  Widget _buildSecondImage(double screenheight, double screenwidth) {
    return Image.asset(
      "assets/Essential - Emotion workflow man (PNG).png",
      height: screenheight * 0.3,
      width: screenwidth * 0.8,
      fit: BoxFit.fitWidth,
    );
  }

  /// 🎨 **App Bar with Drawer Toggle using GlobalKey**
  Widget _buildAppBarWithKey(double screenwidth) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenwidth * 0.02),
        child: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: FaIcon(
            FontAwesomeIcons.bars,
            size: screenwidth * 0.06,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  /// 🎨 **Greeting Section**
  Widget _buildGreeting(double screenwidth) {
    return Padding(
      padding: EdgeInsets.all(screenwidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: GoogleFonts.inika(
              fontSize: screenwidth * 0.065,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: screenwidth * 0.065, // Ensures proper alignment
            child: isLoadingName
                ? buildLoadingAnimation2()
                : Text(
                    named,
                    style: GoogleFonts.inika(
                      fontSize: screenwidth * 0.065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// 🎨 **Upcoming Events Section**
  Widget _buildUpcomingEvents(double screenheight, double screenwidth) {
    return Padding(
      padding: EdgeInsets.only(top: screenheight * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenheight * 0.02),
            child: Text(
              "Upcoming Events",
              style: GoogleFonts.inika(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: Color(0xff40392B),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenheight * 3),
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: event.length,
              itemBuilder: (context, index) {
                return _buildEventItem(event[index], screenheight, screenwidth);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 🎨 **Single Event Card**
  Widget _buildEventItem(
      Map<String, dynamic> eventData, double screenheight, double screenwidth) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenheight * 0.02,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          color: Colors.white38,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: SizedBox(
              height: screenheight * 0.25,
              width: screenwidth,
              child: isloadingImage
                  ? Container(
                      color: Colors.grey[300], // Background for loader
                      child: Center(child: buildLoadingAnimation()),
                    )
                  : Image(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          eventData["image"].toString()), // ✅ Safe conversion
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🎨 **Stay Tuned Section**
  Widget _buildStayTunedSection(double screenwidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenwidth * 0.1),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildSideShapes(screenwidth),
          Container(
            height: screenwidth * 0.63,
            width: screenwidth * 0.63,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 80, 109, 146),
              borderRadius: BorderRadius.circular(screenwidth * 0.5),
            ),
            child: Center(
              child: Text(
                "Stay Tuned for\n latest \n Workshops and \n Events",
                textAlign: TextAlign.center,
                style: GoogleFonts.inika(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🎨 **Side Background Shapes**
  Widget _buildSideShapes(double screenwidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCircularSideDecoration(isLeft: true, screenwidth: screenwidth),
        _buildCircularSideDecoration(isLeft: false, screenwidth: screenwidth),
      ],
    );
  }

  Widget _buildCircularSideDecoration(
      {required bool isLeft, required double screenwidth}) {
    return Container(
      height: screenwidth * 0.5,
      width: screenwidth * 0.25,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 133, 143, 153),
        borderRadius: BorderRadius.horizontal(
          left: isLeft ? Radius.circular(screenwidth * 0.4) : Radius.zero,
          right: isLeft ? Radius.zero : Radius.circular(screenwidth * 0.4),
        ),
      ),
    );
  }
}
