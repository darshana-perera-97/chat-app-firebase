import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../../services/connectivity_service.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _isOnline = true;
  StreamSubscription<List<Map<String, dynamic>>>? _messagesSubscription;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    // Scroll to bottom after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messagesSubscription?.cancel();
    super.dispose();
  }

  void _initializeServices() {
    final connectivityService = Provider.of<ConnectivityService>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);
    
    connectivityService.initialize();
    
    // Listen to connectivity changes
    connectivityService.connectivityStream.listen((isOnline) {
      if (mounted) {
        setState(() {
          _isOnline = isOnline;
        });
        
        if (!isOnline) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are offline. Messages will be sent when you reconnect.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    });
    
    // Listen to real-time messages
    _messagesSubscription = chatService.getMessagesStream().listen((snapshot) {
      if (mounted) {
        _scrollToBottom();
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || !_isOnline) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    try {
      final chatService = Provider.of<ChatService>(context, listen: false);
      await chatService.sendMessage(messageText);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }



  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showEmojiPicker() {
    final emojis = ['😊', '😂', '❤️', '👍', '🎉', '🔥', '💯', '✨', '😎', '🤔'];
    final randomEmoji = emojis[DateTime.now().millisecondsSinceEpoch % emojis.length];
    
    final cursorPos = _messageController.selection.baseOffset;
    final textBefore = _messageController.text.substring(0, cursorPos);
    final textAfter = _messageController.text.substring(cursorPos);
    
    _messageController.text = textBefore + randomEmoji + textAfter;
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: cursorPos + randomEmoji.length),
    );
  }

  void _showOnlineUsers(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundQuaternary,
          title: const Text(
            'Online Users',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Global Chat Room',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'All registered users can participate',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Currently Online (6)',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildMemberTile('You', true, true),
              _buildMemberTile('John Doe', true, false),
              _buildMemberTile('Sarah Wilson', true, false),
              _buildMemberTile('Mike Johnson', true, false),
              _buildMemberTile('Alex Chen', true, false),
              _buildMemberTile('Emma Davis', true, false),
              _buildMemberTile('David Kim', true, false),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMemberTile(String name, bool isOnline, bool isYou) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isYou ? AppColors.primaryGreen : AppColors.textSecondary,
            child: Text(
              name.split(' ').map((e) => e[0]).join(''),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isYou ? '$name (You)' : name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          if (isOnline)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.online,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundTertiary,
        elevation: 0,
        leading: isMobile
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: Row(
          children: [
            // Global chat avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryGreen,
              child: const Icon(
                Icons.chat,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Global Chat',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'All users connected',
                    style: TextStyle(
                      color: AppColors.online,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people, color: AppColors.textSecondary),
            onPressed: () {
              _showOnlineUsers(context);
            },
            tooltip: 'Online Users',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            onSelected: (value) async {
              if (value == 'logout') {
                try {
                  final authService = Provider.of<AuthService>(context, listen: false);
                  await authService.signOut();
                  // Navigation is handled by AuthWrapper
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Logout failed: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.backgroundDark,
              ),
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: Provider.of<ChatService>(context).getMessagesStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading messages: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    );
                  }

                  final messages = snapshot.data ?? [];
                  
                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 8 : 16,
                      vertical: 8,
                    ),
                    itemCount: messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length && _isTyping) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: TypingIndicator(),
                        );
                      }
                      
                      final message = messages[index];
                      final chatService = Provider.of<ChatService>(context, listen: false);
                      
                      final isOwn = chatService.isOwnMessage(message['userId']);
                      final timestamp = message['timestamp'] as DateTime;
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: MessageBubble(
                          text: message['text'] ?? '',
                          isOwn: isOwn,
                          timestamp: timestamp,
                          senderName: message['userName'] ?? 'Anonymous',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          
          // Message Input
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: 8,
            ),
            decoration: const BoxDecoration(
              color: AppColors.backgroundTertiary,
              border: Border(
                top: BorderSide(color: AppColors.divider, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                // Emoji Button
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.faceSmile,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: _showEmojiPicker,
                ),
                
                // Message Input Field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Attachment Button
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.paperclip,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
                
                // Send Button
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.paperPlane,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
