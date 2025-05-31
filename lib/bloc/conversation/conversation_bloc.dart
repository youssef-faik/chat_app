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

    // Create a new map for messages to ensure Equatable detects change
    final Map<String, List<Message>> updatedMessages = Map.from(_messages);
    updatedMessages[event.conversationId] = [...(updatedMessages[event.conversationId] ?? []), newMessage];
    _messages = updatedMessages; // Update internal messages

    // Update the last message and timestamp of the conversation
    final conversationIndex = _conversations.indexWhere((conv) => conv.id == event.conversationId);
    if (conversationIndex != -1) {
      final originalConversation = _conversations[conversationIndex];
      _conversations[conversationIndex] = Conversation(
        id: originalConversation.id,
        contactName: originalConversation.contactName,
        lastMessage: event.text,
        timestamp: newMessage.timestamp,
        avatarUrl: originalConversation.avatarUrl, // Preserve avatarUrl
        unreadCount: originalConversation.id == event.conversationId ? 0 : originalConversation.unreadCount, // Preserve unreadCount or reset if current user is sender in this chat
      );
    }
    
    // Ensure the updated conversation is at the top
    // Create a new list for conversations
    final List<Conversation> updatedConversationsList = List.from(_conversations);
    if (conversationIndex != -1) { // Check if conversation was found before removing and inserting
        final updatedConversation = updatedConversationsList.removeAt(conversationIndex);
        updatedConversationsList.insert(0, updatedConversation);
    }
    _conversations = updatedConversationsList; // Update internal conversations


    emit(ConversationLoaded(conversations: updatedConversationsList, messages: updatedMessages));
  }

  void _onMarkConversationAsRead(MarkConversationAsRead event, Emitter<ConversationState> emit) {
    final conversationIndex = _conversations.indexWhere((conv) => conv.id == event.conversationId);
    if (conversationIndex != -1) {
      final List<Conversation> updatedConversations = List.from(_conversations);
      final Conversation conversationToUpdate = updatedConversations[conversationIndex];
      
      updatedConversations[conversationIndex] = Conversation(
        id: conversationToUpdate.id, // Preserve ID
        contactName: conversationToUpdate.contactName, // Preserve contactName
        lastMessage: conversationToUpdate.lastMessage, // Preserve lastMessage
        timestamp: conversationToUpdate.timestamp, // Preserve timestamp
        avatarUrl: conversationToUpdate.avatarUrl, // Preserve avatarUrl
        unreadCount: 0, // Mark as read
      );
      
      _conversations = updatedConversations;

      emit(ConversationLoaded(conversations: updatedConversations, messages: Map.from(_messages)));
    }
  }
}
