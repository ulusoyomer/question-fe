import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
import 'package:ai_question_generator/features/similar_questions/domain/usecases/generate_similar_questions_usecase.dart';
import 'package:ai_question_generator/features/similar_questions/presentation/bloc/similar_questions_event.dart';
import 'package:ai_question_generator/features/similar_questions/presentation/bloc/similar_questions_state.dart';
class SimilarQuestionsBloc extends Bloc<SimilarQuestionsEvent, SimilarQuestionsState> {
  final GenerateSimilarQuestionsUseCase generateUseCase;
  final ImagePicker _picker = ImagePicker();
  SimilarQuestionsBloc({required this.generateUseCase}) : super(const SimilarQuestionsState()) {
    on<InputTextChanged>(_onInputTextChanged);
    on<SetOriginalQuestion>(_onSetOriginalQuestion);
    on<PromptChanged>(_onPromptChanged);
    on<ImageSelected>(_onImageSelected);
    on<RemoveImage>(_onRemoveImage);
    on<GenerateSimilarQuestions>(_onGenerateSimilarQuestions);
  }
  void _onInputTextChanged(InputTextChanged event, Emitter<SimilarQuestionsState> emit) {
    emit(state.copyWith(inputText: event.text));
  }
  void _onSetOriginalQuestion(SetOriginalQuestion event, Emitter<SimilarQuestionsState> emit) {
    emit(state.copyWith(originalQuestion: event.question));
  }
  void _onPromptChanged(PromptChanged event, Emitter<SimilarQuestionsState> emit) {
    emit(state.copyWith(prompt: event.prompt));
  }
  Future<void> _onImageSelected(ImageSelected event, Emitter<SimilarQuestionsState> emit) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        emit(state.copyWith(selectedImage: image));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SimilarQuestionsStatus.error,
        errorMessage: "Failed to pick image: ${e.toString()}",
      ));
    }
  }
  void _onRemoveImage(RemoveImage event, Emitter<SimilarQuestionsState> emit) {
    emit(state.copyWith(clearImage: true));
  }
  Future<void> _onGenerateSimilarQuestions(GenerateSimilarQuestions event, Emitter<SimilarQuestionsState> emit) async {
    if (!state.isValidToGenerate) {
      emit(state.copyWith(
        status: SimilarQuestionsStatus.error,
        errorMessage: "Please enter text or upload an image first.",
      ));
      return;
    }
    emit(state.copyWith(status: SimilarQuestionsStatus.loading));
    String? textToSend;
    if (state.originalQuestion != null) {
      textToSend = _buildQuestionText(state.originalQuestion!, state.prompt);
    } else {
      textToSend = state.inputText.isNotEmpty ? state.inputText : null;
    }
    final result = await generateUseCase(
      text: textToSend,
      image: state.selectedImage,
      count: event.count,
    );
    result.fold(
      (error) => emit(state.copyWith(
        status: SimilarQuestionsStatus.error,
        errorMessage: error.toString(),
      )),
      (questions) => emit(state.copyWith(
        status: SimilarQuestionsStatus.loaded,
        generatedQuestions: questions,
      )),
    );
  }
  String _buildQuestionText(Question question, String prompt) {
    final buffer = StringBuffer();
    buffer.writeln('Orijinal Soru:');
    buffer.writeln(question.questionText);
    if (question is MCQQuestion) {
      buffer.writeln('\nŞıklar:');
      for (int i = 0; i < question.options.length; i++) {
        final isCorrect = question.options[i] == question.correctAnswer;
        buffer.writeln('${String.fromCharCode(65 + i)}) ${question.options[i]}${isCorrect ? ' (Doğru Cevap)' : ''}');
      }
    } else if (question is OpenEndedQuestion) {
      buffer.writeln('\nÖrnek Cevap:');
      buffer.writeln(question.sampleAnswer);
    }
    if (question.explanation.isNotEmpty) {
      buffer.writeln('\nAçıklama:');
      buffer.writeln(question.explanation);
    }
    if (prompt.isNotEmpty) {
      buffer.writeln('\n---\nKullanıcı İsteği: $prompt');
    }
    return buffer.toString();
  }
}
