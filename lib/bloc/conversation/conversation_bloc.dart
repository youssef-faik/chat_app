import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/bloc/conversation/conversation_event.dart';
import 'package:chat_app/bloc/conversation/conversation_state.dart';
import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/data/mock_data.dart'; // Assuming mock data is here

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  List<Conversation> _conversations = [];
  Map<String, List<Message>> _messages = {};

  ConversationBloc() : super(ConversationInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<SendMessage>(_onSendMessage);
    on<MarkConversationAsRead>(_onMarkConversationAsRead);
  }

  void _onLoadConversations(LoadConversations event, Emitter<ConversationState> emit) {
    emit(ConversationLoading());
    // Simulate loading data
    _conversations = List.from(mockConversations);
    _messages = Map.from(mockMessages);
    emit(ConversationLoaded(conversations: _conversations, messages: _messages));
  }

  void _onSendMessage(SendMessage event, Emitter<ConversationState> emit) {
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: event.conversationId,
      content: event.text,
      isMe: true,
      timestamp: DateTime.now(),
    );

    // Add message to the specific conversation's list
    _messages[event.conversationId] = [...(_messages[event.conversationId] ?? []), newMessage];

    // Update the last message and timestamp of the conversation
    final conversationIndex = _conversations.indexWhere((conv) => conv.id == event.conversationId);
    if (conversationIndex != -1) {
      _conversations[conversationIndex] = Conversation(
        id: _conversations[conversationIndex].id,
        contactName: _conversations[conversationIndex].contactName,
        lastMessage: event.text,
        timestamp: newMessage.timestamp,
        avatarUrl: _conversations[conversationIndex].avatarUrl,
        unreadCount: _conversations[conversationIndex].id == event.conversationId ? 0 : _conversations[conversationIndex].unreadCount, // Reset unread if it's the active chat
      );
    }
    // Ensure the updated conversation is at the top
    final updatedConversation = _conversations.removeAt(conversationIndex);
    _conversations.insert(0, updatedConversation);

    emit(ConversationLoaded(conversations: List.from(_conversations), messages: Map.from(_messages)));
  }

  void _onMarkConversationAsRead(MarkConversationAsRead event, Emitter<ConversationState> emit) {
    final conversationIndex = _conversations.indexWhere((conv) => conv.id == event.conversationId);
    if (conversationIndex != -1) {
      _conversations[conversationIndex] = Conversation(
        id: _conversations[conversationIndex].id,
        contactName: _conversations[conversationIndex].contactName,
        lastMessage: _conversations[conversationIndex].lastMessage,
        timestamp: _conversations[conversationIndex].timestamp,
        avatarUrl: _conversations[conversationIndex].avatarUrl,
        unreadCount: 0, // Mark as read
      );
      emit(ConversationLoaded(conversations: List.from(_conversations), messages: Map.from(_messages)));
    }
  }
}
