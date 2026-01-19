import 'package:get_it/get_it.dart';
import 'package:ai_question_generator/core/network/api_client.dart';
import 'package:ai_question_generator/features/pdf_workspace/data/repositories/question_repository_impl.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/repositories/question_repository.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/usecases/generate_questions_usecase.dart';
import 'package:ai_question_generator/features/pdf_workspace/presentation/bloc/pdf_workspace_bloc.dart';
import 'package:ai_question_generator/features/similar_questions/data/repositories/similar_questions_repository_impl.dart';
import 'package:ai_question_generator/features/similar_questions/domain/repositories/similar_questions_repository.dart';
import 'package:ai_question_generator/features/similar_questions/domain/usecases/generate_similar_questions_usecase.dart';
import 'package:ai_question_generator/features/similar_questions/presentation/bloc/similar_questions_bloc.dart';
import 'package:ai_question_generator/features/interactive_studio/data/repositories/refinement_repository_impl.dart';
import 'package:ai_question_generator/features/interactive_studio/domain/repositories/refinement_repository.dart';
import 'package:ai_question_generator/features/interactive_studio/domain/usecases/refine_question_usecase.dart';
import 'package:ai_question_generator/features/interactive_studio/presentation/bloc/refinement_bloc.dart';
import 'package:ai_question_generator/features/pdf_workspace/data/datasources/pdf_remote_data_source.dart';
import 'package:ai_question_generator/features/similar_questions/data/datasources/similar_questions_remote_data_source.dart';
import 'package:ai_question_generator/features/interactive_studio/data/datasources/refinement_remote_data_source.dart';
import 'package:ai_question_generator/features/history/data/datasources/history_remote_data_source.dart';
import 'package:ai_question_generator/features/history/data/repositories/history_repository_impl.dart';
import 'package:ai_question_generator/features/history/domain/repositories/history_repository.dart';
import 'package:ai_question_generator/features/history/domain/usecases/get_history_sessions_usecase.dart';
import 'package:ai_question_generator/features/history/domain/usecases/get_session_details_usecase.dart';
import 'package:ai_question_generator/features/history/domain/usecases/delete_session_usecase.dart';
import 'package:ai_question_generator/features/history/presentation/bloc/history_bloc.dart';
final getIt = GetIt.instance;
Future<void> configureDependencies() async {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  registerDataSource();
  registerRepository();
  registerUseCase();
  registerBlocs();
}
void registerDataSource() {
  getIt.registerLazySingleton<PdfRemoteDataSource>(
    () => PdfRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<SimilarQuestionsRemoteDataSource>(
    () => SimilarQuestionsRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<RefinementRemoteDataSource>(
    () => RefinementRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<HistoryRemoteDataSource>(
    () => HistoryRemoteDataSourceImpl(getIt<ApiClient>()),
  );
}
void registerRepository() {
  getIt.registerLazySingleton<QuestionRepository>(
    () => QuestionRepositoryImpl(getIt<PdfRemoteDataSource>()),
  );
  getIt.registerLazySingleton<SimilarQuestionsRepository>(
    () => SimilarQuestionsRepositoryImpl(
      getIt<SimilarQuestionsRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<RefinementRepository>(
    () => RefinementRepositoryImpl(getIt<RefinementRemoteDataSource>()),
  );
  getIt.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(getIt<HistoryRemoteDataSource>()),
  );
}
void registerUseCase() {
  getIt.registerLazySingleton<GenerateQuestionsFromPdfUseCase>(
    () => GenerateQuestionsFromPdfUseCase(getIt<QuestionRepository>()),
  );
  getIt.registerLazySingleton<GenerateSimilarQuestionsUseCase>(
    () => GenerateSimilarQuestionsUseCase(getIt<SimilarQuestionsRepository>()),
  );
  getIt.registerLazySingleton<RefineQuestionUseCase>(
    () => RefineQuestionUseCase(getIt<RefinementRepository>()),
  );
  getIt.registerLazySingleton<GetHistorySessionsUseCase>(
    () => GetHistorySessionsUseCase(getIt<HistoryRepository>()),
  );
  getIt.registerLazySingleton<GetSessionDetailsUseCase>(
    () => GetSessionDetailsUseCase(getIt<HistoryRepository>()),
  );
  getIt.registerLazySingleton<DeleteSessionUseCase>(
    () => DeleteSessionUseCase(getIt<HistoryRepository>()),
  );
}
void registerBlocs() {
  getIt.registerFactory<PdfWorkspaceBloc>(
    () => PdfWorkspaceBloc(
      generateQuestionsUseCase: getIt<GenerateQuestionsFromPdfUseCase>(),
      getSessionDetailsUseCase: getIt<GetSessionDetailsUseCase>(),
    ),
  );
  getIt.registerFactory<SimilarQuestionsBloc>(
    () => SimilarQuestionsBloc(
      generateUseCase: getIt<GenerateSimilarQuestionsUseCase>(),
    ),
  );
  getIt.registerFactory<RefinementBloc>(
    () => RefinementBloc(refineQuestionUseCase: getIt<RefineQuestionUseCase>()),
  );
  getIt.registerFactory<HistoryBloc>(
    () => HistoryBloc(
      getHistorySessionsUseCase: getIt<GetHistorySessionsUseCase>(),
      deleteSessionUseCase: getIt<DeleteSessionUseCase>(),
    ),
  );
}
void resetDependencies() {
  getIt.reset();
}
