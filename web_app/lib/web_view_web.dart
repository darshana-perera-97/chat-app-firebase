import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  html.WindowBase? _popupWindow;

  @override
  void initState() {
    super.initState();
    _openChatApp();
  }

  void _openChatApp() {
    // Try to open in a new window first (allows cookies)
    _popupWindow = html.window.open(
      'https://chat-app.infinityfree.me/',
      'chatApp',
      'width=${html.window.screen?.width ?? 1200},height=${html.window.screen?.height ?? 800},scrollbars=yes,resizable=yes,status=yes,location=yes,toolbar=yes,menubar=yes'
    );

    // If popup was blocked, fall back to iframe
    if (_popupWindow == null || _popupWindow!.closed == true) {
      if (kDebugMode) {
        print('Popup blocked, falling back to iframe');
      }
      _createIframe();
    } else {
      // Popup window opened successfully
      if (kDebugMode) {
        print('Popup window opened successfully');
      }
    }
  }

  void _createIframe() {
    // Remove any existing content
    html.document.body?.children.clear();
    
    // Create an iframe element with minimal restrictions
    final iframe = html.IFrameElement()
      ..src = 'https://chat-app.infinityfree.me/'
      // ..src = 'http://127.0.0.1:5500/index.html'
      ..style.border = 'none'
      ..style.width = '100vw'
      ..style.height = '100vh'
      ..style.margin = '0'
      ..style.padding = '0'
      ..style.position = 'fixed'
      ..style.top = '0'
      ..style.left = '0'
      ..style.zIndex = '9999'
      // No sandbox restrictions - allow full functionality
      ..setAttribute('allow', '*')
      ..setAttribute('allowfullscreen', 'true')
      ..setAttribute('allowtransparency', 'true')
      ..setAttribute('frameborder', '0')
      ..setAttribute('scrolling', 'auto');

    // Add event listeners for debugging
    iframe.onLoad.listen((event) {
      if (kDebugMode) {
        print('Iframe loaded successfully');
      }
    });

    iframe.onError.listen((event) {
      if (kDebugMode) {
        print('Iframe error: $event');
      }
    });

    // Add the iframe to the body
    html.document.body?.append(iframe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Chat App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Click the button below to open the chat application',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _openChatApp,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Chat App'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Force iframe mode
                _createIframe();
              },
              child: const Text('Open in Embedded Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
