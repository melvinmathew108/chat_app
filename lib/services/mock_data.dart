import '../models/user.dart';
import '../models/message.dart';

class MockDataService {
  List<User> getMockUsers() {
    return [
      User(
        id: '1',
        name: 'John Doe',
        profilePicture: 'https://i.pravatar.cc/150?img=1',
        lastMessage: 'Hey there!',
        unseenCount: 2,
      ),
      User(
        id: '2',
        name: 'Jane Smith',
        profilePicture: 'https://i.pravatar.cc/150?img=2',
        lastMessage: 'How are you?',
        unseenCount: 0,
      ),
      User(
        id: '3',
        name: 'Mike Johnson',
        profilePicture: 'https://i.pravatar.cc/150?img=3',
        lastMessage: 'See you soon!',
        unseenCount: 1,
      ),
      User(
        id: '4',
        name: 'Sarah Williams',
        profilePicture: 'https://i.pravatar.cc/150?img=4',
        lastMessage: 'Thanks!',
        unseenCount: 0,
      ),
    ];
  }

  List<Message> getMockMessages(String userId) {
    final now = DateTime.now();
    return [
      Message(
        id: '1',
        senderId: userId,
        receiverId: 'current_user',
        content: 'Hey! How are you?',
        timestamp: now.subtract(const Duration(days: 1)),
        isSeen: true,
      ),
      Message(
        id: '2',
        senderId: 'current_user',
        receiverId: userId,
        content: 'I\'m good, thanks! How about you?',
        timestamp: now.subtract(const Duration(hours: 23)),
      ),
      Message(
        id: '3',
        senderId: userId,
        receiverId: 'current_user',
        content: 'Pretty good! Working on some exciting projects.',
        timestamp: now.subtract(const Duration(hours: 22)),
      ),
      Message(
        id: '4',
        senderId: 'current_user',
        receiverId: userId,
        content: 'That sounds interesting! Tell me more.',
        timestamp: now.subtract(const Duration(hours: 21)),
      ),
      Message(
        id: '5',
        senderId: userId,
        receiverId: 'current_user',
        content: 'Sure! Let\'s catch up soon.',
        timestamp: now.subtract(const Duration(hours: 20)),
      ),
    ];
  }
}
