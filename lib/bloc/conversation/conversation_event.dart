import 'package:equatable/equatable.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class LoadConversations extends ConversationEvent {}

class SendMessage extends ConversationEvent {
  final String conversationId;
  final String text;
  final bool autoReply; // Add a parameter to control auto-reply

  const SendMessage({
    required this.conversationId,
    required this.text,
    this.autoReply = true, // Default to true
  });

  @override
  List<Object> get props => [conversationId, text, autoReply];
}

class MarkConversationAsRead extends ConversationEvent {
  final String conversationId;

  const MarkConversationAsRead({required this.conversationId});

  @override
  List<Object> get props => [conversationId];
}

class CreateConversation extends ConversationEvent {
  final String contactName;

  const CreateConversation({required this.contactName});

  @override
  List<Object> get props => [contactName];
}
