import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_question_generator/core/network/api_client.dart';
import 'package:ai_question_generator/core/utils/constants.dart';
import 'package:ai_question_generator/shared/data/models/question_model.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
import 'package:ai_question_generator/features/similar_questions/domain/repositories/similar_questions_repository.dart';
import 'package:ai_question_generator/features/similar_questions/data/models/similar_questions_request_model.dart';
import 'package:ai_question_generator/features/similar_questions/data/datasources/similar_questions_remote_data_source.dart';
class SimilarQuestionsRepositoryImpl implements SimilarQuestionsRepository {
  final SimilarQuestionsRemoteDataSource remoteDataSource;
  SimilarQuestionsRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Exception, List<Question>>> generateSimilar({
    String? text,
    XFile? image,
    required int count,
  }) async {
    try {
      String? base64Image;
      if (image != null) {
        final bytes = await image.readAsBytes();
        base64Image = base64Encode(bytes);
      }
      final requestModel = SimilarQuestionsRequestModel(
        questionText: text,
        imageBase64: base64Image,
        count: count,
      );
      final questionModels = await remoteDataSource.generateSimilar(requestModel);
      final questionsList = questionModels.map((m) => m.toEntity()).toList();
      return Right(questionsList);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
