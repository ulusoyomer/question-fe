import 'package:file_picker/file_picker.dart';
import 'package:dartz/dartz.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
abstract class QuestionRepository {
  Future<Either<Exception, List<Question>>> generateFromPdf({
    required PlatformFile pdfFile,
    required QuestionType type,
    required int count,
  });
}
