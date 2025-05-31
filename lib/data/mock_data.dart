import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/models/message_model.dart';

final mockConversations = [
  Conversation(
    id: '1',
    contactName: 'Alice',
    lastMessage: 'Hey, how are you?',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    avatarUrl: 'https://i.pravatar.cc/150?u=alice@example.com',
    unreadCount: 2,
  ),
  Conversation(
    id: '2',
    contactName: 'Bob',
    lastMessage: 'See you tomorrow!',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    avatarUrl: 'https://i.pravatar.cc/150?u=bob@example.com',
    unreadCount: 0,
  ),
  Conversation(
    id: '3',
    contactName: 'Charlie',
    lastMessage: 'Okay, sounds good.',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    avatarUrl: 'https://i.pravatar.cc/150?u=charlie@example.com',
    unreadCount: 1,
  ),
];

final mockMessages = <String, List<Message>>{
  '1': [
    Message(id: 'm1', conversationId: '1', content: 'Hi Alice!', isMe: false, timestamp: DateTime.now().subtract(const Duration(minutes: 10))),
    Message(id: 'm2', conversationId: '1', content: 'Hey, how are you?', isMe: true, timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
  ],
  '2': [
    Message(id: 'm3', conversationId: '2', content: 'Meeting at 3 PM.', isMe: false, timestamp: DateTime.now().subtract(const Duration(hours: 2))),
    Message(id: 'm4', conversationId: '2', content: 'See you tomorrow!', isMe: true, timestamp: DateTime.now().subtract(const Duration(hours: 1))),
  ],
  '3': [
    Message(id: 'm5', conversationId: '3', content: 'Can you send the file?', isMe: false, timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2))),
    Message(id: 'm6', conversationId: '3', content: 'Okay, sounds good.', isMe: true, timestamp: DateTime.now().subtract(const Duration(days: 1))),
  ],
};
