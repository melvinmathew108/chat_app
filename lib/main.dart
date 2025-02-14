import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
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
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

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

  // Initialize AppProvider
  final appProvider = AppProvider();
  await appProvider.initialize();

  runApp(MyApp(appProvider: appProvider));
}

class MyApp extends StatelessWidget {
  final AppProvider appProvider;

  const MyApp({super.key, required this.appProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appProvider),
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
        home: appProvider.isLoggedIn
            ? const UserListScreen()
            : const LoginScreen(),
      ),
    );
  }
}
