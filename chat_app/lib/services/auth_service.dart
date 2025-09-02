import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Mock user class
class MockUser {
  final String uid;
  final String? email;
  final String? displayName;
  
  MockUser({required this.uid, this.email, this.displayName});
}

class AuthService {
  MockUser? _currentUser;
  final StreamController<MockUser?> _authController = StreamController<MockUser?>.broadcast();

  MockUser? get currentUser => _currentUser;
  Stream<MockUser?> get authStateChanges => _authController.stream;

  // Initialize the auth service
  AuthService() {
    // Start with no user (not logged in)
    _authController.add(null);
  }

  // Mock sign up
  Future<MockUser?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Create mock user
    _currentUser = MockUser(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      displayName: name,
    );
    
    _authController.add(_currentUser);
    return _currentUser;
  }

  // Mock sign in
  Future<MockUser?> signIn({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Create mock user
    _currentUser = MockUser(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      displayName: email.split('@')[0], // Use email prefix as name
    );
    
    _authController.add(_currentUser);
    return _currentUser;
  }

  // Mock sign out
  Future<void> signOut() async {
    _currentUser = null;
    _authController.add(null);
  }

  // Mock get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    if (_currentUser != null) {
      return {
        'name': _currentUser!.displayName,
        'email': _currentUser!.email,
        'createdAt': DateTime.now(),
      };
    }
    return null;
  }

  // Generate avatar URL
  String generateAvatarUrl(String name, {int size = 40}) {
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=667eea&color=fff&size=$size';
  }

  void dispose() {
    _authController.close();
  }
}