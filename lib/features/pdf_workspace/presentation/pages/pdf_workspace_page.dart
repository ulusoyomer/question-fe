import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ai_question_generator/core/di/injection.dart';
import 'package:ai_question_generator/core/theme/app_colors.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
import 'package:ai_question_generator/features/pdf_workspace/presentation/bloc/pdf_workspace_bloc.dart';
import 'package:ai_question_generator/features/pdf_workspace/presentation/bloc/pdf_workspace_event.dart';
import 'package:ai_question_generator/features/pdf_workspace/presentation/bloc/pdf_workspace_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ai_question_generator/core/router/app_router.dart';
import 'package:ai_question_generator/generated/locale_keys.g.dart';
import 'package:ai_question_generator/shared/widgets/confidence_score_indicator.dart';
@RoutePage()
class PdfWorkspacePage extends StatefulWidget {
  final int? sessionId;
  const PdfWorkspacePage({super.key, this.sessionId});
  @override
  State<PdfWorkspacePage> createState() => _PdfWorkspacePageState();
}
class _PdfWorkspacePageState extends State<PdfWorkspacePage> {
  late PdfWorkspaceBloc _bloc;
  int? _loadedSessionId;
  @override
  void initState() {
    super.initState();
    _bloc = getIt<PdfWorkspaceBloc>();
    _loadSessionIfNeeded();
  }
  @override
  void didUpdateWidget(covariant PdfWorkspacePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sessionId != oldWidget.sessionId) {
      _loadSessionIfNeeded();
    }
  }
  void _loadSessionIfNeeded() {
    if (widget.sessionId != null && widget.sessionId != _loadedSessionId) {
      _loadedSessionId = widget.sessionId;
      _bloc.add(LoadSessionEvent(widget.sessionId!));
    }
  }
  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: const PdfWorkspaceView(),
    );
  }
}
class PdfWorkspaceView extends StatelessWidget {
  const PdfWorkspaceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(LocaleKeys.pdf_title.tr()),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<PdfWorkspaceBloc, PdfWorkspaceState>(
        listener: (context, state) {
          if (state.status == PdfWorkspaceStatus.error) {
            final errorMsg = state.errorMessage ?? LocaleKeys.pdf_error_occurred.tr();
            if (errorMsg.contains("Authentication") || errorMsg.contains("401") || errorMsg.contains("Quota") || errorMsg.contains("429")) {
               _showErrorDialog(context, LocaleKeys.pdf_access_error.tr(), errorMsg);
            } else {
               _showErrorSnackBar(context, errorMsg);
            }
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildUploadSection(context, state),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.pdf_configuration.tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textTertiary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildQuestionTypeSelector(context, state),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      _buildCountSelector(context, state),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: state.status == PdfWorkspaceStatus.loading || state.selectedFile == null
                      ? null
                      : () {
                          context.read<PdfWorkspaceBloc>().add(const GenerateQuestionsEvent());
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: state.status == PdfWorkspaceStatus.loading
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
                            Text(LocaleKeys.pdf_generate.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                ),
                if (state.status == PdfWorkspaceStatus.loaded) ...[
                  const SizedBox(height: 32),
                  _buildResultsHeader(context, state.generatedQuestions.length),
                  const SizedBox(height: 16),
                  _buildQuestionsList(state.generatedQuestions),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
  Widget _buildUploadSection(BuildContext context, PdfWorkspaceState state) {
    return GestureDetector(
      onTap: () {
        context.read<PdfWorkspaceBloc>().add(const UploadPdfEvent());
      },
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          strokeWidth: 2,
          dashPattern: const [8, 4],
          radius: const Radius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: state.selectedFile != null
              ? Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.selectedFile!.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${(state.selectedFile!.size / 1024).toStringAsFixed(1)} KB",
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                         context.read<PdfWorkspaceBloc>().add(const RemovePdfEvent());
                      },
                      icon: const Icon(Icons.close, color: AppColors.accentError),
                      label: Text(LocaleKeys.pdf_remove.tr(), style: const TextStyle(color: AppColors.accentError)),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.cloud_upload, size: 40, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LocaleKeys.pdf_upload_title.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      LocaleKeys.pdf_upload_subtitle.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        LocaleKeys.pdf_browse.tr(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
  Widget _buildQuestionTypeSelector(BuildContext context, PdfWorkspaceState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.quiz, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(LocaleKeys.pdf_multiple_choice.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
        Switch.adaptive(
          value: state.questionType == QuestionType.mcq,
          activeColor: AppColors.primary,
          onChanged: (value) {
            context.read<PdfWorkspaceBloc>().add(
              ChangeQuestionTypeEvent(value ? QuestionType.mcq : QuestionType.openEnded),
            );
          },
        ),
      ],
    );
  }
  Widget _buildCountSelector(BuildContext context, PdfWorkspaceState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.format_list_numbered, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(LocaleKeys.pdf_question_count.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18, color: AppColors.primary),
                onPressed: state.questionCount > 1
                    ? () {
                        context.read<PdfWorkspaceBloc>().add(ChangeQuestionCountEvent(state.questionCount - 1));
                      }
                    : null,
              ),
              Container(
                width: 32,
                alignment: Alignment.center,
                child: Text(
                  state.questionCount.toString(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
                onPressed: state.questionCount < 20
                    ? () {
                        context.read<PdfWorkspaceBloc>().add(ChangeQuestionCountEvent(state.questionCount + 1));
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildResultsHeader(BuildContext context, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocaleKeys.pdf_draft_questions.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            "$count ${LocaleKeys.pdf_ready.tr()}",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildQuestionsList(List<Question> questions) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
           child: _buildQuestionCard(context, question, index + 1),
        );
      },
    );
  }
  Widget _buildQuestionCard(BuildContext context, Question question, int index) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "${LocaleKeys.pdf_question.tr()} $index",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textTertiary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ConfidenceScoreBadge(score: question.confidenceScore),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textTertiary),
                    onPressed: () async {
                      final refinedQuestion = await context.router.push<Question>(
                        InteractiveStudioRoute(initialQuestion: question),
                      );
                      if (refinedQuestion != null && context.mounted) {
                        context.read<PdfWorkspaceBloc>().add(
                          UpdateQuestionEvent(index - 1, refinedQuestion),
                        );
                      }
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.copy_all_rounded, size: 20, color: AppColors.textTertiary),
                    onPressed: () {
                      context.router.push(SimilarQuestionsRoute(originalQuestion: question));
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: LocaleKeys.clone_title.tr(),
                  ),
                ],
              ),
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
            ),
          ),
          const SizedBox(height: 20),
          if (question is MCQQuestion)
            ...question.options.asMap().entries.map((entry) {
              final isCorrect = entry.value == question.correctAnswer;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCorrect ? Colors.green.withOpacity(0.1) : AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCorrect ? Colors.green.withOpacity(0.5) : AppColors.border,
                    width: isCorrect ? 1.5 : 1,
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
                        String.fromCharCode(65 + entry.key), 
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
                        entry.value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isCorrect ? FontWeight.w500 : FontWeight.normal,
                          color: isCorrect ? Colors.green.shade800 : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isCorrect)
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  ],
                ),
              );
            }).toList()
          else if (question is OpenEndedQuestion)
             Container(
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(
                 color: AppColors.background,
                 borderRadius: BorderRadius.circular(8),
                 border: Border.all(color: AppColors.border),
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(LocaleKeys.pdf_sample_answer.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                   const SizedBox(height: 8),
                   Text(question.sampleAnswer),
                 ],
               ),
             ),
          const SizedBox(height: 16),
          ExpansionTile(
            title: Text(
              LocaleKeys.pdf_show_explanation.tr(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            childrenPadding: EdgeInsets.zero,
            tilePadding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  question.explanation,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: Text(LocaleKeys.pdf_add_to_quiz.tr()),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            ),
          ),
        ],
      ),
    );
  }
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.gpp_bad_outlined, color: Colors.red, size: 28),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(color: Colors.red)),
          ],
        ),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.pdf_understand.tr()),
          ),
        ],
      ),
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
