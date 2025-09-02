import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isOwn;
  final DateTime timestamp;
  final String? senderName;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isOwn,
    required this.timestamp,
    this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          crossAxisAlignment: isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isOwn && senderName != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Text(
                  senderName!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isOwn ? AppColors.messageSent : AppColors.messageReceived,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: isOwn ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight: isOwn ? const Radius.circular(4) : const Radius.circular(18),
                ),
                border: !isOwn
                    ? Border.all(color: AppColors.messageBorder, width: 0.5)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isOwn ? Colors.white : AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(timestamp),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isOwn 
                              ? Colors.white.withOpacity(0.7)
                              : AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      if (isOwn) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month} ${_formatHour(timestamp)}';
    } else if (difference.inHours > 0) {
      return _formatHour(timestamp);
    } else {
      return _formatHour(timestamp);
    }
  }

  String _formatHour(DateTime timestamp) {
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}
