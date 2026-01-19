import 'package:equatable/equatable.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
abstract class SimilarQuestionsEvent extends Equatable {
  const SimilarQuestionsEvent();
  @override
  List<Object?> get props => [];
}
class InputTextChanged extends SimilarQuestionsEvent {
  final String text;
  const InputTextChanged(this.text);
  @override
  List<Object?> get props => [text];
}
class SetOriginalQuestion extends SimilarQuestionsEvent {
  final Question question;
  const SetOriginalQuestion(this.question);
  @override
  List<Object?> get props => [question];
}
class PromptChanged extends SimilarQuestionsEvent {
  final String prompt;
  const PromptChanged(this.prompt);
  @override
  List<Object?> get props => [prompt];
}
class ImageSelected extends SimilarQuestionsEvent {
  const ImageSelected();
}
class RemoveImage extends SimilarQuestionsEvent {
  const RemoveImage();
}
class GenerateSimilarQuestions extends SimilarQuestionsEvent {
  final int count;
  const GenerateSimilarQuestions({this.count = 3});
  @override
  List<Object?> get props => [count];
}
