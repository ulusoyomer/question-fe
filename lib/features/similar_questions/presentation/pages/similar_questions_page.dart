import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ai_question_generator/core/di/injection.dart';
import 'package:ai_question_generator/core/theme/app_colors.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
import 'package:ai_question_generator/features/similar_questions/presentation/bloc/similar_questions_bloc.dart';
import 'package:ai_question_generator/features/similar_questions/presentation/bloc/similar_questions_event.dart';
import 'package:ai_question_generator/features/similar_questions/presentation/bloc/similar_questions_state.dart';
import 'package:ai_question_generator/generated/locale_keys.g.dart';
import 'package:auto_route/auto_route.dart';
@RoutePage()
class SimilarQuestionsPage extends StatefulWidget {
  final Question? originalQuestion;
  const SimilarQuestionsPage({super.key, this.originalQuestion});
  @override
  State<SimilarQuestionsPage> createState() => _SimilarQuestionsPageState();
}
class _SimilarQuestionsPageState extends State<SimilarQuestionsPage> {
  late final TextEditingController _textController;
  late final TextEditingController _promptController;
  late final SimilarQuestionsBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = getIt<SimilarQuestionsBloc>();
    _promptController = TextEditingController();
    if (widget.originalQuestion != null) {
      _textController = TextEditingController();
      _bloc.add(SetOriginalQuestion(widget.originalQuestion!));
    } else {
      _textController = TextEditingController();
    }
  }
  @override
  void dispose() {
    _textController.dispose();
    _promptController.dispose();
    _bloc.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(LocaleKeys.clone_title.tr()),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocConsumer<SimilarQuestionsBloc, SimilarQuestionsState>(
          listener: (context, state) {
            if (state.status == SimilarQuestionsStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? LocaleKeys.common_error.tr())),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.originalQuestion != null) ...[
                    _buildOriginalQuestionCard(widget.originalQuestion!),
                    const SizedBox(height: 24),
                    _buildPromptSection(context, state),
                  ] else ...[
                    _buildManualInputSection(context, state),
                  ],
                  const SizedBox(height: 24),
                  _buildGenerateButton(context, state),
                  if (state.status == SimilarQuestionsStatus.loaded) ...[
                    const SizedBox(height: 32),
                    _buildResultsSection(state),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _buildOriginalQuestionCard(Question question) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ORİJİNAL SORU',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.lock_outline, size: 16, color: Colors.grey.shade400),
            ],
          ),
          const SizedBox(height: 16),
          if (question.imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildQuestionImage(question.imageUrl!),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            question.questionText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: AppColors.textPrimary,
            ),
          ),
          if (question is MCQQuestion) ...[
            const SizedBox(height: 16),
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isCorrect = option == question.correctAnswer;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isCorrect ? Colors.green.withOpacity(0.1) : AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCorrect ? Colors.green.withOpacity(0.5) : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isCorrect ? Colors.green : Colors.transparent,
                        border: Border.all(
                          color: isCorrect ? Colors.green : AppColors.textTertiary,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        String.fromCharCode(65 + index),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isCorrect ? Colors.white : AppColors.textTertiary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14,
                          color: isCorrect ? Colors.green.shade800 : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isCorrect)
                      const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  ],
                ),
              );
            }),
          ] else if (question is OpenEndedQuestion) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Örnek Cevap:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.sampleAnswer,
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildPromptSection(BuildContext context, SimilarQuestionsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NASIL DEĞİŞTİRELİM?',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textTertiary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPromptChip('Daha zor yap', Icons.trending_up),
            _buildPromptChip('Daha kolay yap', Icons.trending_down),
            _buildPromptChip('Farklı konu', Icons.shuffle),
            _buildPromptChip('Benzer ama farklı', Icons.copy_all),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _promptController,
          onChanged: (text) => context.read<SimilarQuestionsBloc>().add(PromptChanged(text)),
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Örn: "Daha zor yap ve şıkları karıştır" veya "Aynı konuda farklı bir soru oluştur"',
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildPromptChip(String label, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onPressed: () {
        _promptController.text = label;
        _bloc.add(PromptChanged(label));
      },
      backgroundColor: AppColors.surface,
      side: BorderSide(color: AppColors.border),
    );
  }
  Widget _buildManualInputSection(BuildContext context, SimilarQuestionsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.clone_input_question.tr(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textTertiary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _textController,
          onChanged: (text) => context.read<SimilarQuestionsBloc>().add(InputTextChanged(text)),
          maxLines: 5,
          decoration: InputDecoration(
            hintText: LocaleKeys.clone_hint.tr(),
            filled: true,
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => context.read<SimilarQuestionsBloc>().add(const ImageSelected()),
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              dashPattern: const [8, 4],
              radius: const Radius.circular(12),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: AppColors.surface,
              child: state.selectedImage != null
                  ? Column(
                      children: [
                        if (kIsWeb)
                          Image.network(state.selectedImage!.path, height: 100)
                        else
                          Image.file(File(state.selectedImage!.path), height: 100),
                        const SizedBox(height: 8),
                        Text(state.selectedImage!.name),
                        TextButton(
                          onPressed: () => context.read<SimilarQuestionsBloc>().add(const RemoveImage()),
                          child: Text(LocaleKeys.clone_remove_image.tr(), style: const TextStyle(color: Colors.red)),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const Icon(Icons.add_a_photo_outlined, size: 32, color: AppColors.textSecondary),
                        const SizedBox(height: 8),
                        Text(LocaleKeys.clone_upload_screenshot.tr(), style: const TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildGenerateButton(BuildContext context, SimilarQuestionsState state) {
    final hasOriginalQuestion = widget.originalQuestion != null;
    final canGenerate = hasOriginalQuestion || state.isValidToGenerate;
    return ElevatedButton(
      onPressed: state.status == SimilarQuestionsStatus.loading || !canGenerate
          ? null
          : () {
              context.read<SimilarQuestionsBloc>().add(const GenerateSimilarQuestions());
            },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: state.status == SimilarQuestionsStatus.loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome),
                const SizedBox(width: 8),
                Text(
                  LocaleKeys.clone_generate.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
    );
  }
  Widget _buildResultsSection(SimilarQuestionsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.clone_generated_twins.tr(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textTertiary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.generatedQuestions.length,
          itemBuilder: (context, index) {
            final question = state.generatedQuestions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${LocaleKeys.clone_variation.tr()} ${index + 1}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (question.imageUrl != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildQuestionImage(question.imageUrl!),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Text(
                      question.questionText,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    if (question is MCQQuestion)
                      ...question.options.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final option = entry.value;
                        final isCorrect = option == question.correctAnswer;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isCorrect ? Colors.green : Colors.transparent,
                                  border: Border.all(
                                    color: isCorrect ? Colors.green : Colors.grey,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  String.fromCharCode(65 + idx),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isCorrect ? Colors.white : Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: isCorrect ? Colors.green.shade700 : null,
                                    fontWeight: isCorrect ? FontWeight.w500 : null,
                                  ),
                                ),
                              ),
                              if (isCorrect)
                                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  Widget _buildQuestionImage(String imageUrl) {
    if (imageUrl.startsWith('data:image')) {
      try {
        final base64String = imageUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildImageError();
          },
        );
      } catch (e) {
        return _buildImageError();
      }
    } else {
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildImageError();
        },
      );
    }
  }
  Widget _buildImageError() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.broken_image, color: Colors.grey),
          SizedBox(width: 8),
          Text('Görsel yüklenemedi', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
