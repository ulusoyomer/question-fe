import 'package:dartz/dartz.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
abstract class RefinementRepository {
  Future<Either<Exception, Question>> refineQuestion({
    required Question currentQuestion,
    required String instructions,
    List<Map<String, String>>? history,
  });
}
