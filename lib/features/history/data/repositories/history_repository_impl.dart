import 'package:dartz/dartz.dart';
import 'package:ai_question_generator/features/history/domain/entities/history_session.dart';
import 'package:ai_question_generator/features/history/domain/repositories/history_repository.dart';
import 'package:ai_question_generator/features/history/data/datasources/history_remote_data_source.dart';
class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;
  HistoryRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Exception, List<HistorySession>>> getSessions({
    int limit = 20,
    String? sessionType,
  }) async {
    try {
      final models = await remoteDataSource.getSessions(
        limit: limit,
        sessionType: sessionType,
      );
      final sessions = models.map((m) => m.toEntity()).toList();
      return Right(sessions);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
  @override
  Future<Either<Exception, HistorySession>> getSession(int sessionId) async {
    try {
      final model = await remoteDataSource.getSession(sessionId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
  @override
  Future<Either<Exception, void>> deleteSession(int sessionId) async {
    try {
      await remoteDataSource.deleteSession(sessionId);
      return const Right(null);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
