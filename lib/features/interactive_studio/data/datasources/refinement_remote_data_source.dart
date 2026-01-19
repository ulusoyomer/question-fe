import 'package:ai_question_generator/core/network/api_client.dart';
import 'package:ai_question_generator/core/utils/constants.dart';
import 'package:ai_question_generator/shared/data/models/question_model.dart';
import 'package:ai_question_generator/features/interactive_studio/data/models/refinement_request_model.dart';
abstract class RefinementRemoteDataSource {
  Future<QuestionModel> refineQuestion(RefinementRequestModel request);
}
class RefinementRemoteDataSourceImpl implements RefinementRemoteDataSource {
  final ApiClient apiClient;
  RefinementRemoteDataSourceImpl(this.apiClient);
  @override
  Future<QuestionModel> refineQuestion(RefinementRequestModel request) async {
    final response = await apiClient.post(
      AppConstants.refineQuestionEndpoint,
      data: request.toJson(),
    );
    final data = response.data;
    if (data != null && data['refined_question'] != null) {
      return QuestionModel.fromJson(data['refined_question']);
    } else {
      throw Exception('Invalid response format');
    }
  }
}
