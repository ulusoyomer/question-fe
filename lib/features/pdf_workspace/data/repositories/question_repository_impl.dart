import 'package:file_picker/file_picker.dart';
import 'package:dartz/dartz.dart';
import 'package:ai_question_generator/core/utils/constants.dart';
import 'package:ai_question_generator/shared/data/models/question_model.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/repositories/question_repository.dart';
import 'package:ai_question_generator/features/pdf_workspace/data/datasources/pdf_remote_data_source.dart';
class QuestionRepositoryImpl implements QuestionRepository {
  final PdfRemoteDataSource remoteDataSource;
  QuestionRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Exception, List<Question>>> generateFromPdf({
    required PlatformFile pdfFile,
    required QuestionType type,
    required int count,
  }) async {
    try {
      final questionModels = await remoteDataSource.generateFromPdf(pdfFile, type, count);
      final questionsList = questionModels.map((m) => m.toEntity()).toList();
      return Right(questionsList);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
