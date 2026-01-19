import 'package:dartz/dartz.dart';
import 'package:ai_question_generator/features/history/domain/entities/history_session.dart';
abstract class HistoryRepository {
  Future<Either<Exception, List<HistorySession>>> getSessions({
    int limit = 20,
    String? sessionType,
  });
  Future<Either<Exception, HistorySession>> getSession(int sessionId);
  Future<Either<Exception, void>> deleteSession(int sessionId);
}
