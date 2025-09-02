// Mock ConnectivityService for development
import 'dart:async';

class ConnectivityService {
  bool _isOnline = true;
  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();

  bool get isOnline => _isOnline;
  Stream<bool> get connectivityStream => _connectivityController.stream;

  void initialize() {
    // Mock initialization - always online for development
    _isOnline = true;
    _connectivityController.add(_isOnline);
  }

  Future<bool> checkConnectivity() async {
    // Mock connectivity check - always return true for development
    return true;
  }

  void dispose() {
    _connectivityController.close();
  }
}