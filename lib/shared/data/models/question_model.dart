import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
class QuestionModel {
  final String id;
  final String type;
  final String questionText;
  final String explanation;
  final String difficulty;
  final String? topic;
  final List<String>? options;
  final String? correctAnswer;
  final String? sampleAnswer;
  final double? confidenceScore;
  final String? imageUrl;
  QuestionModel({
    required this.id,
    required this.type,
    required this.questionText,
    required this.explanation,
    this.difficulty = 'medium',
    this.topic,
    this.options,
    this.correctAnswer,
    this.sampleAnswer,
    this.confidenceScore,
    this.imageUrl,
  });
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'].toString(),
      type: (json['type'] ?? json['question_type']) as String,
      questionText: (json['question_text'] ?? json['questionText']) as String,
      explanation: json['explanation'] as String,
      difficulty: json['difficulty'] as String? ?? 'medium',
      topic: json['topic'] as String?,
      options: json['options'] != null 
          ? List<String>.from(json['options'] as List)
          : null,
      correctAnswer: (json['correct_answer'] ?? json['correctAnswer']) as String?,
      sampleAnswer: (json['sample_answer'] ?? json['sampleAnswer']) as String?,
      confidenceScore: (json['confidence_score'] ?? json['confidenceScore']) as double?,
      imageUrl: (json['image_url'] ?? json['imageUrl']) as String?,
    );
  }
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'type': type,
      'question_text': questionText,
      'explanation': explanation,
      'difficulty': difficulty,
    };
    if (topic != null) json['topic'] = topic;
    if (options != null) json['options'] = options;
    if (correctAnswer != null) json['correct_answer'] = correctAnswer;
    if (sampleAnswer != null) json['sample_answer'] = sampleAnswer;
    if (confidenceScore != null) json['confidence_score'] = confidenceScore;
    if (imageUrl != null) json['image_url'] = imageUrl;
    return json;
  }
  Question toEntity() {
    final questionType = type == 'mcq' ? QuestionType.mcq : QuestionType.openEnded;
    final questionDifficulty = QuestionDifficulty.values.firstWhere(
      (d) => d.name == difficulty,
      orElse: () => QuestionDifficulty.medium,
    );
    if (questionType == QuestionType.mcq) {
      return MCQQuestion(
        id: id,
        questionText: questionText,
        explanation: explanation,
        options: options ?? [],
        correctAnswer: correctAnswer ?? '',
        difficulty: questionDifficulty,
        topic: topic,
        confidenceScore: confidenceScore,
        imageUrl: imageUrl,
      );
    } else {
      return OpenEndedQuestion(
        id: id,
        questionText: questionText,
        explanation: explanation,
        sampleAnswer: sampleAnswer ?? '',
        difficulty: questionDifficulty,
        topic: topic,
        confidenceScore: confidenceScore,
        imageUrl: imageUrl,
      );
    }
  }
  factory QuestionModel.fromEntity(Question entity) {
    if (entity is MCQQuestion) {
      return QuestionModel(
        id: entity.id,
        type: 'mcq',
        questionText: entity.questionText,
        explanation: entity.explanation,
        difficulty: entity.difficulty.name,
        topic: entity.topic,
        options: entity.options,
        correctAnswer: entity.correctAnswer,
      );
    } else if (entity is OpenEndedQuestion) {
      return QuestionModel(
        id: entity.id,
        type: 'open_ended',
        questionText: entity.questionText,
        explanation: entity.explanation,
        difficulty: entity.difficulty.name,
        topic: entity.topic,
        sampleAnswer: entity.sampleAnswer,
      );
    }
    throw ArgumentError('Unknown question type');
  }
}
