import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_question_generator/features/history/domain/usecases/get_history_sessions_usecase.dart';
import 'package:ai_question_generator/features/history/domain/usecases/delete_session_usecase.dart';
import 'package:ai_question_generator/features/history/presentation/bloc/history_event.dart';
import 'package:ai_question_generator/features/history/presentation/bloc/history_state.dart';
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistorySessionsUseCase getHistorySessionsUseCase;
  final DeleteSessionUseCase deleteSessionUseCase;
  HistoryBloc({
    required this.getHistorySessionsUseCase,
    required this.deleteSessionUseCase,
  }) : super(const HistoryState()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<RefreshHistoryEvent>(_onRefreshHistory);
    on<DeleteSessionEvent>(_onDeleteSession);
  }
  Future<void> _onLoadHistory(
    LoadHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(
      status: HistoryStatus.loading,
      currentFilter: event.filter,
      clearFilter: event.filter == null,
    ));
    final result = await getHistorySessionsUseCase(
      limit: 50,
      sessionType: event.filter,
    );
    result.fold(
      (error) => emit(state.copyWith(
        status: HistoryStatus.error,
        errorMessage: error.toString(),
      )),
      (sessions) => emit(state.copyWith(
        status: HistoryStatus.loaded,
        sessions: sessions,
        clearError: true,
      )),
    );
  }
  Future<void> _onRefreshHistory(
    RefreshHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    add(LoadHistoryEvent(filter: state.currentFilter));
  }
  Future<void> _onDeleteSession(
    DeleteSessionEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(status: HistoryStatus.deleting));
    final updatedSessions = state.sessions
        .where((session) => session.id != event.sessionId)
        .toList();
    emit(state.copyWith(
      status: HistoryStatus.loaded,
      sessions: updatedSessions,
    ));
    final result = await deleteSessionUseCase(event.sessionId);
    result.fold(
      (error) {
        add(const RefreshHistoryEvent());
      },
      (_) {
      },
    );
  }
}
