// Stub file for web view functionality
// This file is used when neither web nor mobile specific implementations are available

import 'package:flutter/material.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Web view not supported on this platform'),
      ),
    );
  }
}
