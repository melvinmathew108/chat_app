import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/chat_provider.dart';
import '../models/user.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      await context.read<ChatProvider>().loadUsers();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load users. Using cached data.",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _refreshUsers() async {
    await context.read<ChatProvider>().loadUsers();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await context.read<ChatProvider>().logout();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chats', style: TextStyle(color: Colors.pink)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.pink),
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshUsers,
        child: Consumer<ChatProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.users.length,
                    itemBuilder: (context, index) {
                      final user = provider.users[index];
                      return StoryCircle(user: user);
                    },
                  ),
                ),
                const Divider(color: Colors.pink),
                Expanded(
                  child: provider.users.isEmpty
                      ? const Center(
                          child: Text('No chats available'),
                        )
                      : ListView.builder(
                          itemCount: provider.users.length,
                          itemBuilder: (context, index) {
                            final user = provider.users[index];
                            return UserListTile(user: user);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class StoryCircle extends StatelessWidget {
  final User user;

  const StoryCircle({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatScreen(userId: user.id)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.pink, width: 2),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundImage:
                    CachedNetworkImageProvider(user.profilePicture),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.name,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class UserListTile extends StatelessWidget {
  final User user;

  const UserListTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(user.profilePicture),
      ),
      title: Text(user.name),
      subtitle: Text(user.lastMessage ?? ''),
      trailing: user.unseenCount > 0
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${user.unseenCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(userId: user.id),
          ),
        );
      },
    );
  }
}
