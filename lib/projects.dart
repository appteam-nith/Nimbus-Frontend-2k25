import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nimbus_2K25/auth.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  Future<List<dynamic>> fetchProjects() async {
    String? token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('https://nimbusbackend-l4ve.onrender.com/api/projects'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data['projects']);
      return data['projects'];
    } else {
      throw Exception('Failed to load projects');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)])),
        child: Column(
          children: [
            SafeArea(
              child: Center(
                child: Text(
                  "Projects",
                  style: GoogleFonts.inika(fontSize: screenwidth * 0.065),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: fetchProjects(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No projects found'));
                  }

                  final projects = snapshot.data!;
                  return ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                              // Club Info (Similar to Instagram Header)
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    // Club Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.network(
                                        project['clubImage'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    // Club Name
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          project['clubName'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${project['startDate'].substring(0, 10)} - ${project['endDate'].substring(0, 10)}',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    // Status Chip
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: project['status'] == 'completed'
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.orange.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        project['status'].toUpperCase(),
                                        style: TextStyle(
                                          color:
                                              project['status'] == 'completed'
                                                  ? Colors.green
                                                  : Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Project Image
                              if (project['imageUrl'] != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    project['imageUrl'],
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.contain,
                                  ),
                                ),

                              // Project Title
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  project['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // Project Description
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  project['description'],
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                  maxLines: 4, // Show only a few lines
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              // Expand Button (To Show Full Description)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16)),
                                      ),
                                      builder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: SingleChildScrollView(
                                            child: Text(
                                              project['description'],
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Read More",
                                      style: TextStyle(color: Colors.blue)),
                                ),
                              ),

                              // Divider
                              Divider(height: 1, color: Colors.grey[300]),

                              // Buttons (Like, Comment, Share)
                            ],
                          ),
                        ),
                      );
                    },
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
