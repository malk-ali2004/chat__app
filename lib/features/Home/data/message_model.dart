import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String message;
  String senderEmail;
  String receiverEmail;
  DateTime dateTime;

  MessageModel({
    required this.message,
    required this.senderEmail,
    required this.receiverEmail,
    required this.dateTime,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: (json['message'] ?? '').toString(),
      senderEmail: (json['senderEmail'] ?? '').toString(),
      receiverEmail: (json['receiverEmail'] ?? '').toString(),
      dateTime: json['dateTime'] != null
          ? (json['dateTime'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'message': message,
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'dateTime': dateTime,
    };
  }
}
