import 'package:flutter/material.dart';
import '../models/message.dart';
import '../theme/app_theme.dart';

class ChatMessageBubble extends StatelessWidget {
  final Message message;
  final bool isLastMessage;

  const ChatMessageBubble({
    Key? key,
    required this.message,
    this.isLastMessage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = message.senderId == 'current_user';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? AppTheme.primaryPink
                  : const Color(0xFFEEF1F4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.content,
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '12:30 PM',
                      style: TextStyle(
                        fontSize: 12,
                        color: isCurrentUser ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 3),
                      Icon(
                        message.isSeen ? Icons.done_all : Icons.done,
                        size: 14,
                        color: Colors.white70,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
