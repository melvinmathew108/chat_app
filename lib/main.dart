import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';
import 'models/message.dart';
import 'providers/app_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/login_screen.dart';
import 'screens/user_list_screen.dart';
import 'services/mock_data.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    final provider = ChatProvider(mockDataService: MockDataService());
    await provider.syncMessages();
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Delete all Hive data to start fresh
  try {
    await Hive.deleteFromDisk();
  } catch (e) {
    debugPrint('Error deleting Hive data: $e');
  }

  // Register adapters with explicit type checking
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(MessageAdapter());
  }

  // Initialize all boxes at startup
  await Future.wait([
    Hive.openBox<User>('users'),
    Hive.openBox<Message>('messages'),
  ]);

  // Initialize WorkManager
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    'fetchMessages',
    'fetchMessages',
    frequency: const Duration(minutes: 15),
  );

  // Reset preferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  runApp(const MyApp(isLoggedIn: false));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(mockDataService: MockDataService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: isLoggedIn ? const UserListScreen() : const LoginScreen(),
      ),
    );
  }
}
