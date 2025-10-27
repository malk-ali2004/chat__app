import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:chat_app/features/Auth/data/user_model.dart';
import 'package:chat_app/features/Home/data/chat_model.dart';
import 'package:chat_app/features/Home/data/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String message,
    required String receiverEmail,
    required DateTime createdAt,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final messageModel = MessageModel(
        senderEmail: currentUser.email!,
        receiverEmail: receiverEmail,
        message: message,
        dateTime: createdAt,
      );

      await _firestore.collection('Messages').add(messageModel.tojson());
    } catch (e) {
      log('Error sending message: $e');
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await _firestore.collection('Messages').doc(messageId).delete();
      log('Message deleted successfully');
    } catch (e) {
      log('Error deleting message: $e');
    }
  }

  Stream<List<MessageModel>> getMessagesForSpecificUser({
    required String userEmail,
  }) async* {
    final currentUserEmail = _auth.currentUser?.email;
    if (currentUserEmail == null) {
      yield [];
      return;
    }

    final senderToReceiver = _firestore
        .collection('Messages')
        .where('senderEmail', isEqualTo: currentUserEmail)
        .where('receiverEmail', isEqualTo: userEmail)
        .snapshots();

    final receiverToSender = _firestore
        .collection('Messages')
        .where('senderEmail', isEqualTo: userEmail)
        .where('receiverEmail', isEqualTo: currentUserEmail)
        .snapshots();

    await for (var senderSnap in senderToReceiver) {
      final receiverSnap = await receiverToSender.first;
      final allMessages = [...senderSnap.docs, ...receiverSnap.docs]
          .map((e) => MessageModel.fromJson(e.data() as Map<String, dynamic>))
          .toList();

      allMessages.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      yield allMessages;
    }
  }

  Future<UserModel> getPartnerData({required String email}) async {
    try {
      final userDoc = await _firestore.collection('users').doc(email).get();
      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      log('Error fetching user: $e');
      rethrow;
    }
  }

  Stream<List<ChatModel>> getLastTimeMessages() async* {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      yield [];
      return;
    }

    final currentEmail = currentUser.email!;
    final CollectionReference messagesRef = _firestore.collection('Messages');

    await for (var snapshot in messagesRef.snapshots()) {
      List<MessageModel> myMessages = snapshot.docs
          .map((e) => MessageModel.fromJson(e.data() as Map<String, dynamic>))
          .where(
            (msg) =>
                msg.senderEmail == currentEmail ||
                msg.receiverEmail == currentEmail,
          )
          .toList();

      Map<String, MessageModel> lastMessages = {};

      for (var msg in myMessages) {
        String chatPartner = msg.senderEmail == currentEmail
            ? msg.receiverEmail
            : msg.senderEmail;

        if (!lastMessages.containsKey(chatPartner) ||
            msg.dateTime.isAfter(lastMessages[chatPartner]!.dateTime)) {
          lastMessages[chatPartner] = msg;
        }
      }

      List<ChatModel> chatList = [];
      for (var entry in lastMessages.entries) {
        try {
          UserModel userModel = await getPartnerData(email: entry.key);
          chatList.add(
            ChatModel(
              user: userModel,
              lastMessage: entry.value.message,
              lastMessageTime: entry.value.dateTime,
            ),
          );
        } catch (_) {}
      }

      chatList.sort((x, y) => y.lastMessageTime.compareTo(x.lastMessageTime));
      yield chatList;
    }
  }
}
