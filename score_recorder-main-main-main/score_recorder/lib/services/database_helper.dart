import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/quiz.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quizzes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE quizzes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            quizName TEXT,
            score INTEGER,
            overallScore INTEGER,
            passed INTEGER
          )
        ''');
      },
    );
  }

  insertQuiz(Quiz newQuiz) {}

  getQuizzes() {}
}
