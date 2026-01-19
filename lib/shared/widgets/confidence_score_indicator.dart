import 'package:flutter/material.dart';
import 'package:ai_question_generator/core/theme/app_colors.dart';
class ConfidenceScoreIndicator extends StatelessWidget {
  final double? score;
  final bool showLabel;
  const ConfidenceScoreIndicator({
    super.key,
    required this.score,
    this.showLabel = true,
  });
  @override
  Widget build(BuildContext context) {
    if (score == null) return const SizedBox.shrink();
    final percentage = (score! * 100).round();
    final color = _getColorForScore(score!);
    final label = _getLabelForScore(score!);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getIconForScore(score!),
                size: 14,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (showLabel) ...[
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
  Color _getColorForScore(double score) {
    if (score >= 0.9) return Colors.green;
    if (score >= 0.7) return Colors.blue;
    if (score >= 0.5) return Colors.orange;
    return Colors.red;
  }
  IconData _getIconForScore(double score) {
    if (score >= 0.9) return Icons.verified;
    if (score >= 0.7) return Icons.check_circle_outline;
    if (score >= 0.5) return Icons.info_outline;
    return Icons.warning_amber_rounded;
  }
  String _getLabelForScore(double score) {
    if (score >= 0.9) return 'Excellent';
    if (score >= 0.7) return 'Good';
    if (score >= 0.5) return 'Fair';
    return 'Review';
  }
}
class ConfidenceScoreBadge extends StatelessWidget {
  final double? score;
  const ConfidenceScoreBadge({
    super.key,
    required this.score,
  });
  @override
  Widget build(BuildContext context) {
    if (score == null) return const SizedBox.shrink();
    final percentage = (score! * 100).round();
    final color = _getColorForScore(score!);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  Color _getColorForScore(double score) {
    if (score >= 0.9) return Colors.green;
    if (score >= 0.7) return Colors.blue;
    if (score >= 0.5) return Colors.orange;
    return Colors.red;
  }
}
