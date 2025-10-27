import 'package:chat_app/features/Auth/data/user_model.dart';

class ChatModel {
  final UserModel user;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatModel({
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}
