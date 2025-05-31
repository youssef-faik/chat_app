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

  const SendMessage({required this.conversationId, required this.text});

  @override
  List<Object> get props => [conversationId, text];
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
