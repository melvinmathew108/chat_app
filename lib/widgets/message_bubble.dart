import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../providers/chat_provider.dart';

class MessageBubble extends StatefulWidget {
  final Message message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _showReactions = false;
  final List<String> _reactions = ['❤️', '👍', '👎', '😂', '😮', '🙏'];

  void _toggleReactions() {
    setState(() => _showReactions = !_showReactions);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onLongPress: _toggleReactions,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Align(
              alignment: widget.message.senderId == 'current_user'
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.message.senderId == 'current_user'
                      ? Colors.pink
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.message.content,
                      style: TextStyle(
                        color: widget.message.senderId == 'current_user'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    if (widget.message.reaction != null)
                      Container(
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          widget.message.reaction!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_showReactions)
          Positioned(
            bottom: 0,
            right: widget.message.senderId == 'current_user' ? 8 : null,
            left: widget.message.senderId == 'current_user' ? null : 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _reactions.map((reaction) {
                  return GestureDetector(
                    onTap: () {
                      context.read<ChatProvider>().toggleReaction(
                            widget.message.id,
                            reaction,
                          );
                      _toggleReactions();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        reaction,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}
