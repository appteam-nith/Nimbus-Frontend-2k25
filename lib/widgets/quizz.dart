import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:nimbus_user/auth.dart';
import 'package:nimbus_user/widgets/Rank.dart';

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
  String? quizId; // Add this to store quiz ID

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      token = await AuthService.getToken();
      if (token != null) {
        var response = await Dio().get(
          'https://nimbusbackend-l4ve.onrender.com/api/quiz/event/${widget.eventId}',
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ),
        );
        if (response.statusCode == 200) {
          setState(() {
            // Extract quiz ID from the response
            quizId = response.data['quiz']['_id'];
            questions = response.data['quiz']['questions'];
            selectedAnswers = List<int?>.filled(questions.length, null);
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching questions: $e");
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
      Navigator.push(
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
        appBar: AppBar(title: Center(child: Text("Quiz Page"))),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    var question = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Quiz Page")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.1),
                color: Color(0xFFADE5FF),
              ),
              width: screenWidth,
              height: screenHeight * 0.3,
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
            SizedBox(height: isSmallScreen ? 16 : 24),
            Expanded(
              child: ListView.builder(
                itemCount: question['options'].length,
                itemBuilder: (context, index) {
                  return Card(
                    color: selectedAnswers[currentIndex] == index
                        ? Colors.green[200]
                        : Colors.white,
                    child: ListTile(
                      title: Text(question['options'][index]),
                      leading: Text('${index + 1}'),
                      onTap: () => _selectAnswer(currentIndex, index),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
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
                  child: Container(
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(screenWidth * 0.1),
                    ),
                    child: Center(
                      child: Text(
                        currentIndex == questions.length - 1 ? 'Submit' : 'Next',
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