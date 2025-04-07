import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nimbus_2K25/.env';
import 'package:nimbus_2K25/auth.dart';
import 'package:nimbus_2K25/navbar.dart';
import 'package:nimbus_2K25/projects.dart';
import 'package:nimbus_2K25/widgets/events.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
// Removed incorrect import for flutter_carousel_slider indicator

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
  int currentIndex = 0; // Define currentIndex

  @override
  void initState() {
    super.initState();
    fetchevents();
    greetings();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String? id = await AuthService.getId();
    final url = "${BackendUrl}/api/users/$id";
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
    final url = "${BackendUrl}/api/users/profile/picture";
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
            Column(
              children: [
                _buildHeaderImage(screenwidth, screenheight),
                _buildSecondImage(screenheight, screenwidth),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildAppBarWithKey(screenwidth),
                      ],
                    ),
                    _buildGreeting(screenwidth),
                  ],
                ),
                _buildUpcomingEvents(screenheight, screenwidth),
                SizedBox(height: screenheight * 0.03),
                _buildStayTunedSection(screenwidth),
              ],
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
        padding: EdgeInsets.symmetric(
            horizontal: screenwidth * 0.02, vertical: screenwidth * 0.02),
        child: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: FaIcon(
            FontAwesomeIcons.bars,
            size: screenwidth * 0.055,
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
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  greeting,
                  style: GoogleFonts.inika(
                    fontSize: screenwidth * 0.065,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: screenwidth * 0.1,
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
      ),
    );
  }

  /// 🎠 Upcoming Events Section using flutter_carousel_slider
  Widget _buildUpcomingEvents(double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenHeight * 0.02),
            child: Text(
              "Upcoming Events",
              style: GoogleFonts.inika(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: const Color(0xff40392B),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          /// ✅ Carousel with auto-slide and indicator dots
          SizedBox(
            height: screenHeight * 0.42,
            child: CarouselSlider.builder(
              itemCount: event.length,
              unlimitedMode: true,
              viewportFraction: 0.85,
              initialPage: 0,
              enableAutoSlider: true, // 🔁 Enable auto sliding
              autoSliderDelay: const Duration(seconds: 3),
              slideTransform: const DefaultTransform(),
              slideIndicator: CircularSlideIndicator(
                padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                indicatorRadius: 4,
                itemSpacing: 12,
                currentIndicatorColor: const Color(0xff40392B),
                indicatorBackgroundColor: const Color(0xffd1c9bb),
              ),
              slideBuilder: (index) {
                final eventData = event[index];
                return _buildEventCard(eventData, screenHeight, screenWidth);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(
      Map<String, dynamic> eventData, double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(16),
        shadowColor: Colors.black26,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: Colors.white,
            child: isloadingImage
                ? Container(
                    color: Colors.grey[300],
                    child: Center(child: buildLoadingAnimation()),
                  )
                : CachedNetworkImage(
                    imageUrl: eventData["image"].toString(),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) =>
                        Center(child: buildLoadingAnimation()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
          ),
        ),
      ),
    );
  }

  /// 🌸 Updated Side Background Shapes (Now visible & elegant)
  Widget _buildSideShapes(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCircularSideDecoration(isLeft: true, screenWidth: screenWidth),
        _buildCircularSideDecoration(isLeft: false, screenWidth: screenWidth),
      ],
    );
  }

  Widget _buildCircularSideDecoration({
    required bool isLeft,
    required double screenWidth,
  }) {
    return Container(
      height: screenWidth * 0.22,
      width: screenWidth * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xffD4B4BD).withOpacity(0.65), // slightly stronger pink
            const Color(0xffBFAE99).withOpacity(0.55), // mild beige
          ],
          begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
          end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.horizontal(
          left: isLeft ? Radius.circular(screenWidth * 0.3) : Radius.zero,
          right: isLeft ? Radius.zero : Radius.circular(screenWidth * 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
    );
  }

  /// 🌟 Stay Tuned Circular Center (Slightly Enhanced)
  Widget _buildStayTunedSection(double screenWidth) {
    final double containerSize = screenWidth * 0.38;

    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.06),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildSideShapes(screenWidth),
          Container(
            height: containerSize,
            width: containerSize,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff354D5B),
                  Color(0xff1B2B34)
                ], // dark but smooth
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "Stay Tuned\nfor Workshops & Events",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inika(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.041,
                    height: 1.3,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
