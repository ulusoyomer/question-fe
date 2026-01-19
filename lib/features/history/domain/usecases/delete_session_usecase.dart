import 'package:dartz/dartz.dart';
import 'package:ai_question_generator/features/history/domain/repositories/history_repository.dart';
class DeleteSessionUseCase {
  final HistoryRepository _repository;
  DeleteSessionUseCase(this._repository);
  Future<Either<Exception, void>> call(int sessionId) {
    return _repository.deleteSession(sessionId);
  }
}
