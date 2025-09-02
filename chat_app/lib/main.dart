import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'services/auth_service.dart';
import 'services/chat_service.dart';
import 'services/connectivity_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/chat/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final chatService = ChatService();
    
    // Connect auth service with chat service
    authService.authStateChanges.listen((user) {
      if (user != null) {
        chatService.setCurrentUser(user.uid);
      }
    });
    
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => authService),
        Provider<ChatService>(create: (_) => chatService),
        Provider<ConnectivityService>(create: (_) => ConnectivityService()),
      ],
      child: MaterialApp(
        title: 'WhatsApp Style Chat App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/chat': (context) => const ChatScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show login screen if no data or no user
        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginScreen();
        }
        
        // Show chat screen if user is logged in
        return const ChatScreen();
      },
    );
  }
}
