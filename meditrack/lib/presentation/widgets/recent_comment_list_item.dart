import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/models/admin_overview_data.dart';

class RecentCommentListItem extends StatelessWidget {
  final RecentComment comment;

  const RecentCommentListItem({
    super.key,
    required this.comment,
  });

  String _formatCommentDate(DateTime? dateTime, BuildContext context) {
    if (dateTime == null) return 'Date unknown';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    try {
      if (difference.inSeconds < 60) {
        return 'just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat.MMMd(Localizations.localeOf(context).languageCode)
            .format(dateTime);
      }
    } catch (e) {
      return DateFormat.yMMMd().format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeAgo = _formatCommentDate(comment.createdAt, context);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: colorScheme.onSecondaryContainer,
          child: Text(
            comment.fullName.isNotEmpty
                ? comment.fullName[0].toUpperCase()
                : '?',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          comment.fullName,
          style:
              theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          comment.comment,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: colorScheme.onSurfaceVariant),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          timeAgo,
          style:
              theme.textTheme.labelSmall?.copyWith(color: colorScheme.outline),
        ),
      ),
    );
  }
}
