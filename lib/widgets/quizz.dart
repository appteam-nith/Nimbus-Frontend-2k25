import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_2K25/auth.dart';
import 'package:nimbus_2K25/widgets/Rank.dart';
import 'package:nimbus_2K25/widgets/events.dart';

class QuizPage extends StatefulWidget {
  final String eventId;

  const QuizPage({Key? key, required this.eventId}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<dynamic> questions = [];
  List<int?> selectedAnswers = [];
  bool isLoading = true;
  int currentIndex = 0;
  String? token;
  String? quizId;
  bool submissionStatus = false;

  @override
  void initState() {
    super.initState();
    _checkSubmissionAndFetch();
  }

  Future<void> _checkSubmissionAndFetch() async {
    try {
      token = await AuthService.getToken();
      if (token != null) {
        var submissionResponse = await Dio().get(
          'https://nimbusbackend-l4ve.onrender.com/api/quiz/checkSubmission/${widget.eventId}',
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ),
        );

        if (submissionResponse.statusCode == 200) {
          submissionStatus = submissionResponse.data['submissionStatus'];

          if (submissionStatus) {
            var quizResponse = await Dio().get(
              'https://nimbusbackend-l4ve.onrender.com/api/quiz/event/${widget.eventId}',
              options: Options(
                headers: {"Authorization": "Bearer $token"},
              ),
            );
            if (quizResponse.statusCode == 200) {
              quizId = quizResponse.data['quiz']['_id'];
              _navigateToLeaderboard();
              return;
            }
          } else {
            await _fetchQuestions();
          }
        }
      }
    } catch (e) {
      print("Error checking submission status: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchQuestions() async {
    try {
      if (token != null) {
        var response = await Dio().get(
          'https://nimbusbackend-l4ve.onrender.com/api/quiz/event/${widget.eventId}',
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ),
        );
        if (response.statusCode == 200) {
          setState(() {
            quizId = response.data['quiz']['_id'];
            questions = response.data['quiz']['questions'];
            selectedAnswers = List<int?>.filled(questions.length, null);
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching questions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _submitAnswers() async {
    try {
      if (token != null) {
        await Dio().post(
          'https://nimbusbackend-l4ve.onrender.com/api/quiz/event/${widget.eventId}/submit',
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ),
          data: {
            "answers": selectedAnswers,
          },
        );
      }
    } catch (e) {
      print("Error submitting answers: $e");
    }
  }

  void _selectAnswer(int questionIndex, int answerIndex) {
    setState(() {
      selectedAnswers[questionIndex] = answerIndex;
    });
  }

  void _navigateToLeaderboard() {
    if (quizId != null) {
      _submitAnswers();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LeaderboardScreen(quizId: quizId!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var isSmallScreen = screenWidth < 600;

    if (isLoading) {
      return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)],
              ),
            ),
            child: buildLoadingAnimation()),
      );
    }

    // Show empty page if there are no questions
    if (questions.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)],
            ),
          ),
          child: Center(
            child: Text(
              "No questions available",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      );
    }

    var question = questions[currentIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Quiz",
                        style: GoogleFonts.inika(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Question Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Card(
                elevation: 6,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      question['questionText'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Options List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                itemCount: question['options'].length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedAnswers[currentIndex] == index;
                  return GestureDetector(
                    onTap: () => _selectAnswer(currentIndex, index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green[400] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              isSelected ? Colors.green[700] : Colors.grey[300],
                          child: Text(
                            '${index + 1}',
                            style: GoogleFonts.inika(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        title: Text(
                          question['options'][index],
                          style: GoogleFonts.inika(
                            fontSize: isSmallScreen ? 16 : 20,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Next/Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  if (currentIndex < questions.length - 1) {
                    setState(() {
                      currentIndex++;
                    });
                  } else {
                    _navigateToLeaderboard();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.black45,
                  elevation: 6,
                ),
                child: Text(
                  currentIndex == questions.length - 1 ? 'Submit' : 'Next',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
