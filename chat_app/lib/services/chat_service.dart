import 'dart:async';
import 'mock_firebase_service.dart';

class ChatService {
  final MockFirebaseService _mockService = MockFirebaseService();
  final StreamController<List<Map<String, dynamic>>> _messagesController = StreamController<List<Map<String, dynamic>>>.broadcast();
  
  Timer? _pollingTimer;
  List<Map<String, dynamic>> _messages = [];
  String? _currentUserId;

  ChatService() {
    _startPolling();
    _mockService.startSimulatingRealTimeUpdates();
  }

  // Set current user ID (called from auth service)
  void setCurrentUser(String userId) {
    _currentUserId = userId;
  }

  // Start polling for new messages every 2 seconds
  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _loadMessages();
    });
    _loadMessages(); // Load immediately
  }

  // Load messages from mock service
  Future<void> _loadMessages() async {
    try {
      final messages = await _mockService.getMessages();
      _messages = messages;
      _messagesController.add(List.from(_messages));
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  // Get messages stream
  Stream<List<Map<String, dynamic>>> getMessagesStream() {
    return _messagesController.stream;
  }

  // Send message to mock service
  Future<void> sendMessage(String message) async {
    if (_currentUserId == null) {
      throw Exception('User not logged in');
    }

    // For demo purposes, use a simple user name
    final userName = 'You';
    final userId = _currentUserId!;

    await _mockService.sendMessage(message, userId, userName);
    
    // Reload messages after sending
    await _loadMessages();
  }

  // Get all messages
  Future<List<Map<String, dynamic>>> getAllMessages() async {
    return List.from(_messages);
  }

  // Format timestamp like HTML project
  String formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    final minutes = diff.inMinutes;
    final hours = diff.inHours;
    final days = diff.inDays;
    
    if (minutes < 1) return 'Just now';
    if (minutes < 60) return '${minutes}m ago';
    if (hours < 24) return '${hours}h ago';
    if (days < 7) return '${days}d ago';
    
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  // Check if message is from current user
  bool isOwnMessage(String messageUserId) {
    return _currentUserId == messageUserId;
  }

  void dispose() {
    _pollingTimer?.cancel();
    _messagesController.close();
  }
}