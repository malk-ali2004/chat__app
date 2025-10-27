import 'dart:io';
import 'package:chat_app/features/Auth/data/user_model.dart';
import 'package:chat_app/features/Home/cubit/chat_cubit.dart';
import 'package:chat_app/features/Home/data/message_model.dart';
import 'package:chat_app/features/Home/widgets/reciver_message.dart';
import 'package:chat_app/features/Home/widgets/sender_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
    required this.receiverEmail,
    required this.receiverUser,
  });

  final String receiverEmail;
  final UserModel receiverUser;

  static String routeName = 'chat-view';

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController messageController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  bool isSending = false;

  Future<void> sendImage(String receiverEmail) async {
    try {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => isSending = true);

        final ref = FirebaseStorage.instance.ref().child(
          'chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        await ref.putFile(File(picked.path));
        final url = await ref.getDownloadURL();

        if (!mounted) return;
        await BlocProvider.of<ChatCubit>(context).sendMessage(
          message: url,
          receiverEmail: receiverEmail,
          createdAt: DateTime.now(),
        );
      }
    } catch (e) {
      debugPrint("Image send error: $e");
    } finally {
      if (mounted) setState(() => isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = widget.receiverUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(userModel.image!)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Online",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.videocam, color: Colors.purple, size: 28),
          SizedBox(width: 10),
          Icon(Icons.call, color: Colors.purple, size: 24),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: BlocProvider.of<ChatCubit>(context)
                  .getMessagesForSpecificUser(
                    userEmail: widget.receiverUser.email,
                  ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      "No messages yet...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final msg = messages[i];
                    bool isMe =
                        msg.senderEmail ==
                        FirebaseAuth.instance.currentUser!.email;

                    final isImage = msg.message.startsWith('https://');

                    return Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        isMe
                            ? SenderMessageWidget(
                                message: msg.message,
                                isImage: isImage,
                              )
                            : ReciverMessageWidget(
                                message: msg.message,
                                isImage: isImage,
                              ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 4,
                          ),
                          child: Text(
                            "${msg.dateTime.hour.toString().padLeft(2, '0')}:${msg.dateTime.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Theme.of(context).cardColor,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.mic, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    debugPrint("Voice recording clicked");
                  },
                ),

                IconButton(
                  icon: Icon(
                    Icons.image,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: isSending
                      ? null
                      : () async {
                          await sendImage(widget.receiverUser.email);
                        },
                ),

                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                  onPressed: () async {
                    final text = messageController.text.trim();
                    if (text.isEmpty) return;

                    await BlocProvider.of<ChatCubit>(context).sendMessage(
                      message: text,
                      receiverEmail: widget.receiverUser.email,
                      createdAt: DateTime.now(),
                    );

                    if (!mounted) return;
                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
