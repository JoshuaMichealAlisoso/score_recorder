import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../models/quiz.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  final QuizController _controller = QuizController();
  final nameController = TextEditingController();
  final scoreController = TextEditingController();
  final overallScoreController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Quiz> quizzes = [];

  void addQuiz() async {
    if (nameController.text.isEmpty ||
        scoreController.text.isEmpty ||
        overallScoreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields must be filled!"), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      int score = int.parse(scoreController.text);
      int overallScore = int.parse(overallScoreController.text);
      int passed = (score >= overallScore * 0.5) ? 1 : 0;

      await _controller.addQuiz(nameController.text, score, overallScore, passed);
      getQuizzes();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passed == 1 ? "✅ Passed" : "❌ Failed"),
          backgroundColor: passed == 1 ? Colors.green : Colors.red,
        ),
      );

      nameController.clear();
      scoreController.clear();
      overallScoreController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid input!"), backgroundColor: Colors.red),
      );
    }
  }

  void getQuizzes() async {
    final data = await _controller.fetchQuizzes();
    setState(() {
      quizzes.clear();
      quizzes.addAll(data);
    });
  }

  void showQuizInputDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Quiz"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Quiz/Activity Name', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: scoreController,
              decoration: InputDecoration(labelText: 'Your Score', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: overallScoreController,
              decoration: InputDecoration(labelText: 'Overall Score', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              addQuiz();
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Score Recorder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),

            // List of quiz names with results
            quizzes.isNotEmpty
                ? Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: quizzes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.assignment, color: Colors.blue),
                          title: Text(
                            "${quizzes[index].quizName} - " + (quizzes[index].passed == 1 ? "✅ Passed" : "❌ Failed"),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(),

            SizedBox(height: 10),

            // Quiz table
            Expanded(
              flex: 3,
              child: quizzes.isEmpty
                  ? Center(child: Text("No quizzes added yet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: DataTable(
                        border: TableBorder.all(color: Colors.black12),
                        columns: [
                          DataColumn(label: Text('Quiz Name', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Score', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Overall Score', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: quizzes.map((quiz) {
                          return DataRow(cells: [
                            DataCell(Text(quiz.quizName)),
                            DataCell(Text('${quiz.score}')),
                            DataCell(Text('${quiz.overallScore}')),
                            DataCell(
                              Text(
                                quiz.passed == 1 ? '✅ Passed' : '❌ Failed',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: quiz.passed == 1 ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),

      // Floating action button to open input dialog
      floatingActionButton: FloatingActionButton(
        onPressed: showQuizInputDialog,
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
