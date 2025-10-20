class Question {
  final int id;
  final String question;
  final List<String> options;
  final int answerIndex;
  final String? hint;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answerIndex,
    this.hint,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      answerIndex: json['answer_index'],
      hint: json['hint'],
    );
  }
}