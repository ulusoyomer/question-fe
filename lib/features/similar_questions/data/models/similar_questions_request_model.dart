import 'package:equatable/equatable.dart';
class SimilarQuestionsRequestModel extends Equatable {
  final String? questionText;
  final String? imageBase64;
  final int count;
  const SimilarQuestionsRequestModel({
    this.questionText,
    this.imageBase64,
    required this.count,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'count': count};
    if (questionText != null && questionText!.isNotEmpty) {
      data['question_text'] = questionText;
    }
    if (imageBase64 != null) {
      data['image_base64'] = imageBase64;
    }
    return data;
  }
  @override
  List<Object?> get props => [questionText, imageBase64, count];
}
