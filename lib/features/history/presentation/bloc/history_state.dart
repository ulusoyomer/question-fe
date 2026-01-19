import 'package:equatable/equatable.dart';
import 'package:ai_question_generator/features/history/domain/entities/history_session.dart';
enum HistoryStatus { initial, loading, loaded, error, deleting }
class HistoryState extends Equatable {
  final HistoryStatus status;
  final List<HistorySession> sessions;
  final String? errorMessage;
  final String? currentFilter;
  const HistoryState({
    this.status = HistoryStatus.initial,
    this.sessions = const [],
    this.errorMessage,
    this.currentFilter,
  });
  HistoryState copyWith({
    HistoryStatus? status,
    List<HistorySession>? sessions,
    String? errorMessage,
    String? currentFilter,
    bool clearError = false,
    bool clearFilter = false,
  }) {
    return HistoryState(
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentFilter: clearFilter ? null : (currentFilter ?? this.currentFilter),
    );
  }
  @override
  List<Object?> get props => [status, sessions, errorMessage, currentFilter];
}
