import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/chat_provider.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String userId;

  const ChatScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  late Future<List<Message>> _messagesFuture;
  bool _isTyping = false;
  Timer? _mockResponseTimer;

  @override
  void initState() {
    super.initState();
    _messagesFuture = context.read<ChatProvider>().getMessages(widget.userId);
    // Mark messages as seen when opening chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().markMessagesAsSeen(widget.userId);
    });
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      await context.read<ChatProvider>().sendMessage(widget.userId, content);
      _messageController.clear();
      _simulateMockResponse();
    }
  }

  void _simulateMockResponse() {
    setState(() => _isTyping = true);
    _mockResponseTimer?.cancel();
    _mockResponseTimer = Timer(const Duration(seconds: 3), () async {
      setState(() => _isTyping = false);
      final responses = [
        "That's interesting!",
        "I see what you mean",
        "Tell me more about that",
        "Really? That's fascinating",
        "I agree with you"
      ];
      final response = responses[DateTime.now().microsecond % responses.length];
      await context
          .read<ChatProvider>()
          .receiveMockMessage(widget.userId, response);
    });
  }

  @override
  void dispose() {
    _mockResponseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Chat', style: TextStyle(color: Colors.pink)),
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.pink),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, child) {
                  return Stack(
                    children: [
                      FutureBuilder<List<Message>>(
                        future: _messagesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          final messages = snapshot.data!;
                          return ListView.builder(
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message =
                                  messages[messages.length - 1 - index];
                              return MessageBubble(message: message);
                            },
                          );
                        },
                      ),
                      if (_isTyping)
                        Positioned(
                          bottom: 0,
                          left: 20,
                          child: TypingIndicator(),
                        ),
                    ],
                  );
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: MediaQuery.of(context).viewInsets.bottom > 0
                    ? EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom)
                    : const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: Colors.pink),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: Colors.pink),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.pink),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedMessageBubble extends StatelessWidget {
  final Message message;

  const AnimatedMessageBubble({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: MessageBubble(
        key: ValueKey(message.id),
        message: message,
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Align(
        alignment: message.senderId == 'current_user'
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: message.senderId == 'current_user'
                ? Colors.blue
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: message.senderId == 'current_user'
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pink.withOpacity(
                    (index / 3 + _controller.value) % 1,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
