import 'package:chat_app/core/utils/style/screen_size.dart';
import 'package:chat_app/data/chat_view_model.dart';
import 'package:flutter/material.dart';

class ChatCardWidget extends StatelessWidget {
  const ChatCardWidget({
    super.key,
    required this.chatViewModel,
    required this.onTap,
  });
  final ChatViewModel chatViewModel;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: ScreenSize.height / 40,
        bottom: ScreenSize.height / 50,
      ),
      width: ScreenSize.width,
      height: ScreenSize.height / 11,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 3),
        borderRadius: BorderRadius.circular(ScreenSize.width / 40),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Stack(
          children: [
            CircleAvatar(
              radius: ScreenSize.width / 15,
              backgroundImage: NetworkImage(chatViewModel.avatarUrl),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: ScreenSize.width / 40,
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
        title: Text(
          chatViewModel.name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          chatViewModel.message,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Text(
          chatViewModel.time,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
