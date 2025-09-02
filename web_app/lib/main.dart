import 'package:flutter/material.dart';
import 'dart:html' as html;

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

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();
    _createIframe();
  }

  void _createIframe() {
    // Remove any existing content
    html.document.body?.children.clear();
    
    // Create an iframe element
    final iframe = html.IFrameElement()
      ..src = 'http://127.0.0.1:5500/index.html'
      ..style.border = 'none'
      ..style.width = '100vw'
      ..style.height = '100vh'
      ..style.margin = '0'
      ..style.padding = '0'
      ..style.position = 'fixed'
      ..style.top = '0'
      ..style.left = '0';

    // Add the iframe to the body
    html.document.body?.append(iframe);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.shrink(),
    );
  }
}