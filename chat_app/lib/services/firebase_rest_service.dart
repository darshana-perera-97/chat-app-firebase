import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseRestService {
  static const String _baseUrl = 'https://firestore.googleapis.com/v1/projects/chat-app-89d9f/databases/(default)/documents';
  static const String _apiKey = 'AIzaSyDZWBs4wucLv22ri2PNzf_zFJ0dDTzJ1AE';

  // Get messages from Firestore REST API
  Future<List<Map<String, dynamic>>> getMessages() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/messages?key=$_apiKey&orderBy=timestamp'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final documents = data['documents'] as List<dynamic>? ?? [];
        
        return documents.map((doc) {
          final fields = doc['fields'] as Map<String, dynamic>;
          return {
            'id': doc['name'].split('/').last,
            'text': _getStringValue(fields['text']),
            'userId': _getStringValue(fields['userId']),
            'userName': _getStringValue(fields['userName']),
            'timestamp': _getTimestampValue(fields['timestamp']),
          };
        }).toList();
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading messages: $e');
    }
  }

  // Send message to Firestore REST API
  Future<void> sendMessage(String text, String userId, String userName) async {
    try {
      final messageData = {
        'fields': {
          'text': {'stringValue': text},
          'userId': {'stringValue': userId},
          'userName': {'stringValue': userName},
          'timestamp': {'timestampValue': DateTime.now().toUtc().toIso8601String()},
        }
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/messages?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(messageData),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  // Helper methods to extract values from Firestore format
  String _getStringValue(Map<String, dynamic>? field) {
    if (field == null) return '';
    return field['stringValue'] ?? '';
  }

  DateTime _getTimestampValue(Map<String, dynamic>? field) {
    if (field == null) return DateTime.now();
    final timestamp = field['timestampValue'];
    if (timestamp != null) {
      return DateTime.parse(timestamp);
    }
    return DateTime.now();
  }
}
