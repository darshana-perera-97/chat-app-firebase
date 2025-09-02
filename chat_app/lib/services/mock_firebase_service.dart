import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MockFirebaseService {
  // Simulate Firebase data structure - start with empty chat like HTML project
  static List<Map<String, dynamic>> _mockMessages = [];

  // Get messages (simulating Firebase REST API)
  Future<List<Map<String, dynamic>>> getMessages() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return a copy of the messages
    return List.from(_mockMessages);
  }

  // Send message (simulating Firebase REST API)
  Future<void> sendMessage(String text, String userId, String userName) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Add new message to the list
    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': text,
      'userId': userId,
      'userName': userName,
      'timestamp': DateTime.now(),
    };
    
    _mockMessages.add(newMessage);
  }

  // No automatic messages - just like HTML project, chat starts empty
  void startSimulatingRealTimeUpdates() {
    // Empty - no automatic messages, just like the HTML project
  }
}
