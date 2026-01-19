import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
enum SimilarQuestionsStatus { initial, loading, loaded, error }
class SimilarQuestionsState extends Equatable {
  final SimilarQuestionsStatus status;
  final String inputText;
  final String prompt;
  final Question? originalQuestion;
  final XFile? selectedImage;
  final List<Question> generatedQuestions;
  final String? errorMessage;
  const SimilarQuestionsState({
    this.status = SimilarQuestionsStatus.initial,
    this.inputText = '',
    this.prompt = '',
    this.originalQuestion,
    this.selectedImage,
    this.generatedQuestions = const [],
    this.errorMessage,
  });
  SimilarQuestionsState copyWith({
    SimilarQuestionsStatus? status,
    String? inputText,
    String? prompt,
    Question? originalQuestion,
    XFile? selectedImage,
    bool clearImage = false,
    List<Question>? generatedQuestions,
    String? errorMessage,
  }) {
    return SimilarQuestionsState(
      status: status ?? this.status,
      inputText: inputText ?? this.inputText,
      prompt: prompt ?? this.prompt,
      originalQuestion: originalQuestion ?? this.originalQuestion,
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      generatedQuestions: generatedQuestions ?? this.generatedQuestions,
      errorMessage: errorMessage,
    );
  }
  bool get isValidToGenerate =>
      inputText.isNotEmpty || selectedImage != null || originalQuestion != null;
  @override
  List<Object?> get props => [
        status,
        inputText,
        prompt,
        originalQuestion,
        selectedImage,
        generatedQuestions,
        errorMessage,
      ];
}
