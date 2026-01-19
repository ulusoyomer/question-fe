import 'package:equatable/equatable.dart';
enum QuestionType {
  mcq,
  openEnded;
  String toJson() => name;
  static QuestionType fromJson(String json) {
    return QuestionType.values.firstWhere(
      (type) => type.name == json,
      orElse: () => QuestionType.mcq,
    );
  }
}
enum QuestionDifficulty {
  easy,
  medium,
  hard;
  String toJson() => name;
  static QuestionDifficulty fromJson(String json) {
    return QuestionDifficulty.values.firstWhere(
      (diff) => diff.name == json,
      orElse: () => QuestionDifficulty.medium,
    );
  }
}
abstract class Question extends Equatable {
  final String id;
  final QuestionType type;
  final String questionText;
  final String explanation;
  final QuestionDifficulty difficulty;
  final String? topic;
  final double? confidenceScore;
  final String? imageUrl;
  const Question({
    required this.id,
    required this.type,
    required this.questionText,
    required this.explanation,
    this.difficulty = QuestionDifficulty.medium,
    this.topic,
    this.confidenceScore,
    this.imageUrl,
  });
  @override
  List<Object?> get props => [id, type, questionText, explanation, difficulty, topic, confidenceScore, imageUrl];
}
class MCQQuestion extends Question {
  final List<String> options;
  final String correctAnswer;
  const MCQQuestion({
    required super.id,
    required super.questionText,
    required super.explanation,
    required this.options,
    required this.correctAnswer,
    super.difficulty,
    super.topic,
    super.confidenceScore,
    super.imageUrl,
  }) : super(type: QuestionType.mcq);
  @override
  List<Object?> get props => [...super.props, options, correctAnswer];
}
class OpenEndedQuestion extends Question {
  final String sampleAnswer;
  const OpenEndedQuestion({
    required super.id,
    required super.questionText,
    required super.explanation,
    required this.sampleAnswer,
    super.difficulty,
    super.topic,
    super.confidenceScore,
    super.imageUrl,
  }) : super(type: QuestionType.openEnded);
  @override
  List<Object?> get props => [...super.props, sampleAnswer];
}
