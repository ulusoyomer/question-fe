import 'package:file_picker/file_picker.dart';
import 'package:dartz/dartz.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/repositories/question_repository.dart';
class GenerateQuestionsFromPdfUseCase {
  final QuestionRepository repository;
  GenerateQuestionsFromPdfUseCase(this.repository);
  Future<Either<Exception, List<Question>>> call({
    required PlatformFile pdfFile,
    required QuestionType type,
    required int count,
  }) async {
    return await repository.generateFromPdf(
      pdfFile: pdfFile,
      type: type,
      count: count,
    );
  }
}
