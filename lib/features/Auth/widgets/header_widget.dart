import 'package:chat_app/core/utils/style/screen_size.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Row(),
        Padding(
          padding: EdgeInsets.only(
            top: ScreenSize.height / 15,
            left: ScreenSize.width / 30,
            right: ScreenSize.width / 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: ScreenSize.width,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SizedBox(
                width: ScreenSize.width / 1.3,
                child: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Image.asset(
            "assets/images/avatar.png",
            height: ScreenSize.height / 4,
            width: ScreenSize.width / 3,
          ),
        ),
      ],
    );
  }
}
