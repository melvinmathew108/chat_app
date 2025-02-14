import '../models/user.dart';
import '../models/message.dart';

class MockDataService {
  List<User> getMockUsers() {
    return [
      User(
        id: '1',
        name: 'Emma Watson',
        profilePicture: 'https://i.pravatar.cc/150?img=1',
        lastMessage: 'Are we still meeting for coffee? ☕',
        unseenCount: 3,
      ),
      User(
        id: '2',
        name: 'James Smith',
        profilePicture: 'https://i.pravatar.cc/150?img=3',
        lastMessage: 'The presentation went great! 🎉',
        unseenCount: 0,
      ),
      User(
        id: '3',
        name: 'Sophia Chen',
        profilePicture: 'https://i.pravatar.cc/150?img=5',
        lastMessage: 'Did you see the latest episode? 😱',
        unseenCount: 2,
      ),
      User(
        id: '4',
        name: 'Lucas Rodriguez',
        profilePicture: 'https://i.pravatar.cc/150?img=8',
        lastMessage: 'Thanks for your help yesterday!',
        unseenCount: 0,
      ),
      User(
        id: '5',
        name: 'Olivia Taylor',
        profilePicture: 'https://i.pravatar.cc/150?img=9',
        lastMessage: 'Movie night on Friday? 🍿',
        unseenCount: 1,
      ),
      User(
        id: '6',
        name: 'William Brown',
        profilePicture: 'https://i.pravatar.cc/150?img=11',
        lastMessage: 'Just sent you the files 📁',
        unseenCount: 0,
      ),
      User(
        id: '7',
        name: 'Ava Martinez',
        profilePicture: 'https://i.pravatar.cc/150?img=10',
        lastMessage: 'Happy birthday! 🎂',
        unseenCount: 4,
      ),
      User(
        id: '8',
        name: 'Noah Wilson',
        profilePicture: 'https://i.pravatar.cc/150?img=12',
        lastMessage: 'See you at the gym 💪',
        unseenCount: 0,
      ),
    ];
  }

  List<Message> getMockMessages(String userId) {
    final now = DateTime.now();

    final messages = {
      '1': [
        Message(
          id: '1_1',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Hey! Are you free this afternoon?',
          timestamp: now.subtract(const Duration(hours: 2)),
        ),
        Message(
          id: '1_2',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Hi Emma! Yes, what\'s up?',
          timestamp: now.subtract(const Duration(hours: 1, minutes: 55)),
        ),
        Message(
          id: '3',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Would you like to grab coffee? ☕',
          timestamp: now.subtract(const Duration(hours: 1, minutes: 50)),
        ),
        Message(
          id: '4',
          senderId: userId,
          receiverId: 'current_user',
          content: 'That new café downtown looks amazing!',
          timestamp: now.subtract(const Duration(hours: 1, minutes: 45)),
        ),
        Message(
          id: '5',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Are we still meeting for coffee? ☕',
          timestamp: now.subtract(const Duration(minutes: 30)),
        ),
      ],
      '2': [
        Message(
          id: '2_1',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Hey, got a minute to discuss the project?',
          timestamp: now.subtract(const Duration(hours: 5)),
        ),
        Message(
          id: '2_2',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Sure, what\'s on your mind?',
          timestamp: now.subtract(const Duration(hours: 4, minutes: 55)),
        ),
        Message(
          id: '2_3',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Just finished the presentation for tomorrow 📊',
          timestamp: now.subtract(const Duration(hours: 4, minutes: 50)),
        ),
        Message(
          id: '2_4',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Added those changes you suggested',
          timestamp: now.subtract(const Duration(hours: 4, minutes: 45)),
        ),
        Message(
          id: '2_5',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Perfect! Let me take a look 👀',
          timestamp: now.subtract(const Duration(hours: 4)),
        ),
        Message(
          id: '2_6',
          senderId: 'current_user',
          receiverId: userId,
          content: 'This looks amazing! Great work 🎉',
          timestamp: now.subtract(const Duration(hours: 3)),
        ),
        Message(
          id: '2_7',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Thanks! The client meeting went great!',
          timestamp: now.subtract(const Duration(minutes: 30)),
        ),
      ],
      '3': [
        Message(
          id: '3_1',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Did you watch the latest episode? 😱',
          timestamp: now.subtract(const Duration(hours: 3)),
        ),
        Message(
          id: '3_2',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Not yet! No spoilers please! 🙈',
          timestamp: now.subtract(const Duration(hours: 2, minutes: 55)),
        ),
        Message(
          id: '3_3',
          senderId: userId,
          receiverId: 'current_user',
          content: 'You won\'t believe what happened!',
          timestamp: now.subtract(const Duration(hours: 2, minutes: 50)),
        ),
        Message(
          id: '3_4',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Lalala not listening 🙉',
          timestamp: now.subtract(const Duration(hours: 2, minutes: 45)),
        ),
      ],
      '4': [
        Message(
          id: '4_1',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Hey Lucas, need help with the database setup',
          timestamp: now.subtract(const Duration(days: 1, hours: 4)),
        ),
        Message(
          id: '4_2',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Sure! I can help. What\'s the issue?',
          timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        ),
        Message(
          id: '4_3',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Getting this weird error with migrations',
          timestamp: now.subtract(const Duration(days: 1, hours: 2)),
        ),
        Message(
          id: '4_4',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Ah, I know what\'s wrong. Let me help',
          timestamp: now.subtract(const Duration(days: 1, hours: 1)),
        ),
        Message(
          id: '4_5',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Thanks for your help yesterday!',
          timestamp: now.subtract(const Duration(hours: 2)),
        ),
      ],
      '5': [
        Message(
          id: '5_1',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Hey! Planning a movie night this Friday 🎬',
          timestamp: now.subtract(const Duration(hours: 6)),
        ),
        Message(
          id: '5_2',
          senderId: userId,
          receiverId: 'current_user',
          content: 'We\'re watching the new superhero movie 🦸‍♂️',
          timestamp: now.subtract(const Duration(hours: 5)),
        ),
        Message(
          id: '5_3',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Sounds fun! What time?',
          timestamp: now.subtract(const Duration(hours: 4)),
        ),
        Message(
          id: '5_4',
          senderId: userId,
          receiverId: 'current_user',
          content: '7 PM at my place. Bringing popcorn? 🍿',
          timestamp: now.subtract(const Duration(hours: 1)),
        ),
      ],
      '6': [
        Message(
          id: '6_1',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Check your email 📧',
          timestamp: now.subtract(const Duration(hours: 5)),
        ),
        Message(
          id: '6_2',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Got them, thanks!',
          timestamp: now.subtract(const Duration(hours: 4)),
        ),
        Message(
          id: '6_3',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Just sent the updated files 📁',
          timestamp: now.subtract(const Duration(minutes: 30)),
        ),
      ],
      '7': [
        Message(
          id: '7_1',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Happy Birthday Ava! 🎂',
          timestamp: now.subtract(const Duration(hours: 8)),
        ),
        Message(
          id: '7_2',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Thank you so much! 🥳',
          timestamp: now.subtract(const Duration(hours: 7)),
        ),
        Message(
          id: '7_3',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Having a small party tonight, you should come! 🎈',
          timestamp: now.subtract(const Duration(hours: 6)),
        ),
        Message(
          id: '7_4',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Wouldn\'t miss it! What time? 🕒',
          timestamp: now.subtract(const Duration(hours: 5)),
        ),
      ],
      '8': [
        Message(
          id: '8_1',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Morning workout today? 💪',
          timestamp: now.subtract(const Duration(hours: 12)),
        ),
        Message(
          id: '8_2',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Definitely! Same time as usual?',
          timestamp: now.subtract(const Duration(hours: 11)),
        ),
        Message(
          id: '8_3',
          senderId: userId,
          receiverId: 'current_user',
          content: 'Yep, 7 AM at the gym 🏋️‍♂️',
          timestamp: now.subtract(const Duration(hours: 10)),
        ),
        Message(
          id: '8_4',
          senderId: 'current_user',
          receiverId: userId,
          content: 'Perfect, see you there! 👊',
          timestamp: now.subtract(const Duration(hours: 9)),
        ),
      ],
    };

    return messages[userId] ?? [];
  }
}
