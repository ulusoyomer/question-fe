import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_question_generator/core/theme/app_colors.dart';
import 'package:ai_question_generator/core/di/injection.dart';
import 'package:ai_question_generator/features/history/presentation/bloc/history_bloc.dart';
import 'package:ai_question_generator/features/history/presentation/bloc/history_event.dart';
import 'package:ai_question_generator/features/history/presentation/bloc/history_state.dart';
import 'package:ai_question_generator/features/history/domain/entities/history_session.dart';
import 'package:ai_question_generator/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
@RoutePage()
class HistoryPage extends StatelessWidget {
  final Function(int, {int? sessionId})? onTabChange;
  const HistoryPage({super.key, this.onTabChange});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HistoryBloc>()..add(const LoadHistoryEvent()),
      child: HistoryView(onTabChange: onTabChange),
    );
  }
}
class HistoryView extends StatelessWidget {
  final Function(int, {int? sessionId})? onTabChange;
  const HistoryView({super.key, this.onTabChange});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildFilterChips(context),
            Expanded(child: _buildHistoryList(context)),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.section_history.tr(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<HistoryBloc>().add(const RefreshHistoryEvent());
            },
            icon: const Icon(Icons.refresh, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
  Widget _buildFilterChips(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildFilterChip(
                context,
                label: 'All',
                filter: null,
                isSelected: state.currentFilter == null,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                label: 'PDF',
                filter: 'pdf',
                isSelected: state.currentFilter == 'pdf',
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                label: 'Style Clone',
                filter: 'similar',
                isSelected: state.currentFilter == 'similar',
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                label: 'Studio',
                filter: 'refinement',
                isSelected: state.currentFilter == 'refinement',
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required String? filter,
    required bool isSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        context.read<HistoryBloc>().add(LoadHistoryEvent(filter: filter));
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
  Widget _buildHistoryList(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state.status == HistoryStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == HistoryStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage ?? 'An error occurred',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<HistoryBloc>().add(const RefreshHistoryEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (state.sessions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  'No history yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start generating questions to see them here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.sessions.length,
          itemBuilder: (context, index) {
            return _buildSessionCard(context, state.sessions[index], onTabChange);
          },
        );
      },
    );
  }
  Widget _buildSessionCard(BuildContext context, HistorySession session, Function(int, {int? sessionId})? onTabChange) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          int targetTab = 1; 
          switch (session.sessionType) {
            case 'pdf':
              targetTab = 1; 
              break;
            case 'similar':
              targetTab = 1; 
              break;
            case 'refinement':
              targetTab = 1; 
              break;
          }
          onTabChange?.call(targetTab, sessionId: session.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTypeIcon(session.sessionType),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.displayTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          session.typeLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showDeleteDialog(context, session);
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.quiz, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${session.questionCount} questions',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(session.createdAt),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTypeIcon(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case 'similar':
        icon = Icons.copy;
        color = Colors.blue;
        break;
      case 'refinement':
        icon = Icons.auto_fix_high;
        color = Colors.purple;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }
  void _showDeleteDialog(BuildContext context, HistorySession session) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Session'),
        content: Text('Are you sure you want to delete "${session.displayTitle}"?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<HistoryBloc>().add(DeleteSessionEvent(session.id));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
