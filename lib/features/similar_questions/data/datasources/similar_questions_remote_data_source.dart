import 'package:ai_question_generator/core/network/api_client.dart';
import 'package:ai_question_generator/core/utils/constants.dart';
import 'package:ai_question_generator/shared/data/models/question_model.dart';
import 'package:ai_question_generator/features/similar_questions/data/models/similar_questions_request_model.dart';
abstract class SimilarQuestionsRemoteDataSource {
  Future<List<QuestionModel>> generateSimilar(SimilarQuestionsRequestModel request);
}
class SimilarQuestionsRemoteDataSourceImpl implements SimilarQuestionsRemoteDataSource {
  final ApiClient apiClient;
  SimilarQuestionsRemoteDataSourceImpl(this.apiClient);
  @override
  Future<List<QuestionModel>> generateSimilar(SimilarQuestionsRequestModel request) async {
    final response = await apiClient.post(
      AppConstants.generateSimilarEndpoint,
      data: request.toJson(),
    );
    final data = response.data;
    if (data != null && data['questions'] != null) {
      return (data['questions'] as List)
          .map((q) => QuestionModel.fromJson(q))
          .toList();
    } else {
      throw Exception('Invalid response format');
    }
  }
}
