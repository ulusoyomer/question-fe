
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/usecases/generate_questions_usecase.dart';
import 'package:ai_question_generator/features/history/domain/usecases/get_session_details_usecase.dart';
import 'package:ai_question_generator/features/pdf_workspace/presentation/bloc/pdf_workspace_event.dart';
import 'package:ai_question_generator/features/pdf_workspace/presentation/bloc/pdf_workspace_state.dart';
class PdfWorkspaceBloc extends Bloc<PdfWorkspaceEvent, PdfWorkspaceState> {
  final GenerateQuestionsFromPdfUseCase generateQuestionsUseCase;
  final GetSessionDetailsUseCase getSessionDetailsUseCase;
  PdfWorkspaceBloc({
    required this.generateQuestionsUseCase,
    required this.getSessionDetailsUseCase,
  }) : super(const PdfWorkspaceState()) {
    on<UploadPdfEvent>(_onUploadPdf);
    on<RemovePdfEvent>(_onRemovePdf);
    on<ChangeQuestionTypeEvent>(_onChangeQuestionType);
    on<ChangeQuestionCountEvent>(_onChangeQuestionCount);
    on<GenerateQuestionsEvent>(_onGenerateQuestions);
    on<UpdateQuestionEvent>(_onUpdateQuestion);
    on<LoadSessionEvent>(_onLoadSession);
  }
  Future<void> _onUploadPdf(UploadPdfEvent event, Emitter<PdfWorkspaceState> emit) async {
    emit(state.copyWith(status: PdfWorkspaceStatus.selectingFile));
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        emit(state.copyWith(
          status: PdfWorkspaceStatus.initial,
          selectedFile: result.files.first,
        ));
      } else {
        emit(state.copyWith(status: PdfWorkspaceStatus.initial));
      }
    } catch (e) {
      emit(state.copyWith(
        status: PdfWorkspaceStatus.error,
        errorMessage: "Failed to pick file: ${e.toString()}",
      ));
    }
  }
  void _onRemovePdf(RemovePdfEvent event, Emitter<PdfWorkspaceState> emit) {
    emit(state.copyWith(clearFile: true, status: PdfWorkspaceStatus.initial));
  }
  void _onChangeQuestionType(ChangeQuestionTypeEvent event, Emitter<PdfWorkspaceState> emit) {
    emit(state.copyWith(questionType: event.type));
  }
  void _onChangeQuestionCount(ChangeQuestionCountEvent event, Emitter<PdfWorkspaceState> emit) {
    emit(state.copyWith(questionCount: event.count));
  }
  Future<void> _onGenerateQuestions(GenerateQuestionsEvent event, Emitter<PdfWorkspaceState> emit) async {
    if (state.selectedFile == null) {
      emit(state.copyWith(
        status: PdfWorkspaceStatus.error,
        errorMessage: "Please upload a PDF file first.",
      ));
      return;
    }
    emit(state.copyWith(status: PdfWorkspaceStatus.loading));
    final result = await generateQuestionsUseCase(
      pdfFile: state.selectedFile!,
      type: state.questionType,
      count: state.questionCount,
    );
    result.fold(
      (error) => emit(state.copyWith(
        status: PdfWorkspaceStatus.error,
        errorMessage: error.toString(),
      )),
      (questions) => emit(state.copyWith(
        status: PdfWorkspaceStatus.loaded,
        generatedQuestions: questions,
      )),
    );
  }
  void _onUpdateQuestion(UpdateQuestionEvent event, Emitter<PdfWorkspaceState> emit) {
    final updatedQuestions = List.of(state.generatedQuestions);
    if (event.index >= 0 && event.index < updatedQuestions.length) {
      updatedQuestions[event.index] = event.updatedQuestion;
      emit(state.copyWith(generatedQuestions: updatedQuestions));
    }
  }
  Future<void> _onLoadSession(LoadSessionEvent event, Emitter<PdfWorkspaceState> emit) async {
    emit(state.copyWith(status: PdfWorkspaceStatus.loading));
    final result = await getSessionDetailsUseCase(event.sessionId);
    result.fold(
      (error) => emit(state.copyWith(
        status: PdfWorkspaceStatus.error,
        errorMessage: error.toString(),
      )),
      (session) => emit(state.copyWith(
        status: PdfWorkspaceStatus.loaded,
        generatedQuestions: session.questions ?? [],
      )),
    );
  }
}
