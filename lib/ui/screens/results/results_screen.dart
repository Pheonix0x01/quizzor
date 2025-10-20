import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/services/audio_manager.dart';
import '../../widgets/toggle_button.dart';
import '../home/home_screen.dart';
import '../quiz/quiz_screen.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appProvider = Provider.of<AppProvider>(context);
    
    final score = appProvider.correctAnswers;
    final total = appProvider.totalQuestions;
    final percentage = (score / total * 100).round();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.05),
              theme.colorScheme.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ToggleButton(
                      icon: appProvider.isSoundEnabled ? Icons.volume_up : Icons.volume_off,
                      onPressed: () {
                        appProvider.toggleSound();
                        AudioManager().setSoundEnabled(appProvider.isSoundEnabled);
                        if (appProvider.isSoundEnabled) {
                          AudioManager().playBackgroundMusic();
                          AudioManager().playClickSound();
                        } else {
                          AudioManager().stopBackgroundMusic();
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ToggleButton(
                      icon: appProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      onPressed: () {
                        AudioManager().playClickSound();
                        appProvider.toggleTheme();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        _getScoreIcon(percentage),
                        size: 80,
                        color: _getScoreColor(percentage, theme),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Quiz Completed!',
                        style: theme.textTheme.headlineLarge?.copyWith(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                'Your Score',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '$score/$total',
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: _getScoreColor(percentage, theme),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$percentage% Correct',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: _getScoreColor(percentage, theme),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _getScoreMessage(percentage),
                                style: theme.textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Review Answers',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...appProvider.questions.asMap().entries.map((entry) {
                                int index = entry.key;
                                var question = entry.value;
                                int? userAnswer = appProvider.userAnswers[index];
                                bool isCorrect = userAnswer == question.answerIndex;
                                
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isCorrect 
                                              ? Colors.green.withOpacity(0.2)
                                              : Colors.red.withOpacity(0.2),
                                        ),
                                        child: Icon(
                                          isCorrect ? Icons.check : Icons.close,
                                          color: isCorrect ? Colors.green : Colors.red,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Q${index + 1}: ${isCorrect ? 'Correct' : 'Wrong'}',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _retryQuiz(context),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry Quiz'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.surface,
                                foregroundColor: theme.colorScheme.onSurface,
                                elevation: 4,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _goHome(context),
                              icon: const Icon(Icons.home),
                              label: const Text('Go Home'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getScoreIcon(int percentage) {
    if (percentage >= 80) return Icons.emoji_events;
    if (percentage >= 60) return Icons.thumb_up;
    if (percentage >= 40) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }

  Color _getScoreColor(int percentage, ThemeData theme) {
    if (percentage >= 80) return Colors.amber;
    if (percentage >= 60) return Colors.green;
    if (percentage >= 40) return theme.colorScheme.primary;
    return Colors.red;
  }

  String _getScoreMessage(int percentage) {
    if (percentage >= 90) return "Outstanding! You're a tech expert! 🏆";
    if (percentage >= 80) return "Excellent work! You know your tech! 🌟";
    if (percentage >= 70) return "Great job! You're doing well! 👍";
    if (percentage >= 60) return "Good effort! Keep learning! 📚";
    if (percentage >= 50) return "Not bad! Practice makes perfect! 💪";
    return "Keep studying! You'll improve! 🚀";
  }

  void _retryQuiz(BuildContext context) {
    AudioManager().playClickSound();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.resetQuiz();
    
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const QuizScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _goHome(BuildContext context) {
    AudioManager().playClickSound();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.resetQuiz();
    
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
      (route) => false,
    );
  }
}