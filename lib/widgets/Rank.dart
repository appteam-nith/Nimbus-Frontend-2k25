import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    fetchWinners();
  }

  Future<void> fetchWinners() async {
    try {
      final response = await http.get(
        Uri.parse('https://nimbusbackend-l4ve.onrender.com/api/quiz/${widget.quizId}/winners'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Winner> loadedWinners = (data['winners'] as List)
            .map((winner) => Winner.fromJson(winner))
            .toList();
        
        setState(() {
          winners = loadedWinners;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching winners: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                if (winners.isNotEmpty) _buildTopThree(),
                _buildAllRanksList(),
              ],
            ),
          ),
    );
  }

  Widget _buildTopThree() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (winners.length > 2)
            _buildPodiumItem(winners[2], 3, Colors.brown[300]!),
          if (winners.isNotEmpty)
            _buildPodiumItem(winners[0], 1, Colors.blue[300]!),
          if (winners.length > 1)
            _buildPodiumItem(winners[1], 2, Colors.grey[400]!),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(Winner winner, int position, Color color) {
    final double height = position == 1 ? 160 : position == 2 ? 140 : 120;
    
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: Text(
                position.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: height,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
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
        ],
      ),
    );
  }

  Widget _buildAllRanksList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: winners.length,
      itemBuilder: (context, index) {
        final winner = winners[index];
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  winner.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${winner.score} pts',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Winner {
  final String id;
  final String userName;
  final int score;
  final DateTime submittedAt;

  Winner({
    required this.id,
    required this.userName,
    required this.score,
    required this.submittedAt,
  });

  factory Winner.fromJson(Map<String, dynamic> json) {
    return Winner(
      id: json['_id'],
      userName: json['userId']['name'],
      score: json['score'],
      submittedAt: DateTime.parse(json['submittedAt']),
    );
  }
}