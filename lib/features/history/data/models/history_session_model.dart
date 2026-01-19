import 'package:ai_question_generator/features/history/domain/entities/history_session.dart';
import 'package:ai_question_generator/shared/data/models/question_model.dart';
class HistorySessionModel {
  final int id;
  final String sessionType;
  final DateTime createdAt;
  final String? sourceFile;
  final String? sourceText;
  final Map<String, dynamic>? config;
  final int questionCount;
  final List<QuestionModel>? questions;
  HistorySessionModel({
    required this.id,
    required this.sessionType,
    required this.createdAt,
    this.sourceFile,
    this.sourceText,
    this.config,
    required this.questionCount,
    this.questions,
  });
  factory HistorySessionModel.fromJson(Map<String, dynamic> json) {
    final questionsList = json['questions'] != null
        ? (json['questions'] as List)
            .map((q) => QuestionModel.fromJson(q))
            .toList()
        : null;
    final questionCount = json['question_count'] as int?
        ?? questionsList?.length
        ?? 0;
    final parsedDate = DateTime.parse(json['created_at'] as String);
    final localDate = parsedDate.isUtc ? parsedDate.toLocal() : parsedDate;
    return HistorySessionModel(
      id: json['id'] as int,
      sessionType: json['session_type'] as String,
      createdAt: localDate,
      sourceFile: json['source_file'] as String?,
      sourceText: json['source_text'] as String?,
      config: json['config'] as Map<String, dynamic>?,
      questionCount: questionCount,
      questions: questionsList,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_type': sessionType,
      'created_at': createdAt.toIso8601String(),
      'source_file': sourceFile,
      'source_text': sourceText,
      'config': config,
      'question_count': questionCount,
      'questions': questions?.map((q) => q.toJson()).toList(),
    };
  }
  HistorySession toEntity() {
    return HistorySession(
      id: id,
      sessionType: sessionType,
      createdAt: createdAt,
      sourceFile: sourceFile,
      sourceText: sourceText,
      config: config,
      questionCount: questionCount,
      questions: questions?.map((q) => q.toEntity()).toList(),
    );
  }
  factory HistorySessionModel.fromEntity(HistorySession entity) {
    return HistorySessionModel(
      id: entity.id,
      sessionType: entity.sessionType,
      createdAt: entity.createdAt,
      sourceFile: entity.sourceFile,
      sourceText: entity.sourceText,
      config: entity.config,
      questionCount: entity.questionCount,
      questions: entity.questions?.map((q) => QuestionModel.fromEntity(q)).toList(),
    );
  }
}
