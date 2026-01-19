import 'package:dartz/dartz.dart';
import 'package:ai_question_generator/core/network/api_client.dart';
import 'package:ai_question_generator/core/utils/constants.dart';
import 'package:ai_question_generator/shared/data/models/question_model.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
import 'package:ai_question_generator/features/interactive_studio/domain/repositories/refinement_repository.dart';
import 'package:ai_question_generator/features/interactive_studio/data/models/refinement_request_model.dart';
import 'package:ai_question_generator/features/interactive_studio/data/datasources/refinement_remote_data_source.dart';
class RefinementRepositoryImpl implements RefinementRepository {
  final RefinementRemoteDataSource remoteDataSource;
  RefinementRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Exception, Question>> refineQuestion({
    required Question currentQuestion,
    required String instructions,
    List<Map<String, String>>? history,
  }) async {
    try {
      final requestModel = RefinementRequestModel(
        currentQuestion: currentQuestion,
        instructions: instructions,
        history: history ?? [],
      );
      final refinedQuestionModel = await remoteDataSource.refineQuestion(requestModel);
      return Right(refinedQuestionModel.toEntity());
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
