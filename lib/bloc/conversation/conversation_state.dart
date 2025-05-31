import 'package:equatable/equatable.dart';
import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/models/message_model.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<Conversation> conversations;
  final Map<String, List<Message>> messages;

  const ConversationLoaded({required this.conversations, required this.messages});

  @override
  List<Object> get props => [conversations, messages];
}

class ConversationError extends ConversationState {
  final String message;

  const ConversationError({required this.message});

  @override
  List<Object> get props => [message];
}
