class AppConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost',
  );
  static const String generateFromPdfEndpoint = '/api/generate-from-pdf';
  static const String generateSimilarEndpoint = '/api/generate-similar';
  static const String refineQuestionEndpoint = '/api/refine-question';
  static const int maxQuestionsCount = 20;
  static const int minQuestionsCount = 1;
  static const int defaultQuestionsCount = 5;
  static const List<String> allowedFileExtensions = ['pdf'];
  static const int maxFileSizeBytes = 10 * 1024 * 1024; 
  static const Duration apiTimeout = Duration(seconds: 60);
  static const Duration connectionTimeout = Duration(seconds: 30);
}
