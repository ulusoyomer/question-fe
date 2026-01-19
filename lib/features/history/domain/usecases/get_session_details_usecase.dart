import 'package:dartz/dartz.dart';
import 'package:ai_question_generator/features/history/domain/entities/history_session.dart';
import 'package:ai_question_generator/features/history/domain/repositories/history_repository.dart';
class GetSessionDetailsUseCase {
  final HistoryRepository _repository;
  GetSessionDetailsUseCase(this._repository);
  Future<Either<Exception, HistorySession>> call(int sessionId) {
    return _repository.getSession(sessionId);
  }
}
