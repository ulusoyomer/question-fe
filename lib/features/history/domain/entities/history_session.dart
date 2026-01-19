import 'package:equatable/equatable.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
class HistorySession extends Equatable {
  final int id;
  final String sessionType;
  final DateTime createdAt;
  final String? sourceFile;
  final String? sourceText;
  final Map<String, dynamic>? config;
  final int questionCount;
  final List<Question>? questions;
  const HistorySession({
    required this.id,
    required this.sessionType,
    required this.createdAt,
    this.sourceFile,
    this.sourceText,
    this.config,
    required this.questionCount,
    this.questions,
  });
  @override
  List<Object?> get props => [
        id,
        sessionType,
        createdAt,
        sourceFile,
        sourceText,
        config,
        questionCount,
        questions,
      ];
  String get displayTitle {
    if (sourceFile != null) {
      return sourceFile!.split('/').last.replaceAll('.pdf', '');
    }
    if (sourceText != null && sourceText!.isNotEmpty) {
      return sourceText!.length > 50
          ? '${sourceText!.substring(0, 50)}...'
          : sourceText!;
    }
    return 'Session #$id';
  }
  String get typeLabel {
    switch (sessionType) {
      case 'pdf':
        return 'PDF Generation';
      case 'similar':
        return 'Style Clone';
      case 'refinement':
        return 'Interactive Studio';
      default:
        return sessionType;
    }
  }
}
