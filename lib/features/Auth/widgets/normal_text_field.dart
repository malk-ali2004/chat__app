import 'package:chat_app/core/utils/style/screen_size.dart';
import 'package:flutter/material.dart';

class NormalTextField extends StatelessWidget {
  const NormalTextField({
    super.key,
    required this.title,
    required this.controller,
    required this.formKey,
  });
  final String title;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: ScreenSize.width / 20),
          child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        ),
        SizedBox(height: ScreenSize.height / 100),
        Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenSize.width / 15),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $title';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
