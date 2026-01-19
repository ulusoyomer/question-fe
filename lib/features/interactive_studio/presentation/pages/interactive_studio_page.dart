import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ai_question_generator/core/di/injection.dart';
import 'package:ai_question_generator/core/theme/app_colors.dart';
import 'package:ai_question_generator/features/pdf_workspace/domain/entities/question_entity.dart';
import 'package:ai_question_generator/features/interactive_studio/presentation/bloc/refinement_bloc.dart';
import 'package:ai_question_generator/features/interactive_studio/presentation/bloc/refinement_event.dart';
import 'package:ai_question_generator/features/interactive_studio/presentation/bloc/refinement_state.dart';
import 'package:ai_question_generator/generated/locale_keys.g.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:auto_route/auto_route.dart';
@RoutePage()
class InteractiveStudioPage extends StatelessWidget {
  final Question? initialQuestion;
  const InteractiveStudioPage({super.key, this.initialQuestion});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<RefinementBloc>();
        if (initialQuestion != null) {
          bloc.add(LoadQuestionEvent(initialQuestion!));
        }
        return bloc;
      },
      child: InteractiveStudioView(hasInitialQuestion: initialQuestion != null),
    );
  }
}
class InteractiveStudioView extends StatelessWidget {
  final bool hasInitialQuestion;
  const InteractiveStudioView({super.key, this.hasInitialQuestion = false});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(LocaleKeys.studio_title.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (hasInitialQuestion)
            BlocBuilder<RefinementBloc, RefinementState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    context.router.pop(state.currentQuestion);
                  },
                );
              },
            ),
        ],
      ),
      body: hasInitialQuestion
          ? LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return const _DesktopLayout();
                } else {
                  return _MobileLayout();
                }
              },
            )
          : _buildEmptyState(context),
    );
  }
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_fix_high,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              'İnteraktif Stüdyo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Oluşturulmuş bir soruyu düzenlemek için\nPDF Generator sayfasından bir soru seçin\nve "Düzenle" butonuna basın.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Geri Dön'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: const Color(0xFFF5F5FA),
            padding: const EdgeInsets.all(32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: const _QuestionCanvasCard(),
              ),
            ),
          ),
        ),
        VerticalDivider(width: 1, color: Colors.grey.shade300),
        const Expanded(
          flex: 2,
          child: _ChatPanel(),
        ),
      ],
    );
  }
}
class _MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: LocaleKeys.studio_view_question.tr()),
              Tab(text: LocaleKeys.studio_refine_chat.tr()),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                _QuestionCanvasCard(isMobile: true),
                _ChatPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _QuestionCanvasCard extends StatelessWidget {
  final bool isMobile;
  const _QuestionCanvasCard({this.isMobile = false});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefinementBloc, RefinementState>(
      builder: (context, state) {
        final question = state.currentQuestion;
        if (question == null) return const Center(child: CircularProgressIndicator());
        return SingleChildScrollView(
          padding: isMobile ? const EdgeInsets.all(16) : EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(question),
                const SizedBox(height: 24),
                Text(
                  question.questionText,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.5),
                ),
                const SizedBox(height: 32),
                if (question is MCQQuestion)
                  ...question.options.asMap().entries.map((entry) => _buildOption(entry.key, entry.value, question.correctAnswer))
                else if (question is OpenEndedQuestion)
                  _buildOpenEndedAnswer(context, question.sampleAnswer),
                const SizedBox(height: 32),
                _buildExplanation(context, question.explanation),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildHeader(Question question) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Chip(
          label: Text(question.difficulty.name.toUpperCase()),
          backgroundColor: _getDifficultyColor(question.difficulty).withOpacity(0.1),
          labelStyle: TextStyle(
            color: _getDifficultyColor(question.difficulty),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
          child: Icon(_getTypeIcon(question.type), size: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }
  Widget _buildOption(int index, String text, String correctAnswer) {
    final isCorrect = text == correctAnswer;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withOpacity(0.05) : Colors.white,
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.grey.shade200,
          width: isCorrect ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isCorrect ? Colors.green : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Text(
              String.fromCharCode(65 + index),
              style: TextStyle(
                color: isCorrect ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
          if (isCorrect) const Icon(Icons.check, color: Colors.green),
        ],
      ),
    );
  }
  Widget _buildOpenEndedAnswer(BuildContext context, String answer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.studio_sample_answer.tr(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          MarkdownBody(data: answer),
        ],
      ),
    );
  }
  Widget _buildExplanation(BuildContext context, String explanation) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Text(LocaleKeys.studio_explanation.tr(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 8),
            Text(explanation, style: TextStyle(color: Colors.blue.shade900, height: 1.4)),
          ],
        ),
      );
  }
  Color _getDifficultyColor(QuestionDifficulty difficulty) {
    switch (difficulty) {
      case QuestionDifficulty.easy: return Colors.green;
      case QuestionDifficulty.medium: return Colors.orange;
      case QuestionDifficulty.hard: return Colors.red;
    }
  }
  IconData _getTypeIcon(QuestionType type) {
    return type == QuestionType.mcq ? Icons.list : Icons.text_fields;
  }
}
class _ChatPanel extends StatefulWidget {
  const _ChatPanel();
  @override
  State<_ChatPanel> createState() => _ChatPanelState();
}
class _ChatPanelState extends State<_ChatPanel> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<RefinementBloc, RefinementState>(
            builder: (context, state) {
              if (state.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(LocaleKeys.studio_help_text.tr(), style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                 if (_scrollController.hasClients) {
                   _scrollController.animateTo(
                     _scrollController.position.maxScrollExtent,
                     duration: const Duration(milliseconds: 300),
                     curve: Curves.easeOut,
                   );
                 }
              });
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: state.messages.length + (state.status == RefinementStatus.loading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.messages.length) {
                    return const _LoadingBubble();
                  }
                  final message = state.messages[index];
                  return _ChatBubble(message: message);
                },
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.studio_input_hint.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onSubmitted: _sendMessage,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                color: AppColors.primary,
                onPressed: () => _sendMessage(_controller.text),
              ),
            ],
          ),
        ),
      ],
    );
  }
  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    context.read<RefinementBloc>().add(SendRefinementMessageEvent(text));
    _controller.clear();
  }
}
class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const _ChatBubble({required this.message});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: message.isUser ? Radius.zero : const Radius.circular(16),
            bottomLeft: !message.isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
class _LoadingBubble extends StatelessWidget {
  const _LoadingBubble();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.zero,
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: const SizedBox(
          width: 24,
          height: 12,
          child: Center(child: Text("...", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }
}
