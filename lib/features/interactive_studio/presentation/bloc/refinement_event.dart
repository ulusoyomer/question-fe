import 'package:equatable/equatable.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
abstract class RefinementEvent extends Equatable {
  const RefinementEvent();
  @override
  List<Object?> get props => [];
}
class LoadQuestionEvent extends RefinementEvent {
  final Question question;
  const LoadQuestionEvent(this.question);
  @override
  List<Object?> get props => [question];
}
class SendRefinementMessageEvent extends RefinementEvent {
  final String message;
  const SendRefinementMessageEvent(this.message);
  @override
  List<Object?> get props => [message];
}
class UpdateQuestionEvent extends RefinementEvent {
  final Question updatedQuestion;
  const UpdateQuestionEvent(this.updatedQuestion);
  @override
  List<Object?> get props => [updatedQuestion];
}
