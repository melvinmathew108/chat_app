import '../models/user.dart';
import '../models/message.dart';

class MockDataService {
  List<User> getMockUsers() {
    return [
      User(
        id: '1',
        name: 'John Doe',
        profilePicture:
            'https://ui-avatars.com/api/?name=John+Doe&background=random',
        lastMessage: 'Hello there!',
        unseenCount: 2,
      ),
      User(
        id: '2',
        name: 'Jane Smith',
        profilePicture:
            'https://ui-avatars.com/api/?name=Jane+Smith&background=random',
        lastMessage: 'How are you?',
        unseenCount: 0,
      ),
      User(
        id: '3',
        name: 'Mike Johnson',
        profilePicture:
            'https://ui-avatars.com/api/?name=Mike+Johnson&background=random',
        lastMessage: 'See you soon!',
        unseenCount: 1,
      ),
      User(
        id: '4',
        name: 'Sarah Wilson',
        profilePicture:
            'https://ui-avatars.com/api/?name=Sarah+Wilson&background=random',
        lastMessage: 'Great idea!',
        unseenCount: 0,
      ),
    ];
  }

  List<Message> getMockMessages(String userId) {
    return [
      Message(
        id: '1',
        senderId: userId,
        receiverId: 'current_user',
        content: 'Hello there!',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Message(
        id: '2',
        senderId: 'current_user',
        receiverId: userId,
        content: 'Hi! How are you?',
        timestamp: DateTime.now().subtract(const Duration(hours: 23)),
      ),
      Message(
        id: '3',
        senderId: userId,
        receiverId: 'current_user',
        content: 'I am good, thanks!',
        timestamp: DateTime.now().subtract(const Duration(hours: 22)),
      ),
      Message(
        id: '4',
        senderId: 'current_user',
        receiverId: userId,
        content: 'What are you up to?',
        timestamp: DateTime.now().subtract(const Duration(hours: 21)),
      ),
    ];
  }
}
