import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
abstract class PdfWorkspaceEvent extends Equatable {
  const PdfWorkspaceEvent();
  @override
  List<Object?> get props => [];
}
class UploadPdfEvent extends PdfWorkspaceEvent {
  const UploadPdfEvent();
}
class RemovePdfEvent extends PdfWorkspaceEvent {
  const RemovePdfEvent();
}
class ChangeQuestionTypeEvent extends PdfWorkspaceEvent {
  final QuestionType type;
  const ChangeQuestionTypeEvent(this.type);
  @override
  List<Object?> get props => [type];
}
class ChangeQuestionCountEvent extends PdfWorkspaceEvent {
  final int count;
  const ChangeQuestionCountEvent(this.count);
  @override
  List<Object?> get props => [count];
}
class GenerateQuestionsEvent extends PdfWorkspaceEvent {
  const GenerateQuestionsEvent();
}
class UpdateQuestionEvent extends PdfWorkspaceEvent {
  final int index;
  final Question updatedQuestion;
  const UpdateQuestionEvent(this.index, this.updatedQuestion);
  @override
  List<Object?> get props => [index, updatedQuestion];
}
class LoadSessionEvent extends PdfWorkspaceEvent {
  final int sessionId;
  const LoadSessionEvent(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}
