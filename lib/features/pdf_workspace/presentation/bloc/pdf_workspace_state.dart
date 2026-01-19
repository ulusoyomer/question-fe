import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
enum PdfWorkspaceStatus { initial, selectingFile, loading, loaded, error }
class PdfWorkspaceState extends Equatable {
  final PdfWorkspaceStatus status;
  final PlatformFile? selectedFile;
  final QuestionType questionType;
  final int questionCount;
  final List<Question> generatedQuestions;
  final String? errorMessage;
  const PdfWorkspaceState({
    this.status = PdfWorkspaceStatus.initial,
    this.selectedFile,
    this.questionType = QuestionType.mcq,
    this.questionCount = 5,
    this.generatedQuestions = const [],
    this.errorMessage,
  });
  PdfWorkspaceState copyWith({
    PdfWorkspaceStatus? status,
    PlatformFile? selectedFile,
    bool clearFile = false, 
    QuestionType? questionType,
    int? questionCount,
    List<Question>? generatedQuestions,
    String? errorMessage,
  }) {
    return PdfWorkspaceState(
      status: status ?? this.status,
      selectedFile: clearFile ? null : (selectedFile ?? this.selectedFile),
      questionType: questionType ?? this.questionType,
      questionCount: questionCount ?? this.questionCount,
      generatedQuestions: generatedQuestions ?? this.generatedQuestions,
      errorMessage: errorMessage, 
    );
  }
  @override
  List<Object?> get props => [
    status, 
    selectedFile, 
    questionType, 
    questionCount, 
    generatedQuestions, 
    errorMessage
  ];
}
