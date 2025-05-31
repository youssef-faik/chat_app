import 'package:chat_app/bloc/conversation/conversation_bloc.dart';
import 'package:chat_app/bloc/conversation/conversation_event.dart';
import 'package:chat_app/bloc/conversation/conversation_state.dart';
import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/screens/conversation_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ConversationBloc>().add(LoadConversations());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Future enhancement: Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search functionality coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Future enhancement: Show menu options
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu options coming soon!')),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
          if (state is ConversationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ConversationLoaded) {
            if (state.conversations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 80,
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No conversations yet',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start a new chat by tapping the + button',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              itemCount: state.conversations.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 76),
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];
                final hasUnreadMessages = conversation.unreadCount != null && conversation.unreadCount! > 0;
                
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Hero(
                    tag: 'avatar-${conversation.id}',
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: _getAvatarColor(conversation.contactName),
                      child: Text(
                        conversation.contactName.isNotEmpty ? conversation.contactName[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.contactName,
                          style: TextStyle(
                            fontWeight: hasUnreadMessages ? FontWeight.bold : FontWeight.normal,
                            fontSize: 17,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        DateFormat('h:mm a').format(conversation.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: hasUnreadMessages 
                            ? theme.colorScheme.primary 
                            : theme.colorScheme.onBackground.withOpacity(0.5),
                          fontWeight: hasUnreadMessages ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: hasUnreadMessages 
                                ? theme.colorScheme.onBackground 
                                : theme.colorScheme.onBackground.withOpacity(0.6),
                              fontWeight: hasUnreadMessages ? FontWeight.w500 : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (hasUnreadMessages)
                          Container(
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              conversation.unreadCount.toString(),
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  onTap: () {
                    context.read<ConversationBloc>().add(MarkConversationAsRead(conversationId: conversation.id));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<ConversationBloc>(context),
                          child: ConversationDetailScreen(conversationId: conversation.id),
                        ),
                      ),
                    );
                  },
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
                    'Error',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ConversationBloc>().add(LoadConversations());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Press a button to load conversations'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateConversationDialog(context);
        },
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
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

  void _showCreateConversationDialog(BuildContext parentContext) {
    final theme = Theme.of(parentContext);
    final TextEditingController nameController = TextEditingController();
    
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.person_add, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              const Text('New Conversation'),
            ],
          ),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: "Enter contact's name",
              prefixIcon: Icon(Icons.person),
            ),
            autofocus: true,
            textCapitalization: TextCapitalization.words,
          ),
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Create'),
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  parentContext.read<ConversationBloc>().add(CreateConversation(contactName: nameController.text.trim()));
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        );
      },
    );
  }
}
