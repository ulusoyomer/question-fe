import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_question_generator/features/interactive_studio/domain/usecases/refine_question_usecase.dart';
import 'package:ai_question_generator/features/interactive_studio/presentation/bloc/refinement_event.dart';
import 'package:ai_question_generator/features/interactive_studio/presentation/bloc/refinement_state.dart';
class RefinementBloc extends Bloc<RefinementEvent, RefinementState> {
  final RefineQuestionUseCase refineQuestionUseCase;
  RefinementBloc({required this.refineQuestionUseCase}) : super(const RefinementState()) {
    on<LoadQuestionEvent>(_onLoadQuestion);
    on<SendRefinementMessageEvent>(_onSendMessage);
    on<UpdateQuestionEvent>(_onUpdateQuestion);
  }
  void _onLoadQuestion(LoadQuestionEvent event, Emitter<RefinementState> emit) {
    emit(state.copyWith(
      currentQuestion: event.question,
      status: RefinementStatus.loaded,
      messages: [], 
    ));
  }
  Future<void> _onSendMessage(SendRefinementMessageEvent event, Emitter<RefinementState> emit) async {
    if (state.currentQuestion == null) return;
    final userMessage = ChatMessage(
      text: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      status: RefinementStatus.loading,
    ));
    final history = state.messages.map((m) => {
      'role': m.isUser ? 'user' : 'assistant',
      'content': m.text,
    }).toList();
    final result = await refineQuestionUseCase(
      currentQuestion: state.currentQuestion!,
      instructions: event.message,
      history: history,
    );
    result.fold(
      (error) {
        emit(state.copyWith(
          status: RefinementStatus.error,
          errorMessage: error.toString(),
        ));
      },
      (refinedQuestion) {
        final aiMessage = ChatMessage(
          text: "I've updated the question based on your request.",
          isUser: false,
          timestamp: DateTime.now(),
        );
        emit(state.copyWith(
          currentQuestion: refinedQuestion,
          messages: [...state.messages, aiMessage],
          status: RefinementStatus.loaded,
        ));
      },
    );
  }
  void _onUpdateQuestion(UpdateQuestionEvent event, Emitter<RefinementState> emit) {
    emit(state.copyWith(currentQuestion: event.updatedQuestion));
  }
}
