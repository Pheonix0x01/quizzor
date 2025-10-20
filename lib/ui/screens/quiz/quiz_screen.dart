import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/services/audio_manager.dart';
import '../../widgets/toggle_button.dart';
import '../results/results_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  PageController _pageController = PageController();
  int? _selectedAnswer;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    _pageController = PageController(initialPage: appProvider.currentQuestionIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appProvider = Provider.of<AppProvider>(context);
    
    if (appProvider.isQuizCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ResultsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      });
      return const SizedBox();
    }

    final currentQuestion = appProvider.currentQuestion;
    if (currentQuestion == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    _selectedAnswer = appProvider.userAnswers[appProvider.currentQuestionIndex];

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
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${appProvider.currentQuestionIndex + 1} of ${appProvider.totalQuestions}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onBackground.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: (appProvider.currentQuestionIndex + 1) / appProvider.totalQuestions,
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
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
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    AudioManager().playClickSound();
                    setState(() {
                      appProvider.resetToQuestion(index);
                      _selectedAnswer = appProvider.userAnswers[index];
                      _showHint = false;
                    });
                  },
                  itemCount: appProvider.totalQuestions,
                  itemBuilder: (context, index) {
                    final question = appProvider.questions[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      question.question,
                                      style: theme.textTheme.headlineMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 32),
                                    ...question.options.asMap().entries.map((entry) {
                                      int optionIndex = entry.key;
                                      String option = entry.value;
                                      bool isSelected = _selectedAnswer == optionIndex;
                                      
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isSelected 
                                                  ? theme.colorScheme.primary 
                                                  : theme.colorScheme.surface,
                                              foregroundColor: isSelected 
                                                  ? Colors.white 
                                                  : theme.colorScheme.onSurface,
                                              elevation: isSelected ? 8 : 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                                side: BorderSide(
                                                  color: theme.colorScheme.primary.withOpacity(0.3),
                                                  width: isSelected ? 2 : 1,
                                                ),
                                              ),
                                              padding: const EdgeInsets.all(16),
                                            ),
                                            onPressed: () => _selectAnswer(optionIndex),
                                            child: Text(
                                              option,
                                              style: theme.textTheme.bodyLarge?.copyWith(
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    if (question.hint != null) ...[
                                      const SizedBox(height: 16),
                                      TextButton.icon(
                                        onPressed: () {
                                          AudioManager().playClickSound();
                                          setState(() {
                                            _showHint = !_showHint;
                                          });
                                        },
                                        icon: Icon(_showHint ? Icons.lightbulb : Icons.lightbulb_outline),
                                        label: Text(_showHint ? 'Hide Hint' : 'Show Hint'),
                                      ),
                                      if (_showHint) ...[
                                        const SizedBox(height: 8),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.secondary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: theme.colorScheme.secondary.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Text(
                                            question.hint!,
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontStyle: FontStyle.italic,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: appProvider.currentQuestionIndex > 0 ? _previousQuestion : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.surface,
                          foregroundColor: theme.colorScheme.onSurface,
                          elevation: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _selectedAnswer != null ? _nextQuestion : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(
                          appProvider.currentQuestionIndex == appProvider.totalQuestions - 1 
                              ? 'Finish' 
                              : 'Next'
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectAnswer(int answerIndex) {
    AudioManager().playClickSound();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.selectAnswer(answerIndex);
    setState(() {
      _selectedAnswer = answerIndex;
    });
  }

  void _nextQuestion() {
    AudioManager().playClickSound();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    if (appProvider.currentQuestionIndex < appProvider.totalQuestions - 1) {
      appProvider.nextQuestion();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _selectedAnswer = appProvider.userAnswers[appProvider.currentQuestionIndex];
        _showHint = false;
      });
    } else {
      appProvider.nextQuestion();
    }
  }

  void _previousQuestion() {
    AudioManager().playClickSound();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.previousQuestion();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _selectedAnswer = appProvider.userAnswers[appProvider.currentQuestionIndex];
      _showHint = false;
    });
  }
}