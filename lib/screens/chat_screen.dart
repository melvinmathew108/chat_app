import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  const ChatScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isOnline = true; // This should come from a proper online status system

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final user = context
        .read<ChatProvider>()
        .users
        .firstWhere((user) => user.id == widget.userId);

    return Scaffold(
      backgroundColor: AppTheme.offWhite, // Update background color
      body: SafeArea(
        child: Column(
          children: [
            // Chat Header
            Container(
              color: AppTheme.offWhite, 
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: AppTheme.darkText),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(user.profilePicture),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: AppTheme.subtitleText.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isOnline ? Colors.green : Colors.red,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _isOnline ? 'Online' : 'Offline',
                              style: AppTheme.regularText.copyWith(
                                color: AppTheme.textGray,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: AppTheme.darkText),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Chat Messages
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Today',
                        style: TextStyle(
                          color: AppTheme.textGray,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Consumer<ChatProvider>(
                        builder: (context, provider, _) {
                          return FutureBuilder(
                            future: provider.getMessages(widget.userId),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final messages = snapshot.data!;
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  return ChatMessageBubble(
                                    message: messages[index],
                                    isLastMessage: index == messages.length - 1,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Input Area
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.lightGray,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: const InputDecoration(
                                  hintText: 'Type a message...',
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: AppTheme.textGray),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              color: AppTheme.primaryPink,
                              onPressed: () {
                                if (_messageController.text.trim().isNotEmpty) {
                                  context.read<ChatProvider>().sendMessage(
                                      widget.userId, _messageController.text);
                                  _messageController.clear();
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightGray,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.emoji_emotions_outlined),
                        onPressed: () {},
                        color: AppTheme.textGray,
                      ),
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
