import 'package:dio/dio.dart';
import 'package:ai_question_generator/core/network/api_client.dart';
import 'package:ai_question_generator/features/history/data/models/history_session_model.dart';
abstract class HistoryRemoteDataSource {
  Future<List<HistorySessionModel>> getSessions({int limit = 20, String? sessionType});
  Future<HistorySessionModel> getSession(int sessionId);
  Future<void> deleteSession(int sessionId);
}
class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final ApiClient apiClient;
  HistoryRemoteDataSourceImpl(this.apiClient);
  @override
  Future<List<HistorySessionModel>> getSessions({
    int limit = 20,
    String? sessionType,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
    };
    if (sessionType != null) {
      queryParams['session_type'] = sessionType;
    }
    final response = await apiClient.get(
      '/api/history/sessions',
      queryParameters: queryParams,
    );
    final data = response.data as List;
    return data.map((json) => HistorySessionModel.fromJson(json)).toList();
  }
  @override
  Future<HistorySessionModel> getSession(int sessionId) async {
    final response = await apiClient.get('/api/history/sessions/$sessionId');
    return HistorySessionModel.fromJson(response.data);
  }
  @override
  Future<void> deleteSession(int sessionId) async {
    await apiClient.delete('/api/history/sessions/$sessionId');
  }
}
