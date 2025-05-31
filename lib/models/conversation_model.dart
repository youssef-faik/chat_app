import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  final String id;
  final String contactName;
  final String lastMessage;
  final DateTime timestamp;
  final String? avatarUrl;
  final int? unreadCount;

  const Conversation({
    required this.id,
    required this.contactName,
    required this.lastMessage,
    required this.timestamp,
    this.avatarUrl,
    this.unreadCount,
  });

  @override
  List<Object?> get props => [id, contactName, lastMessage, timestamp, avatarUrl, unreadCount];
}
