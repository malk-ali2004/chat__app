// // // // // // import 'dart:io';
// // // // // // // import 'package:chat_app/core/utils/style/screen_size.dart';
// // // // // // import 'package:chat_app/features/Auth/data/user_model.dart';
// // // // // // import 'package:chat_app/features/Home/cubit/chat_cubit.dart';
// // // // // // import 'package:chat_app/features/Home/data/message_model.dart';
// // // // // // import 'package:chat_app/features/Home/widgets/reciver_message.dart';
// // // // // // import 'package:chat_app/features/Home/widgets/sender_message.dart';
// // // // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // // // import 'package:firebase_storage/firebase_storage.dart';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // // // // import 'package:image_picker/image_picker.dart';

// // // // // // class ChatView extends StatefulWidget {
// // // // // //   const ChatView({super.key});
// // // // // //   static String routeName = 'chat-view';

// // // // // //   @override
// // // // // //   State<ChatView> createState() => _ChatViewState();
// // // // // // }

// // // // // // class _ChatViewState extends State<ChatView> {
// // // // // //   TextEditingController messageController = TextEditingController();
// // // // // //   final ImagePicker picker = ImagePicker();

// // // // // //   Future<void> sendImage(String receiverEmail) async {
// // // // // //     final picked = await picker.pickImage(source: ImageSource.gallery);
// // // // // //     if (picked != null) {
// // // // // //       final ref = FirebaseStorage.instance.ref().child(
// // // // // //         'chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
// // // // // //       );
// // // // // //       await ref.putFile(File(picked.path));
// // // // // //       final url = await ref.getDownloadURL();
// // // // // //       await BlocProvider.of<ChatCubit>(context).sentMessage(
// // // // // //         message: url,
// // // // // //         reciverEmail: receiverEmail,
// // // // // //         createdAt: DateTime.now(),
// // // // // //       );
// // // // // //     }
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final UserModel userModel =
// // // // // //         ModalRoute.of(context)!.settings.arguments as UserModel;

// // // // // //     return Scaffold(
// // // // // //       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// // // // // //       appBar: AppBar(
// // // // // //         backgroundColor: Colors.white,
// // // // // //         elevation: 2,
// // // // // //         leading: IconButton(
// // // // // //           icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
// // // // // //           onPressed: () => Navigator.pop(context),
// // // // // //         ),
// // // // // //         title: Row(
// // // // // //           children: [
// // // // // //             CircleAvatar(backgroundImage: NetworkImage(userModel.image!)),
// // // // // //             const SizedBox(width: 10),
// // // // // //             Column(
// // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //               children: [
// // // // // //                 Text(
// // // // // //                   userModel.name,
// // // // // //                   style: const TextStyle(
// // // // // //                     color: Colors.black,
// // // // // //                     fontWeight: FontWeight.bold,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 const Text(
// // // // // //                   "Online",
// // // // // //                   style: TextStyle(color: Colors.grey, fontSize: 12),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //         actions: const [
// // // // // //           Icon(Icons.videocam, color: Colors.purple, size: 28),
// // // // // //           SizedBox(width: 10),
// // // // // //           Icon(Icons.call, color: Colors.purple, size: 24),
// // // // // //           SizedBox(width: 10),
// // // // // //         ],
// // // // // //       ),
// // // // // //       body: Column(
// // // // // //         children: [
// // // // // //           Expanded(
// // // // // //             child: StreamBuilder<QuerySnapshot>(
// // // // // //               stream: BlocProvider.of<ChatCubit>(
// // // // // //                 context,
// // // // // //               ).getMessagesForSpecificUser(userEmail: userModel.email),
// // // // // //               builder: (context, snapshot) {
// // // // // //                 if (!snapshot.hasData) {
// // // // // //                   return const Center(child: CircularProgressIndicator());
// // // // // //                 }

// // // // // //                 var messages = snapshot.data!.docs
// // // // // //                     // .map((e) => MessageModel.fromJson(e.data()))
// // // // // //                     .map(
// // // // // //                       (e) => MessageModel.fromJson(
// // // // // //                         e.data() as Map<String, dynamic>,
// // // // // //                       ),
// // // // // //                     )
// // // // // //                     .toList();

// // // // // //                 // ترتيب الرسائل حسب الوقت
// // // // // //                 messages.sort((a, b) => a.dateTime.compareTo(b.dateTime));

// // // // // //                 return ListView.builder(
// // // // // //                   padding: const EdgeInsets.all(10),
// // // // // //                   itemCount: messages.length,
// // // // // //                   itemBuilder: (context, i) {
// // // // // //                     final msg = messages[i];
// // // // // //                     bool isMe =
// // // // // //                         msg.senderEmail ==
// // // // // //                         FirebaseAuth.instance.currentUser!.email;

// // // // // //                     final isImage = msg.message.startsWith('https://');

// // // // // //                     return Column(
// // // // // //                       crossAxisAlignment: isMe
// // // // // //                           ? CrossAxisAlignment.end
// // // // // //                           : CrossAxisAlignment.start,
// // // // // //                       children: [
// // // // // //                         isMe
// // // // // //                             ? SenderMessageWidget(
// // // // // //                                 message: msg.message,
// // // // // //                                 isImage: isImage,
// // // // // //                               )
// // // // // //                             : ReciverMessageWidget(
// // // // // //                                 message: msg.message,
// // // // // //                                 isImage: isImage,
// // // // // //                               ),
// // // // // //                         Padding(
// // // // // //                           padding: const EdgeInsets.only(
// // // // // //                             left: 10,
// // // // // //                             right: 10,
// // // // // //                             top: 4,
// // // // // //                           ),
// // // // // //                           child: Text(
// // // // // //                             "${msg.dateTime.hour.toString().padLeft(2, '0')}:${msg.dateTime.minute.toString().padLeft(2, '0')}",
// // // // // //                             style: const TextStyle(
// // // // // //                               fontSize: 10,
// // // // // //                               color: Colors.grey,
// // // // // //                             ),
// // // // // //                           ),
// // // // // //                         ),
// // // // // //                       ],
// // // // // //                     );
// // // // // //                   },
// // // // // //                 );
// // // // // //               },
// // // // // //             ),
// // // // // //           ),

// // // // // //           // شريط الإدخال
// // // // // //           Container(
// // // // // //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// // // // // //             color: Colors.white,
// // // // // //             child: Row(
// // // // // //               children: [
// // // // // //                 IconButton(
// // // // // //                   icon: const Icon(Icons.image, color: Colors.purple),
// // // // // //                   onPressed: () async {
// // // // // //                     await sendImage(userModel.email);
// // // // // //                   },
// // // // // //                 ),
// // // // // //                 IconButton(
// // // // // //                   icon: const Icon(Icons.mic, color: Colors.purple),
// // // // // //                   onPressed: () {
// // // // // //                     // هنا ممكن تضيف تسجيل الصوت لاحقاً
// // // // // //                   },
// // // // // //                 ),
// // // // // //                 Expanded(
// // // // // //                   child: TextField(
// // // // // //                     controller: messageController,
// // // // // //                     decoration: const InputDecoration(
// // // // // //                       hintText: "Type a message...",
// // // // // //                       border: InputBorder.none,
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 IconButton(
// // // // // //                   icon: const Icon(Icons.send, color: Colors.purple),
// // // // // //                   onPressed: () async {
// // // // // //                     if (messageController.text.trim().isNotEmpty) {
// // // // // //                       await BlocProvider.of<ChatCubit>(context).sentMessage(
// // // // // //                         message: messageController.text.trim(),
// // // // // //                         reciverEmail: userModel.email,
// // // // // //                         createdAt: DateTime.now(),
// // // // // //                       );
// // // // // //                       messageController.clear();
// // // // // //                     }
// // // // // //                   },
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // import 'dart:io';
// // // import 'package:chat_app/core/utils/style/screen_size.dart';
// // import 'package:chat_app/features/Auth/data/user_model.dart';
// // import 'package:chat_app/features/Home/cubit/chat_cubit.dart';
// // import 'package:chat_app/features/Home/data/message_model.dart';
// // import 'package:chat_app/features/Home/widgets/reciver_message.dart';
// // import 'package:chat_app/features/Home/widgets/sender_message.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:image_picker/image_picker.dart';

// // class ChatView extends StatefulWidget {
// //   const ChatView({super.key});
// //   static String routeName = 'chat-view';

// //   @override
// //   State<ChatView> createState() => _ChatViewState();
// // }

// // class _ChatViewState extends State<ChatView> {
// //   TextEditingController messageController = TextEditingController();
// //   final ImagePicker picker = ImagePicker();
// //   bool isSending = false;

// //   // 🔹 إرسال صورة
// //   Future<void> sendImage(String receiverEmail) async {
// //     try {
// //       final picked = await picker.pickImage(source: ImageSource.gallery);
// //       if (picked != null) {
// //         setState(() => isSending = true);

// //         final ref = FirebaseStorage.instance.ref().child(
// //           'chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
// //         );

// //         await ref.putFile(File(picked.path));
// //         final url = await ref.getDownloadURL();

// //         await BlocProvider.of<ChatCubit>(context).senMessage(
// //           message: url,
// //           reciverEmail: receiverEmail,
// //           createdAt: DateTime.now(),
// //         );
// //       }
// //     } catch (e) {
// //       debugPrint("Image send error: $e");
// //     } finally {
// //       setState(() => isSending = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final UserModel userModel =
// //         ModalRoute.of(context)!.settings.arguments as UserModel;

// //     return Scaffold(
// //       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         elevation: 2,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //         title: Row(
// //           children: [
// //             CircleAvatar(backgroundImage: NetworkImage(userModel.image!)),
// //             const SizedBox(width: 10),
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   userModel.name,
// //                   style: const TextStyle(
// //                     color: Colors.black,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const Text(
// //                   "Online",
// //                   style: TextStyle(color: Colors.grey, fontSize: 12),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //         actions: const [
// //           Icon(Icons.videocam, color: Colors.purple, size: 28),
// //           SizedBox(width: 10),
// //           Icon(Icons.call, color: Colors.purple, size: 24),
// //           SizedBox(width: 10),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           // 🔹 عرض الرسائل
// //           Expanded(
// //             child: StreamBuilder<QuerySnapshot>(
// //               stream: BlocProvider.of<ChatCubit>(
// //                 context,
// //               ).getMessagesForSpecificUser(userEmail: userModel.email),
// //               builder: (context, snapshot) {
// //                 if (!snapshot.hasData) {
// //                   return const Center(child: CircularProgressIndicator());
// //                 }

// //                 var messages = snapshot.data!.docs
// //                     .map(
// //                       (e) => MessageModel.fromJson(
// //                         e.data() as Map<String, dynamic>,
// //                       ),
// //                     )
// //                     .toList();

// //                 // ترتيب الرسائل حسب الوقت
// //                 messages.sort((a, b) => a.dateTime.compareTo(b.dateTime));

// //                 return ListView.builder(
// //                   padding: const EdgeInsets.all(10),
// //                   itemCount: messages.length,
// //                   itemBuilder: (context, i) {
// //                     final msg = messages[i];
// //                     bool isMe =
// //                         msg.senderEmail ==
// //                         FirebaseAuth.instance.currentUser!.email;

// //                     final isImage = msg.message.startsWith('https://');

// //                     return Column(
// //                       crossAxisAlignment: isMe
// //                           ? CrossAxisAlignment.end
// //                           : CrossAxisAlignment.start,
// //                       children: [
// //                         isMe
// //                             ? SenderMessageWidget(
// //                                 message: msg.message,
// //                                 isImage: isImage,
// //                               )
// //                             : ReciverMessageWidget(
// //                                 message: msg.message,
// //                                 isImage: isImage,
// //                               ),
// //                         Padding(
// //                           padding: const EdgeInsets.only(
// //                             left: 10,
// //                             right: 10,
// //                             top: 4,
// //                           ),
// //                           child: Text(
// //                             "${msg.dateTime.hour.toString().padLeft(2, '0')}:${msg.dateTime.minute.toString().padLeft(2, '0')}",
// //                             style: const TextStyle(
// //                               fontSize: 10,
// //                               color: Colors.grey,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     );
// //                   },
// //                 );
// //               },
// //             ),
// //           ),

// //           // 🔹 شريط الإدخال السفلي
// //           // Container(
// //           //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //           //   color: Colors.white,
// //           //   child: Row(
// //           //     children: [
// //           //       IconButton(
// //           //         icon: const Icon(Icons.image, color: Colors.purple),
// //           //         onPressed: isSending
// //           //             ? null
// //           //             : () async {
// //           //                 await sendImage(userModel.email);
// //           //               },
// //           //       ),
// //           //       IconButton(
// //           //         icon: const Icon(Icons.mic, color: Colors.purple),
// //           //         onPressed: () {
// //           //           // تسجيل الصوت هيتضاف لاحقاً
// //           //         },
// //           //       ),
// //           //       Expanded(
// //           //         child: TextField(
// //           //           controller: messageController,
// //           //           decoration: const InputDecoration(
// //           //             hintText: "Type a message...",
// //           //             border: InputBorder.none,
// //           //           ),
// //           //         ),
// //           //       ),
// //           //       IconButton(
// //           //         icon: const Icon(Icons.send, color: Colors.purple),
// //           //         onPressed: () async {
// //           //           final text = messageController.text.trim();
// //           //           if (text.isEmpty) return;

// //           //           await BlocProvider.of<ChatCubit>(context).sentMessage(
// //           //             message: text,
// //           //             reciverEmail: userModel.email,
// //           //             createdAt: DateTime.now(),
// //           //           );

// //           //           // 🟢 امسح الرسالة بعد الإرسال
// //           //           setState(() {
// //           //             messageController.clear();
// //           //           });
// //           //         },
// //           //       ),
// //           //     ],
// //           //   ),
// //           // ),
// //           // 🔹 شريط الإدخال السفلي
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //             color: Theme.of(context).cardColor, // ✅ بدل الأبيض بلون الـ theme
// //             child: Row(
// //               children: [
// //                 IconButton(
// //                   icon: Icon(
// //                     Icons.image,
// //                     color: Theme.of(context).primaryColor,
// //                   ),
// //                   onPressed: isSending
// //                       ? null
// //                       : () async {
// //                           await sendImage(userModel.email);
// //                         },
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.mic, color: Theme.of(context).primaryColor),
// //                   onPressed: () {
// //                     // تسجيل الصوت لاحقاً
// //                   },
// //                 ),
// //                 Expanded(
// //                   child: TextField(
// //                     controller: messageController,
// //                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
// //                       color: Theme.of(context).brightness == Brightness.dark
// //                           ? Colors.white
// //                           : Colors.black,
// //                     ),
// //                     decoration: InputDecoration(
// //                       hintText: "Type a message...",
// //                       hintStyle: TextStyle(
// //                         color: Theme.of(context).brightness == Brightness.dark
// //                             ? Colors.white54
// //                             : Colors.black54,
// //                       ),
// //                       filled: true,
// //                       fillColor: Theme.of(context).brightness == Brightness.dark
// //                           ? Colors.grey[900]
// //                           : Colors.grey[200],
// //                       contentPadding: const EdgeInsets.symmetric(
// //                         horizontal: 15,
// //                         vertical: 10,
// //                       ),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(25),
// //                         borderSide: BorderSide.none,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
// //                   onPressed: () async {
// //                     final text = messageController.text.trim();
// //                     if (text.isEmpty) return;

// //                     await BlocProvider.of<ChatCubit>(context).sentMessage(
// //                       message: text,
// //                       reciverEmail: userModel.email,
// //                       createdAt: DateTime.now(),
// //                     );

// //                     // 🟢 امسح الرسالة بعد الإرسال
// //                     setState(() {
// //                       messageController.clear();
// //                     });
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:chat_app/features/Home/cubit/chat_cubit.dart';
// // // import 'package:chat_app/features/Auth/data/user_model.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';

// // // class ChatView extends StatefulWidget {
// // //   final String receiverEmail;
// // //   final UserModel receiverUser;
// // //   static const String routeName = '/chatView';

// // //   const ChatView({
// // //     super.key,
// // //     required this.receiverEmail,
// // //     required this.receiverUser,
// // //   });

// // //   @override
// // //   State<ChatView> createState() => _ChatViewState();
// // // }

// // // class _ChatViewState extends State<ChatView> {
// // //   final TextEditingController messageController = TextEditingController();
// // //   final currentUser = FirebaseAuth.instance.currentUser!;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Row(
// // //           children: [
// // //             CircleAvatar(
// // //               backgroundImage: NetworkImage(widget.receiverUser.image ?? ""),
// // //             ),
// // //             const SizedBox(width: 10),
// // //             Text(widget.receiverUser.name ?? ""),
// // //           ],
// // //         ),
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           // 🔹 عرض الرسائل Realtime
// // //           Expanded(
// // //             child: StreamBuilder<QuerySnapshot>(
// // //               stream: FirebaseFirestore.instance
// // //                   .collection('Messages')
// // //                   .orderBy('dateTime')
// // //                   .snapshots(),
// // //               builder: (context, snapshot) {
// // //                 if (!snapshot.hasData) {
// // //                   return const Center(child: CircularProgressIndicator());
// // //                 }

// // //                 final messages = snapshot.data!.docs.where((doc) {
// // //                   final data = doc.data() as Map<String, dynamic>;
// // //                   return (data['senderEmail'] == currentUser.email &&
// // //                           data['receiverEmail'] == widget.receiverEmail) ||
// // //                       (data['senderEmail'] == widget.receiverEmail &&
// // //                           data['receiverEmail'] == currentUser.email);
// // //                 }).toList();

// // //                 return ListView.builder(
// // //                   padding: const EdgeInsets.all(10),
// // //                   itemCount: messages.length,
// // //                   itemBuilder: (context, index) {
// // //                     final data = messages[index].data() as Map<String, dynamic>;
// // //                     final isMe = data['senderEmail'] == currentUser.email;
// // //                     final messageId = messages[index].id;

// // //                     return Align(
// // //                       alignment: isMe
// // //                           ? Alignment.centerRight
// // //                           : Alignment.centerLeft,
// // //                       child: GestureDetector(
// // //                         onLongPress: isMe
// // //                             ? () {
// // //                                 // 🗑️ حذف الرسالة عند الضغط المطوّل
// // //                                 showDialog(
// // //                                   context: context,
// // //                                   builder: (context) => AlertDialog(
// // //                                     title: const Text("Delete Message"),
// // //                                     content: const Text(
// // //                                         "Are you sure you want to delete this message?"),
// // //                                     actions: [
// // //                                       TextButton(
// // //                                         onPressed: () =>
// // //                                             Navigator.pop(context),
// // //                                         child: const Text("Cancel"),
// // //                                       ),
// // //                                       TextButton(
// // //                                         onPressed: () {
// // //                                           context
// // //                                               .read<ChatCubit>()
// // //                                               .deleteMessage(messageId);
// // //                                           Navigator.pop(context);
// // //                                         },
// // //                                         child: const Text("Delete"),
// // //                                       ),
// // //                                     ],
// // //                                   ),
// // //                                 );
// // //                               }
// // //                             : null,
// // //                         child: Container(
// // //                           margin: const EdgeInsets.symmetric(vertical: 4),
// // //                           padding: const EdgeInsets.all(12),
// // //                           decoration: BoxDecoration(
// // //                             color: isMe
// // //                                 ? Colors.blueAccent
// // //                                 : Colors.grey.shade300,
// // //                             borderRadius: BorderRadius.circular(15),
// // //                           ),
// // //                           child: Text(
// // //                             data['message'],
// // //                             style: TextStyle(
// // //                               color: isMe ? Colors.white : Colors.black,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     );
// // //                   },
// // //                 );
// // //               },
// // //             ),
// // //           ),

// // //           // 🔹 إدخال رسالة جديدة
// // //           Container(
// // //             padding: const EdgeInsets.all(10),
// // //             color: Colors.grey.shade200,
// // //             child: Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: TextField(
// // //                     controller: messageController,
// // //                     decoration: const InputDecoration(
// // //                       hintText: "Type a message...",
// // //                       border: InputBorder.none,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 IconButton(
// // //                   icon: const Icon(Icons.send, color: Colors.blue),
// // //                   onPressed: () {
// // //                     if (messageController.text.trim().isNotEmpty) {
// // //                       context.read<ChatCubit>().sendMessage(
// // //                             message: messageController.text,
// // //                             reciverEmail: widget.receiverEmail,
// // //                             createdAt: DateTime.now(),
// // //                           );
// // //                       messageController.clear();
// // //                     }
// // //                   },
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // //جديد

// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // // import 'package:chat_app/features/Home/cubit/chat_cubit.dart';
// // // // import 'package:chat_app/features/Auth/data/user_model.dart';
// // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // import 'package:cloud_firestore/cloud_firestore.dart';

// // // // class ChatView extends StatefulWidget {
// // // //   final String receiverEmail;
// // // //   final UserModel receiverUser;

// // // //   static const String routeName = '/chatView';

// // // //   const ChatView({
// // // //     super.key,
// // // //     required this.receiverEmail,
// // // //     required this.receiverUser,
// // // //   });

// // // //   @override
// // // //   State<ChatView> createState() => _ChatViewState();
// // // // }

// // // // class _ChatViewState extends State<ChatView> {
// // // //   final TextEditingController messageController = TextEditingController();
// // // //   final currentUser = FirebaseAuth.instance.currentUser!;

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Row(
// // // //           children: [
// // // //             CircleAvatar(
// // // //               backgroundImage: NetworkImage(widget.receiverUser.image ?? ""),
// // // //             ),
// // // //             const SizedBox(width: 10),
// // // //             Text(widget.receiverUser.name ?? ""),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //       body: Column(
// // // //         children: [
// // // //           // 🔹 عرض الرسائل Realtime
// // // //           Expanded(
// // // //             child: StreamBuilder<QuerySnapshot>(
// // // //               stream: FirebaseFirestore.instance
// // // //                   .collection('Messages')
// // // //                   .orderBy('dateTime')
// // // //                   .snapshots(),
// // // //               builder: (context, snapshot) {
// // // //                 if (!snapshot.hasData) {
// // // //                   return const Center(child: CircularProgressIndicator());
// // // //                 }

// // // //                 final messages = snapshot.data!.docs.where((doc) {
// // // //                   final data = doc.data() as Map<String, dynamic>;
// // // //                   return (data['senderEmail'] == currentUser.email &&
// // // //                           data['receiverEmail'] == widget.receiverEmail) ||
// // // //                       (data['senderEmail'] == widget.receiverEmail &&
// // // //                           data['receiverEmail'] == currentUser.email);
// // // //                 }).toList();

// // // //                 return ListView.builder(
// // // //                   padding: const EdgeInsets.all(10),
// // // //                   itemCount: messages.length,
// // // //                   itemBuilder: (context, index) {
// // // //                     final data = messages[index].data() as Map<String, dynamic>;
// // // //                     final isMe = data['senderEmail'] == currentUser.email;
// // // //                     final messageId = messages[index].id;

// // // //                     return Align(
// // // //                       alignment: isMe
// // // //                           ? Alignment.centerRight
// // // //                           : Alignment.centerLeft,
// // // //                       child: GestureDetector(
// // // //                         onLongPress: isMe
// // // //                             ? () {
// // // //                                 // 🗑️ حذف الرسالة عند الضغط المطوّل
// // // //                                 showDialog(
// // // //                                   context: context,
// // // //                                   builder: (context) => AlertDialog(
// // // //                                     title: const Text("Delete Message"),
// // // //                                     content: const Text(
// // // //                                       "Are you sure you want to delete this message?",
// // // //                                     ),
// // // //                                     actions: [
// // // //                                       TextButton(
// // // //                                         onPressed: () => Navigator.pop(context),
// // // //                                         child: const Text("Cancel"),
// // // //                                       ),
// // // //                                       TextButton(
// // // //                                         onPressed: () {
// // // //                                           context
// // // //                                               .read<ChatCubit>()
// // // //                                               .deleteMessage(messageId);
// // // //                                           Navigator.pop(context);
// // // //                                         },
// // // //                                         child: const Text("Delete"),
// // // //                                       ),
// // // //                                     ],
// // // //                                   ),
// // // //                                 );
// // // //                               }
// // // //                             : null,
// // // //                         child: Container(
// // // //                           margin: const EdgeInsets.symmetric(vertical: 4),
// // // //                           padding: const EdgeInsets.all(12),
// // // //                           decoration: BoxDecoration(
// // // //                             color: isMe
// // // //                                 ? Colors.blueAccent
// // // //                                 : Colors.grey.shade300,
// // // //                             borderRadius: BorderRadius.circular(15),
// // // //                           ),
// // // //                           child: Text(
// // // //                             data['message'] ?? "",
// // // //                             style: TextStyle(
// // // //                               color: isMe ? Colors.white : Colors.black,
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     );
// // // //                   },
// // // //                 );
// // // //               },
// // // //             ),
// // // //           ),

// // // //           // 🔹 إدخال رسالة جديدة
// // // //           Container(
// // // //             padding: const EdgeInsets.all(10),
// // // //             color: Colors.grey.shade200,
// // // //             child: Row(
// // // //               children: [
// // // //                 Expanded(
// // // //                   child: TextField(
// // // //                     controller: messageController,
// // // //                     decoration: const InputDecoration(
// // // //                       hintText: "Type a message...",
// // // //                       border: InputBorder.none,
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 IconButton(
// // // //                   icon: const Icon(Icons.send, color: Colors.blue),
// // // //                   onPressed: () {
// // // //                     if (messageController.text.trim().isNotEmpty) {
// // // //                       context.read<ChatCubit>().sendMessage(
// // // //                         message: messageController.text,
// // // //                         receiverEmail: widget.receiverEmail, // ✅ تم تصحيح الاسم
// // // //                       );
// // // //                       messageController.clear();
// // // //                     }
// // // //                   },
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:chat_app/features/Home/cubit/chat_cubit.dart';
// // // import 'package:chat_app/features/Auth/data/user_model.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';

// // // class ChatView extends StatefulWidget {
// // //   final String receiverEmail;
// // //   final UserModel receiverUser;
// // //   static const String routeName = '/chatView';

// // //   const ChatView({
// // //     super.key,
// // //     required this.receiverEmail,
// // //     required this.receiverUser,
// // //   });

// // //   @override
// // //   State<ChatView> createState() => _ChatViewState();
// // // }

// // // class _ChatViewState extends State<ChatView> {
// // //   final TextEditingController messageController = TextEditingController();
// // //   final currentUser = FirebaseAuth.instance.currentUser!;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Row(
// // //           children: [
// // //             CircleAvatar(
// // //               backgroundImage: NetworkImage(widget.receiverUser.image ?? ""),
// // //             ),
// // //             const SizedBox(width: 10),
// // //             Text(widget.receiverUser.name ?? ""),
// // //           ],
// // //         ),
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           // 🔹 عرض الرسائل Realtime
// // //           Expanded(
// // //             child: StreamBuilder<QuerySnapshot>(
// // //               stream: FirebaseFirestore.instance
// // //                   .collection('Messages')
// // //                   .orderBy('dateTime')
// // //                   .snapshots(),
// // //               builder: (context, snapshot) {
// // //                 if (!snapshot.hasData) {
// // //                   return const Center(child: CircularProgressIndicator());
// // //                 }

// // //                 final messages = snapshot.data!.docs.where((doc) {
// // //                   final data = doc.data() as Map<String, dynamic>;
// // //                   return (data['senderEmail'] == currentUser.email &&
// // //                           data['receiverEmail'] == widget.receiverEmail) ||
// // //                       (data['senderEmail'] == widget.receiverEmail &&
// // //                           data['receiverEmail'] == currentUser.email);
// // //                 }).toList();

// // //                 return ListView.builder(
// // //                   padding: const EdgeInsets.all(10),
// // //                   itemCount: messages.length,
// // //                   itemBuilder: (context, index) {
// // //                     final data = messages[index].data() as Map<String, dynamic>;
// // //                     final isMe = data['senderEmail'] == currentUser.email;
// // //                     final messageId = messages[index].id;

// // //                     return Align(
// // //                       alignment: isMe
// // //                           ? Alignment.centerRight
// // //                           : Alignment.centerLeft,
// // //                       child: GestureDetector(
// // //                         onLongPress: isMe
// // //                             ? () {
// // //                                 // 🗑️ حذف الرسالة عند الضغط المطوّل
// // //                                 showDialog(
// // //                                   context: context,
// // //                                   builder: (context) => AlertDialog(
// // //                                     title: const Text("Delete Message"),
// // //                                     content: const Text(
// // //                                       "Are you sure you want to delete this message?",
// // //                                     ),
// // //                                     actions: [
// // //                                       TextButton(
// // //                                         onPressed: () => Navigator.pop(context),
// // //                                         child: const Text("Cancel"),
// // //                                       ),
// // //                                       TextButton(
// // //                                         onPressed: () {
// // //                                           context
// // //                                               .read<ChatCubit>()
// // //                                               .deleteMessage(messageId);
// // //                                           Navigator.pop(context);
// // //                                         },
// // //                                         child: const Text("Delete"),
// // //                                       ),
// // //                                     ],
// // //                                   ),
// // //                                 );
// // //                               }
// // //                             : null,
// // //                         child: Container(
// // //                           margin: const EdgeInsets.symmetric(vertical: 4),
// // //                           padding: const EdgeInsets.all(12),
// // //                           decoration: BoxDecoration(
// // //                             color: isMe
// // //                                 ? Colors.blueAccent
// // //                                 : Colors.grey.shade300,
// // //                             borderRadius: BorderRadius.circular(15),
// // //                           ),
// // //                           child: Text(
// // //                             data['message'],
// // //                             style: TextStyle(
// // //                               color: isMe ? Colors.white : Colors.black,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     );
// // //                   },
// // //                 );
// // //               },
// // //             ),
// // //           ),

// // //           // 🔹 إدخال رسالة جديدة
// // //           Container(
// // //             padding: const EdgeInsets.all(10),
// // //             color: Colors.grey.shade200,
// // //             child: Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: TextField(
// // //                     controller: messageController,
// // //                     decoration: const InputDecoration(
// // //                       hintText: "Type a message...",
// // //                       border: InputBorder.none,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 IconButton(
// // //                   icon: const Icon(Icons.send, color: Colors.blue),
// // //                   onPressed: () {
// // //                     if (messageController.text.trim().isNotEmpty) {
// // //                       context.read<ChatCubit>().sendMessage(
// // //                         message: messageController.text,
// // //                         receiverEmail: widget.receiverEmail,
// // //                         createdAt: DateTime.now(),
// // //                       );
// // //                       messageController.clear();
// // //                     }
// // //                   },
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// import 'dart:io';
// import 'package:chat_app/features/Auth/data/user_model.dart';
// import 'package:chat_app/features/Home/cubit/chat_cubit.dart';
// import 'package:chat_app/features/Home/data/message_model.dart';
// import 'package:chat_app/features/Home/widgets/reciver_message.dart';
// import 'package:chat_app/features/Home/widgets/sender_message.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';

// class ChatView extends StatefulWidget {
//   const ChatView({
//     super.key,
//     required String receiverEmail,
//     required UserModel receiverUser,
//   });
//   static String routeName = 'chat-view';

//   @override
//   State<ChatView> createState() => _ChatViewState();
// }

// class _ChatViewState extends State<ChatView> {
//   final TextEditingController messageController = TextEditingController();
//   final ImagePicker picker = ImagePicker();
//   bool isSending = false;

//   // ✅ إرسال صورة
//   Future<void> sendImage(String receiverEmail) async {
//     try {
//       final picked = await picker.pickImage(source: ImageSource.gallery);
//       if (picked != null) {
//         setState(() => isSending = true);

//         final ref = FirebaseStorage.instance.ref().child(
//           'chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
//         );

//         await ref.putFile(File(picked.path));
//         final url = await ref.getDownloadURL();

//         if (!mounted) return;
//         await BlocProvider.of<ChatCubit>(context).sendMessage(
//           message: url,
//           receiverEmail: receiverEmail,
//           createdAt: DateTime.now(),
//         );
//       }
//     } catch (e) {
//       debugPrint("Image send error: $e");
//     } finally {
//       if (mounted) setState(() => isSending = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final UserModel userModel =
//         ModalRoute.of(context)!.settings.arguments as UserModel;

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 2,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Row(
//           children: [
//             CircleAvatar(backgroundImage: NetworkImage(userModel.image!)),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   userModel.name,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Text(
//                   "Online",
//                   style: TextStyle(color: Colors.grey, fontSize: 12),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: const [
//           Icon(Icons.videocam, color: Colors.purple, size: 28),
//           SizedBox(width: 10),
//           Icon(Icons.call, color: Colors.purple, size: 24),
//           SizedBox(width: 10),
//         ],
//       ),
//       body: Column(
//         children: [
//           // ✅ عرض الرسائل
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: BlocProvider.of<ChatCubit>(
//                 context,
//               ).getMessagesForSpecificUser(userEmail: userModel.email),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 var messages = snapshot.data!.docs
//                     .map(
//                       (e) => MessageModel.fromJson(
//                         e.data() as Map<String, dynamic>,
//                       ),
//                     )
//                     .toList();

//                 // ترتيب الرسائل حسب الوقت
//                 messages.sort((a, b) => a.dateTime.compareTo(b.dateTime));

//                 return ListView.builder(
//                   padding: const EdgeInsets.all(10),
//                   itemCount: messages.length,
//                   itemBuilder: (context, i) {
//                     final msg = messages[i];
//                     bool isMe =
//                         msg.senderEmail ==
//                         FirebaseAuth.instance.currentUser!.email;

//                     final isImage = msg.message.startsWith('https://');

//                     return Column(
//                       crossAxisAlignment: isMe
//                           ? CrossAxisAlignment.end
//                           : CrossAxisAlignment.start,
//                       children: [
//                         isMe
//                             ? SenderMessageWidget(
//                                 message: msg.message,
//                                 isImage: isImage,
//                               )
//                             : ReciverMessageWidget(
//                                 message: msg.message,
//                                 isImage: isImage,
//                               ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                             left: 10,
//                             right: 10,
//                             top: 4,
//                           ),
//                           child: Text(
//                             "${msg.dateTime.hour.toString().padLeft(2, '0')}:${msg.dateTime.minute.toString().padLeft(2, '0')}",
//                             style: const TextStyle(
//                               fontSize: 10,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           // ✅ شريط الإدخال السفلي
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             color: Theme.of(context).cardColor,
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.image,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                   onPressed: isSending
//                       ? null
//                       : () async {
//                           await sendImage(userModel.email);
//                         },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.mic, color: Theme.of(context).primaryColor),
//                   onPressed: () {
//                     // تسجيل الصوت لاحقاً
//                   },
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: Theme.of(context).brightness == Brightness.dark
//                           ? Colors.white
//                           : Colors.black,
//                     ),
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       hintStyle: TextStyle(
//                         color: Theme.of(context).brightness == Brightness.dark
//                             ? Colors.white54
//                             : Colors.black54,
//                       ),
//                       filled: true,
//                       fillColor: Theme.of(context).brightness == Brightness.dark
//                           ? Colors.grey[900]
//                           : Colors.grey[200],
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 15,
//                         vertical: 10,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
//                   onPressed: () async {
//                     final text = messageController.text.trim();
//                     if (text.isEmpty) return;

//                     await BlocProvider.of<ChatCubit>(context).sendMessage(
//                       message: text,
//                       receiverEmail: userModel.email,
//                       createdAt: DateTime.now(),
//                     );

//                     if (!mounted) return;
//                     setState(() {
//                       messageController.clear();
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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

  // ✅ إرسال صورة
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
          // ✅ عرض الرسائل
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

          // ✅ شريط الإدخال السفلي
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Theme.of(context).cardColor,
            child: Row(
              children: [
                // 🎤 زر الصوت
                IconButton(
                  icon: Icon(Icons.mic, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    // TODO: هنا ممكن تضيف تسجيل الصوت لاحقًا
                    debugPrint("Voice recording clicked");
                  },
                ),
                // 🖼️ زر الصورة
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
                // ✏️ مربع النص
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
                // 📤 زر الإرسال
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
