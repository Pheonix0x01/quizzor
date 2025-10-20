import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../data/models/question.dart';

class QuizService {
  static Future<List<Question>> loadQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/quizzes.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final allQuestions = jsonList.map((json) => Question.fromJson(json)).toList();
      
      if (allQuestions.length <= 10) {
        return allQuestions;
      }
      
      allQuestions.shuffle(Random());
      return allQuestions.take(10).toList();
    } catch (e) {
      print('Error loading questions: $e');
      return [];
    }
  }
}