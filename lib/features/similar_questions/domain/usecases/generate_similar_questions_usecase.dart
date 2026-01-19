import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
import 'package:ai_question_generator/features/similar_questions/domain/repositories/similar_questions_repository.dart';
class GenerateSimilarQuestionsUseCase {
  final SimilarQuestionsRepository repository;
  GenerateSimilarQuestionsUseCase(this.repository);
  Future<Either<Exception, List<Question>>> call({
    String? text,
    XFile? image,
    required int count,
  }) async {
    return await repository.generateSimilar(
      text: text,
      image: image,
      count: count,
    );
  }
}
