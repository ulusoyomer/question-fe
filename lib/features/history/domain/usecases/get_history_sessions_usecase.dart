import 'package:dartz/dartz.dart';
import 'package:ai_question_generator/features/history/domain/entities/history_session.dart';
import 'package:ai_question_generator/features/history/domain/repositories/history_repository.dart';
class GetHistorySessionsUseCase {
  final HistoryRepository repository;
  GetHistorySessionsUseCase(this.repository);
  Future<Either<Exception, List<HistorySession>>> call({
    int limit = 20,
    String? sessionType,
  }) async {
    return await repository.getSessions(
      limit: limit,
      sessionType: sessionType,
    );
  }
}
