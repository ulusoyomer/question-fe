import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
abstract class SimilarQuestionsRepository {
  Future<Either<Exception, List<Question>>> generateSimilar({
    String? text,
    XFile? image,
    required int count,
  });
}
