import 'package:equatable/equatable.dart';
import 'package:ai_question_generator/shared/data/models/question_model.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
import 'package:ai_question_generator/shared/data/models/question_model.dart';
class RefinementRequestModel extends Equatable {
  final Question currentQuestion;
  final String instructions;
  final List<Map<String, String>> history;
  const RefinementRequestModel({
    required this.currentQuestion,
    required this.instructions,
    required this.history,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> questionJson;
    if (currentQuestion is MCQQuestion) {
      questionJson = QuestionModel.fromEntity(currentQuestion).toJson();
    } else if (currentQuestion is OpenEndedQuestion) {
      questionJson = QuestionModel.fromEntity(currentQuestion).toJson();
    } else {
      questionJson = {};
    }
    return {
      'question_id': currentQuestion.id,
      'current_question': questionJson,
      'refinement_prompt': instructions,
      'conversation_history': history,
    };
  }
  @override
  List<Object?> get props => [currentQuestion, instructions, history];
}
