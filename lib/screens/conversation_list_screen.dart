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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
          if (state is ConversationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ConversationLoaded) {
            if (state.conversations.isEmpty) {
              return const Center(child: Text('No conversations yet.'));
            }
            return ListView.builder(
              itemCount: state.conversations.length,
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer, // Use a theme color for background
                    child: Text(
                      conversation.contactName.isNotEmpty ? conversation.contactName[0].toUpperCase() : '?', // Display first letter or '?'
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer, // Use a contrasting theme color for text
                        fontWeight: FontWeight.bold,
                        fontSize: 20, // Adjust as needed
                      ),
                    ),
                  ),
                  title: Text(conversation.contactName),
                  subtitle: Text(conversation.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(DateFormat('hh:mm a').format(conversation.timestamp)),
                      if (conversation.unreadCount != null && conversation.unreadCount! > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            conversation.unreadCount.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
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
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Press a button to load conversations'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement create new conversation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New conversation feature not implemented yet.')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
