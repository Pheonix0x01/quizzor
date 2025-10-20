import 'dart:convert';
import 'package:flutter/services.dart';
import '../../data/models/question.dart';

class QuizService {
  static Future<List<Question>> loadQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/quizzes.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Question.fromJson(json)).toList();
    } catch (e) {
      print('Error loading questions: $e');
      return [];
    }
  }
}