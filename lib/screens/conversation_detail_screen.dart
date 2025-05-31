import 'package:chat_app/bloc/conversation/conversation_bloc.dart';
import 'package:chat_app/bloc/conversation/conversation_event.dart';
import 'package:chat_app/bloc/conversation/conversation_state.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/utils/avatar_utils.dart'; // Import AvatarUtils
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ConversationDetailScreen extends StatefulWidget {
  final String conversationId;

  const ConversationDetailScreen({super.key, required this.conversationId});

  @override
  State<ConversationDetailScreen> createState() => _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // Add ScrollController
  Widget? _tempMessage; // Temporary message widget for visual feedback

  @override
  void initState() { // Add initState
    super.initState();
    // Optional: Scroll to bottom when messages load or new messages arrive
    // This requires listening to the Bloc state changes here or in the builder
  }

  void _scrollToBottom() { // Add _scrollToBottom
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        title: BlocBuilder<ConversationBloc, ConversationState>(
          builder: (context, state) {
            if (state is ConversationLoaded) {
              final conversation = state.conversations.firstWhere(
                (conv) => conv.id == widget.conversationId, 
                orElse: () => Conversation(id: '', contactName: 'Chat', lastMessage: '', timestamp: DateTime.now())
              );
              
              return Row(
                children: [
                  Hero(
                    tag: 'avatar-${widget.conversationId}',
                    child: AvatarUtils.getAvatar(
                      name: conversation.contactName,
                      radius: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conversation.contactName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Online', // This could be dynamic based on user status
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const Text('Chat');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Call feature coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('More options coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.light
                    ? const Color(0xFFEFEFEF)
                    : const Color(0xFF1A1A1A),
                // We'll use a simple gradient instead of an image that might not be available
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.background,
                    theme.colorScheme.surface,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
              child: BlocConsumer<ConversationBloc, ConversationState>(
                listener: (context, state) {
                  if (state is ConversationLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                  }
                },
                builder: (context, state) {
                  if (state is ConversationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ConversationLoaded) {
                    final messages = state.messages[widget.conversationId] ?? [];
                    
                    if (messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 80,
                              color: theme.colorScheme.primary.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No messages yet',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Send a message to start the conversation',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onBackground.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      controller: _scrollController, // Assign controller
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final showTimestamp = index == 0 || 
                          messages[index].timestamp.difference(messages[index - 1].timestamp).inMinutes > 5;
                        
                        return Column(
                          children: [
                            if (showTimestamp)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceVariant.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _formatMessageDate(message.timestamp),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            _buildMessageBubble(message),
                            
                            // Show the temporary message at the end of the list
                            if (index == messages.length - 1 && _tempMessage != null)
                              AnimatedOpacity(
                                opacity: 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: _tempMessage!,
                              ),
                          ],
                        );
                      },
                    );
                  }
                  if (state is ConversationError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading messages',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text('Loading chat...'));
                },
              ),
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final theme = Theme.of(context);
    final isMe = message.isMe;
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: 12,
        left: isMe ? 64 : 8,
        right: isMe ? 8 : 64,
      ),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Display avatar for received messages
          if (!isMe) ...[
            BlocBuilder<ConversationBloc, ConversationState>(
              builder: (context, state) {
                if (state is ConversationLoaded) {
                  final conversation = state.conversations.firstWhere(
                    (conv) => conv.id == widget.conversationId,
                    orElse: () => Conversation(id: '', contactName: 'Chat', lastMessage: '', timestamp: DateTime.now()),
                  );
                  return AvatarUtils.getAvatar(
                    name: conversation.contactName,
                    radius: 16,
                  );
                }
                return const SizedBox(width: 32, height: 32); // Placeholder
              },
            ),
            const SizedBox(width: 8),
          ],
          
          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? theme.colorScheme.primary : theme.colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isMe ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('h:mm a').format(message.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: isMe ? theme.colorScheme.onPrimary.withOpacity(0.7) : theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      if (isMe)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.done_all,
                            size: 14,
                            color: theme.colorScheme.onPrimary.withOpacity(0.7),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
            // Avatar or empty space for my messages
          if (isMe) const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Attachment feature coming soon!')),
              );
            },
            color: theme.colorScheme.primary,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  // Helper method to format message dates
  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);
    
    if (messageDate == today) {
      return 'Today, ${DateFormat('h:mm a').format(date)}';
    } else if (messageDate == yesterday) {
      return 'Yesterday, ${DateFormat('h:mm a').format(date)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(date);
    }
  }
  
  // Helper method to generate consistent colors for avatars based on contact name
  Color _getAvatarColor(String name) {
    if (name.isEmpty) return Colors.blueGrey;
    
    // List of pleasant colors for avatars
    final colors = [
      const Color(0xFF6750A4), // Purple
      const Color(0xFF16A34A), // Green
      const Color(0xFFEF4444), // Red
      const Color(0xFF3B82F6), // Blue
      const Color(0xFFF59E0B), // Amber
      const Color(0xFF8B5CF6), // Violet
      const Color(0xFFEC4899), // Pink
      const Color(0xFF0D9488), // Teal
    ];
    
    // Use a hash of the name to select a consistent color
    final hashCode = name.hashCode.abs();
    return colors[hashCode % colors.length];
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final messageText = _messageController.text.trim();
      _messageController.clear();
      
      // Create a temporary bubble with sending indicator
      final tempKey = GlobalKey();
      
      // Add temporary visual feedback
      setState(() {
        _tempMessage = Container(
          key: tempKey,
          margin: const EdgeInsets.only(right: 8, bottom: 12, left: 64),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                messageText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Sending...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
      
      // Scroll to show the temp message
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      
      // Simulate network delay and then send the actual message
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _tempMessage = null;
        });
        
        // Now send the actual message
        context.read<ConversationBloc>().add(
          SendMessage(
            conversationId: widget.conversationId,
            text: messageText,
          ),
        );
        
        // Scroll to the bottom after sending
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      });
    }
  }

 @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose(); // Dispose scrollController
    super.dispose();
  }
}
