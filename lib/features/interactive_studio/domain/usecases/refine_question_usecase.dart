import 'package:dartz/dartz.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
import 'package:ai_question_generator/features/interactive_studio/domain/repositories/refinement_repository.dart';
class RefineQuestionUseCase {
  final RefinementRepository repository;
  RefineQuestionUseCase(this.repository);
  Future<Either<Exception, Question>> call({
    required Question currentQuestion,
    required String instructions,
    List<Map<String, String>>? history,
  }) async {
    return await repository.refineQuestion(
      currentQuestion: currentQuestion,
      instructions: instructions,
      history: history,
    );
  }
}
