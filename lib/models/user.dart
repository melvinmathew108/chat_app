import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String profilePicture;

  @HiveField(3)
  String? lastMessage;

  @HiveField(4)
  int unseenCount;

  User({
    required this.id,
    required this.name,
    required this.profilePicture,
    this.lastMessage,
    this.unseenCount = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      profilePicture: json['profilePicture'],
      lastMessage: json['lastMessage'],
      unseenCount: json['unseenCount'] ?? 0,
    );
  }
}
