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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 🔹 Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.chevron_left,
                          size: 32, color: Colors.brown),
                    ),
                    Expanded(
                      child: Text(
                        "Quiz",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inika(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32), // Symmetry for back button
                  ],
                ),
              ),

              /// 📝 Question Card
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.07, vertical: 12),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.shade100,
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    question['questionText'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inika(
                      fontSize: isSmallScreen ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                      height: 1.6,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// 🟢 Options
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  itemCount: question['options'].length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedAnswers[currentIndex] == index;

                    return GestureDetector(
                      onTap: () => _selectAnswer(currentIndex, index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    Color(0xffD7FFD9),
                                    Color(0xffB2F4B6)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [Colors.white, Colors.white],
                                ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Color(0xff4CAF50)
                                : Colors.brown.shade200,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.shade100,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: isSelected
                                ? Color(0xff4CAF50)
                                : Colors.brown.shade100,
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.inika(
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            question['options'][index],
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// 🔘 Next / Submit Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
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
                    backgroundColor: Color(0xee383838),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 8,
                    shadowColor: Colors.brown.shade400,
                  ),
                  child: Text(
                    currentIndex == questions.length - 1 ? 'Submit' : 'Next',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
