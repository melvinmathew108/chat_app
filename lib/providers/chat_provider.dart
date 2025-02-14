import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../services/mock_data.dart';
import '../services/notification_service.dart';

class ChatProvider with ChangeNotifier {
  final MockDataService mockDataService;

  List<User> _users = [];
  Map<String, List<Message>> _messages = {};

  ChatProvider({
    required this.mockDataService,
  });

  List<User> get users => _users;

  Future<void> loadUsers() async {
    try {
      _users = mockDataService.getMockUsers();
      await _saveUsersToHive();
      notifyListeners();
    } catch (e) {
      _users = await _loadUsersFromHive();
      notifyListeners();
      rethrow;
    }
  }

  Future<List<Message>> getMessages(String userId) async {
    if (_messages.containsKey(userId)) {
      return _messages[userId]!;
    }

    try {
      final messages = mockDataService.getMockMessages(userId);
      _messages[userId] = messages;
      await _saveMessagesToHive(userId, messages);
      return messages;
    } catch (e) {
      return await _loadMessagesFromHive(userId);
    }
  }

  Future<void> _saveUsersToHive() async {
    final box = await Hive.openBox<User>('users');
    await box.clear();
    await box.addAll(_users);
  }

  Future<List<User>> _loadUsersFromHive() async {
    final box = await Hive.openBox<User>('users');
    return box.values.toList();
  }

  Future<void> _saveMessagesToHive(
      String userId, List<Message> messages) async {
    try {
      final box = await Hive.openBox<Message>('messages');
      await box.clear();
      for (var message in messages) {
        await box.put('${userId}_${message.id}', message);
      }
    } catch (e) {
      debugPrint('Error saving messages: $e');
    }
  }

  Future<List<Message>> _loadMessagesFromHive(String userId) async {
    try {
      final box = await Hive.openBox<Message>('messages');
      return box.values
          .where((message) =>
              message.senderId == userId || message.receiverId == userId)
          .toList();
    } catch (e) {
      debugPrint('Error loading messages: $e');
      return [];
    }
  }

  Future<void> sendMessage(String userId, String content) async {
    final message = Message(
      id: DateTime.now().toString(), // In real app, use UUID
      senderId: 'current_user',
      receiverId: userId,
      content: content,
      timestamp: DateTime.now(),
    );

    // Add message to local storage first (offline-first approach)
    await _addMessageToLocal(userId, message);
  }

  Future<void> _addMessageToLocal(String userId, Message message) async {
    if (!_messages.containsKey(userId)) {
      _messages[userId] = [];
    }
    _messages[userId]!.add(message);
    await _saveMessagesToHive(userId, _messages[userId]!);

    // Update last message and unseen count
    final userIndex = _users.indexWhere((u) => u.id == userId);
    if (userIndex != -1) {
      _users[userIndex].lastMessage = message.content;
      if (message.senderId != 'current_user') {
        _users[userIndex].unseenCount++;
      }
      await _saveUsersToHive();
    }

    // Show notification for new messages from others
    if (message.senderId != 'current_user') {
      final user = _users.firstWhere((u) => u.id == userId);
      await NotificationService()
          .showMessageNotification(user.name, message.content);
    }

    notifyListeners();
  }

  Future<void> markMessagesAsSeen(String userId) async {
    if (_messages.containsKey(userId)) {
      for (var message in _messages[userId]!) {
        if (message.senderId != 'current_user') {
          message.isSeen = true;
        }
      }

      // Update unseen count
      final userIndex = _users.indexWhere((u) => u.id == userId);
      if (userIndex != -1) {
        _users[userIndex].unseenCount = 0;
        await _saveUsersToHive();
      }

      await _saveMessagesToHive(userId, _messages[userId]!);
      notifyListeners();
    }
  }

  Future<void> receiveMockMessage(String userId, String content) async {
    final message = Message(
      id: DateTime.now().toString(),
      senderId: userId,
      receiverId: 'current_user',
      content: content,
      timestamp: DateTime.now(),
    );
    await _addMessageToLocal(userId, message);

    // Show notification for new message
    final user = _users.firstWhere((u) => u.id == userId);
    await NotificationService().showMessageNotification(user.name, content);
  }

  Future<void> toggleReaction(String messageId, String reaction) async {
    // Find message in all chats
    for (var userId in _messages.keys) {
      final messageIndex =
          _messages[userId]!.indexWhere((m) => m.id == messageId);
      if (messageIndex != -1) {
        final message = _messages[userId]![messageIndex];
        // Toggle reaction
        if (message.reaction == reaction) {
          message.reaction = null;
        } else {
          message.reaction = reaction;
        }
        // Save to Hive
        await _saveMessagesToHive(userId, _messages[userId]!);
        notifyListeners();
        break;
      }
    }
  }

  Future<void> logout() async {
    _users.clear();
    _messages.clear();
    final userBox = await Hive.openBox<User>('users');
    await userBox.clear();

    // Clear all message boxes
    for (var userId in _messages.keys) {
      final messageBox = await Hive.openBox<Message>('messages_$userId');
      await messageBox.clear();
    }

    notifyListeners();
  }

  // Add this method for background sync
  Future<void> syncMessages() async {
    try {
      for (var user in _users) {
        // Get new mock messages
        final newMessages = mockDataService.getMockMessages(user.id);

        // Process new messages
        final existing = _messages[user.id] ?? [];
        final existingIds = existing.map((m) => m.id).toSet();

        final messagesToAdd =
            newMessages.where((m) => !existingIds.contains(m.id));
        if (messagesToAdd.isNotEmpty) {
          _messages[user.id] = [...existing, ...messagesToAdd.toList()];
          await _saveMessagesToHive(user.id, _messages[user.id]!);

          // Update user's last message and unseen count
          final userIndex = _users.indexWhere((u) => u.id == user.id);
          if (userIndex != -1) {
            _users[userIndex].lastMessage = newMessages.last.content;
            _users[userIndex].unseenCount +=
                messagesToAdd.where((m) => !m.isSeen).length;
            await _saveUsersToHive();
          }
        }
      }
    } catch (e) {
      debugPrint('Background sync failed: $e');
    }
  }
}
