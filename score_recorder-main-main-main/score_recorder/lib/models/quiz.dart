class Quiz {
  int? id;
  String quizName;
  int score;
  int overallScore;
  bool passed;

  Quiz(
      {this.id,
      required this.quizName,
      required this.score,
      required this.overallScore,
      required bool passed})
      : passed = (score / overallScore) * 100 >= 70;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quizName': quizName,
      'score': score,
      'overallScore': overallScore,
      'passed': passed ? 1 : 0,
    };
  }
}
