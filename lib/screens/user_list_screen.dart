import 'package:chat_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_bottom_nav.dart';
import 'chat_screen.dart';
import '../providers/app_provider.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  int _selectedNavIndex = 3; // Chat tab selected by default

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    await context.read<ChatProvider>().loadUsers();
  }

  void _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<AppProvider>().logout();
      await context.read<ChatProvider>().logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Messages', style: AppTheme.titleText),
                  IconButton(
                    icon: const Icon(Icons.logout, color: AppTheme.textGray),
                    onPressed: _handleLogout,
                  ),
                ],
              ),
            ),
            // Story Circles
            SizedBox(
              height: 100,
              child: Consumer<ChatProvider>(
                builder: (context, provider, _) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.users.length,
                    itemBuilder: (context, index) {
                      final user = provider.users[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(user.profilePicture),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: index % 2 == 0
                                          ? Colors.green
                                          : Colors.red,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.name.split(' ')[0],
                              style: AppTheme.regularText,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Search Bar with padding
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: AppTheme.textGray),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.search, color: AppTheme.textGray),
                  ],
                ),
              ),
            ),

            // Chat List Title with padding
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Text('Chats', style: AppTheme.subtitleText),
            ),

            // Chat List with separators
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, _) {
                  return ListView.separated(
                    itemCount: provider.users.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      thickness: 0.5,
                      indent: 84,
                      endIndent: 16,
                      color: AppTheme.lightGray,
                    ),
                    itemBuilder: (context, index) {
                      final user = provider.users[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundImage:
                                  NetworkImage(user.profilePicture),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index % 2 == 0
                                      ? Colors.green
                                      : Colors.red,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          user.name,
                          style: AppTheme.subtitleText.copyWith(
                            fontWeight: user.unseenCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          user.lastMessage ?? '',
                          style: AppTheme.regularText.copyWith(
                            color: AppTheme.textGray,
                            fontWeight: user.unseenCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '12:30 PM',
                              style: AppTheme.regularText.copyWith(
                                color: AppTheme.textGray,
                                fontSize: 12,
                              ),
                            ),
                            if (user.unseenCount > 0) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryPink,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${user.unseenCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(userId: user.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() => _selectedNavIndex = index);
        },
      ),
    );
  }
}
