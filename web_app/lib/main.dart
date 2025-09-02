import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Conditional imports for platform-specific code
import 'web_view_stub.dart'
    if (dart.library.html) 'web_view_web.dart'
    if (dart.library.io) 'web_view_mobile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebViewPage(),
    );
  }
}

// WebViewPage is now imported from platform-specific files