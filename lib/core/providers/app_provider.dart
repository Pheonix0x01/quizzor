import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/question.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isSoundEnabled = true;
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  List<int?> _userAnswers = [];
  bool _isQuizCompleted = false;

  bool get isDarkMode => _isDarkMode;
  bool get isSoundEnabled => _isSoundEnabled;
  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  List<int?> get userAnswers => _userAnswers;
  bool get isQuizCompleted => _isQuizCompleted;
  Question? get currentQuestion => _questions.isEmpty ? null : _questions[_currentQuestionIndex];
  int get totalQuestions => _questions.length;
  int get correctAnswers => _userAnswers.asMap().entries.where((entry) {
    int index = entry.key;
    int? answer = entry.value;
    return answer != null && answer == _questions[index].answerIndex;
  }).length;

  AppProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _isSoundEnabled = prefs.getBool('isSoundEnabled') ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleSound() async {
    _isSoundEnabled = !_isSoundEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSoundEnabled', _isSoundEnabled);
    notifyListeners();
  }

  void setQuestions(List<Question> questions) {
    _questions = questions;
    _userAnswers = List.filled(questions.length, null);
    _currentQuestionIndex = 0;
    _isQuizCompleted = false;
    notifyListeners();
  }

  void selectAnswer(int answerIndex) {
    _userAnswers[_currentQuestionIndex] = answerIndex;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _isQuizCompleted = true;
    }
    notifyListeners();
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _userAnswers = List.filled(_questions.length, null);
    _isQuizCompleted = false;
    notifyListeners();
  }

  void resetToQuestion(int index) {
    _currentQuestionIndex = index;
    notifyListeners();
  }
}