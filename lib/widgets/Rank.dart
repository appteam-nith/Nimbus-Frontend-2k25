import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaderboardScreen extends StatefulWidget {
  final String quizId;

  const LeaderboardScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Winner> winners = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchWinners();
  }

  Future<void> fetchWinners() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://nimbusbackend-l4ve.onrender.com/api/quiz/${widget.quizId}/winners'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Winner> loadedWinners = (data['winners'] as List)
            .map((winner) => Winner.fromJson(winner))
            .toList()
          ..sort((a, b) => b.score.compareTo(a.score));

        setState(() {
          winners = loadedWinners;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load leaderboard. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred. Check your internet connection.';
      });
      print('Error fetching winners: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenheight * 0.06),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)])),
          child: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                size: 30,
              ), // Change this to any icon you want
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: SafeArea(
                child: Text("LeaderBoard",
                    style: GoogleFonts.inika(fontSize: screenwidth * 0.065))),
            centerTitle: true,
            actions: [],
          ),
        ),
      ),
      body: isLoading
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)]),
              ),
              child: const Center(child: CircularProgressIndicator()))
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage!,
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: fetchWinners, child: const Text('Retry')),
                    ],
                  ),
                )
              : winners.isEmpty
                  ? const Center(child: Text('No winners yet'))
                  : RefreshIndicator(
                      onRefresh: fetchWinners,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)]),
                          ),
                          child: Column(
                            children: [
                              if (winners.isNotEmpty) _buildTopThree(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildAllRanksList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
    );
  }

  Widget _buildTopThree() {
    return Container(
      decoration: BoxDecoration(
        gradient:
            LinearGradient(colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)]),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Image.asset("assets/k.png",
              width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (winners.length > 2)
                _buildPodiumItem(
                    winners[2], 3, Color.fromARGB(255, 186, 116, 46)),
              if (winners.isNotEmpty)
                _buildPodiumItem(
                    winners[0], 1, Color.fromARGB(255, 217, 184, 2)),
              if (winners.length > 1)
                _buildPodiumItem(
                    winners[1], 2, Color.fromARGB(255, 178, 178, 178)),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _buildAllRanksList() {
    return Container(
      decoration: BoxDecoration(
        gradient:
            LinearGradient(colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)]),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: winners.length,
        itemBuilder: (context, index) {
          final winner = winners[index];
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)]),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 235, 235, 235),
                child: Text('${index + 1}',
                    style: GoogleFonts.inika(fontWeight: FontWeight.bold)),
              ),
              title: Text(winner.userName,
                  style: GoogleFonts.b612(fontWeight: FontWeight.bold)),
              trailing: Text(
                '${winner.score} pts',
                style:
                    GoogleFonts.gabarito(color: Colors.grey[600], fontSize: 15),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPodiumItem(Winner winner, int position, Color color) {
    final double height = position == 1
        ? 160
        : position == 2
            ? 140
            : 120;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 254, 254, 254),
                Color.fromARGB(255, 218, 215, 212)
              ]),
            ),
            child: Center(
              child: Text(
                position.toString(),
                style: GoogleFonts.aBeeZee(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.grey[200],
            elevation: 2.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              width: double.infinity,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    winner.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${winner.score} pts',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Winner {
  final String id;
  final String userName;
  final int score;
  final DateTime submittedAt;

  Winner(
      {required this.id,
      required this.userName,
      required this.score,
      required this.submittedAt});

  factory Winner.fromJson(Map<String, dynamic> json) {
    return Winner(
      id: json['_id'],
      userName: json['userId'] != null ? json['userId']['name'] : 'Unknown',
      score: json['score'],
      submittedAt: DateTime.parse(json['submittedAt']),
    );
  }
}
