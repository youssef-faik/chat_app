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
    on<CreateConversation>(_onCreateConversation); // Register new event handler
  }

  void _onLoadConversations(LoadConversations event, Emitter<ConversationState> emit) {
    emit(ConversationLoading());
    // Simulate loading data
    _conversations = List.from(mockConversations);
    _messages = Map.from(mockMessages);
    emit(ConversationLoaded(conversations: _conversations, messages: _messages));
  }

  void _onSendMessage(SendMessage event, Emitter<ConversationState> emit) {
    // Create a new message from user
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
        lastMessage: "You: ${event.text}", // Add "You: " prefix for user messages
        timestamp: newMessage.timestamp,
        avatarUrl: originalConversation.avatarUrl, 
        unreadCount: originalConversation.id == event.conversationId ? 0 : originalConversation.unreadCount,
      );
    }
    
    // Create a new list for conversations
    final List<Conversation> updatedConversationsList = List.from(_conversations);
    if (conversationIndex != -1) { 
        final updatedConversation = updatedConversationsList.removeAt(conversationIndex);
        updatedConversationsList.insert(0, updatedConversation);
    }
    _conversations = updatedConversationsList; // Update internal conversations

    // Emit updated state with user's message
    emit(ConversationLoaded(conversations: updatedConversationsList, messages: updatedMessages));
    
    // Auto-reply simulation if enabled
    if (event.autoReply) {
      // Simulate a delay before the contact replies
      Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
        // Get the conversation for the auto-reply
        final replyConversation = _conversations.firstWhere(
          (conv) => conv.id == event.conversationId,
          orElse: () => Conversation(id: '', contactName: '', lastMessage: '', timestamp: DateTime.now()),
        );
        
        if (replyConversation.id.isNotEmpty) {
          // Generate a response based on the user's message
          final String replyText = _generateAutoReply(event.text, replyConversation.contactName);
          
          // Create the auto-reply message
          final replyMessage = Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            conversationId: event.conversationId,
            content: replyText,
            isMe: false, // Message from contact
            timestamp: DateTime.now(),
          );
          
          // Add to messages map
          final Map<String, List<Message>> updatedMessagesWithReply = Map.from(_messages);
          updatedMessagesWithReply[event.conversationId] = [
            ...(updatedMessagesWithReply[event.conversationId] ?? []),
            replyMessage
          ];
          _messages = updatedMessagesWithReply;
          
          // Update conversation with new last message
          final List<Conversation> updatedConversations = List.from(_conversations);
          final replyConversationIndex = updatedConversations.indexWhere((conv) => conv.id == event.conversationId);
          
          if (replyConversationIndex != -1) {
            final originalConv = updatedConversations[replyConversationIndex];
            updatedConversations[replyConversationIndex] = Conversation(
              id: originalConv.id,
              contactName: originalConv.contactName,
              lastMessage: replyText,
              timestamp: replyMessage.timestamp,
              avatarUrl: originalConv.avatarUrl,
              unreadCount: 1, // Add an unread message
            );
            
            // Move conversation to top if not already there
            if (replyConversationIndex > 0) {
              final updatedConv = updatedConversations.removeAt(replyConversationIndex);
              updatedConversations.insert(0, updatedConv);
            }
            
            _conversations = updatedConversations;
          }
          
          // Emit updated state with auto-reply
          emit(ConversationLoaded(conversations: updatedConversations, messages: updatedMessagesWithReply));
        }
      });
    }
  }
  
  // Helper method to generate auto-replies
  String _generateAutoReply(String userMessage, String contactName) {
    final lowerCaseMessage = userMessage.toLowerCase();
    
    if (lowerCaseMessage.contains('hello') || lowerCaseMessage.contains('hi') || lowerCaseMessage.contains('hey')) {
      return 'Hi there! How can I help you today?';
    }
    else if (lowerCaseMessage.contains('how are you')) {
      return 'I\'m doing great, thanks for asking! How about you?';
    }
    else if (lowerCaseMessage.contains('bye') || lowerCaseMessage.contains('goodbye')) {
      return 'Goodbye! Talk to you later!';
    }
    else if (lowerCaseMessage.contains('thank')) {
      return 'You\'re welcome!';
    }
    else if (lowerCaseMessage.contains('?')) {
      return 'Let me think about that...';
    }
    else {
      // Random replies for variety
      final replies = [
        'That\'s interesting!',
        'I see what you mean.',
        'Tell me more about that.',
        'I appreciate you reaching out!',
        'Let\'s discuss this further.',
        'I understand.',
      ];
      
      final random = DateTime.now().millisecondsSinceEpoch % replies.length;
      return replies[random];
    }
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

  void _onCreateConversation(CreateConversation event, Emitter<ConversationState> emit) {
    final newConversationId = DateTime.now().millisecondsSinceEpoch.toString();
    final newConversation = Conversation(
      id: newConversationId,
      contactName: event.contactName,
      lastMessage: 'Conversation started',
      timestamp: DateTime.now(),
      unreadCount: 0,
      // avatarUrl: null, // Can be omitted, defaults to null
    );

    final List<Conversation> updatedConversations = [newConversation, ..._conversations];
    _conversations = updatedConversations;

    final Map<String, List<Message>> updatedMessages = Map.from(_messages);
    updatedMessages[newConversationId] = []; // Initialize with empty messages
    _messages = updatedMessages;

    emit(ConversationLoaded(conversations: updatedConversations, messages: updatedMessages));
  }
}
