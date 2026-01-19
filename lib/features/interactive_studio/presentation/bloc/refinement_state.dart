import 'package:equatable/equatable.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
enum RefinementStatus { initial, loading, loaded, error }
class ChatMessage extends Equatable {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
  @override
  List<Object?> get props => [text, isUser, timestamp];
}
class RefinementState extends Equatable {
  final RefinementStatus status;
  final Question? currentQuestion;
  final List<ChatMessage> messages;
  final String? errorMessage;
  const RefinementState({
    this.status = RefinementStatus.initial,
    this.currentQuestion,
    this.messages = const [],
    this.errorMessage,
  });
  RefinementState copyWith({
    RefinementStatus? status,
    Question? currentQuestion,
    List<ChatMessage>? messages,
    String? errorMessage,
  }) {
    return RefinementState(
      status: status ?? this.status,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
    );
  }
  @override
  List<Object?> get props => [status, currentQuestion, messages, errorMessage];
}
