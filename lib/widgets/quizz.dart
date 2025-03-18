import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus_2K25/auth.dart';
import 'package:nimbus_2K25/widgets/Rank.dart';

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
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xff383838),
            ),
          ),
        ),
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
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xffFDD1DC), Color(0xffEEE0CA)]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SafeArea(
                      child: Center(
                        child: Text(
                          "Quiz",
                          style: GoogleFonts.inika(fontSize: 30),
                        ),
                      ),
                    ),
                  ],
                ),
                SafeArea(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.015),
              child: Card(
                color: Color.fromARGB(255, 228, 226, 226),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.2),
                      color: Color.fromARGB(255, 231, 228, 228),
                    ),
                    width: screenWidth,
                    height: screenHeight * 0.25,
                    child: Center(
                      child: Text(
                        question['questionText'],
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            ListView.builder(
              padding: EdgeInsets.only(bottom: 0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: question['options'].length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenHeight * 0.015,
                      vertical: screenHeight * 0.005),
                  child: Card(
                    elevation: 5,
                    color: selectedAnswers[currentIndex] == index
                        ? Colors.green[300]
                        : Colors.white,
                    child: ListTile(
                      title: Text(
                        question['options'][index],
                        style: GoogleFonts.inika(
                            fontSize: isSmallScreen ? 16 : 20),
                      ),
                      leading: Text('${index + 1}',
                          style: GoogleFonts.inika(
                              fontSize: isSmallScreen ? 16 : 20)),
                      onTap: () => _selectAnswer(currentIndex, index),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: screenHeight * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (currentIndex < questions.length - 1) {
                      setState(() {
                        currentIndex++;
                      });
                    } else {
                      _navigateToLeaderboard();
                    }
                  },
                  child: Card(
                    elevation: 5,
                    color: Colors.blueAccent,
                    child: Container(
                      width: screenWidth * 0.5,
                      height: screenHeight * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(screenWidth * 0.1),
                      ),
                      child: Center(
                        child: Text(
                          currentIndex == questions.length - 1
                              ? 'Submit'
                              : 'Next',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: screenHeight * 0.02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
