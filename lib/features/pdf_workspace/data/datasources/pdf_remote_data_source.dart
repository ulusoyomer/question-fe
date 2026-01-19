import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:ai_question_generator/core/network/api_client.dart';
import 'package:ai_question_generator/core/utils/constants.dart';
import 'package:ai_question_generator/shared/data/models/question_model.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
abstract class PdfRemoteDataSource {
  Future<List<QuestionModel>> generateFromPdf(PlatformFile pdfFile, QuestionType type, int count);
}
class PdfRemoteDataSourceImpl implements PdfRemoteDataSource {
  final ApiClient apiClient;
  PdfRemoteDataSourceImpl(this.apiClient);
  @override
  Future<List<QuestionModel>> generateFromPdf(PlatformFile pdfFile, QuestionType type, int count) async {
    MultipartFile multipartFile;
    if (pdfFile.bytes != null) {
      multipartFile = MultipartFile.fromBytes(pdfFile.bytes!, filename: pdfFile.name);
    } else if (pdfFile.path != null) {
      multipartFile = await MultipartFile.fromFile(pdfFile.path!, filename: pdfFile.name);
    } else {
      throw Exception('File content is empty');
    }
    final formData = FormData.fromMap({
      'file': multipartFile,
      'question_type': type == QuestionType.mcq ? 'mcq' : 'open_ended',
      'count': count,
    });
    final response = await apiClient.postFormData(
      AppConstants.generateFromPdfEndpoint,
      formData,
    );
    final data = response.data;
    if (data != null && data['questions'] != null) {
      return (data['questions'] as List)
          .map((q) => QuestionModel.fromJson(q))
          .toList();
    } else {
      throw Exception('Invalid response format');
    }
  }
}
