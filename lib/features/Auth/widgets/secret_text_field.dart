import 'package:chat_app/core/utils/style/screen_size.dart';
import 'package:flutter/material.dart';

class SecretTextField extends StatefulWidget {
  const SecretTextField({
    super.key,
    required this.title,
    required this.controller,
    required this.formKey,
  });
  final String title;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  @override
  State<SecretTextField> createState() => _SecretTextFieldState();
}

class _SecretTextFieldState extends State<SecretTextField> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: ScreenSize.width / 20),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(height: ScreenSize.height / 100),
        Form(
          key: widget.formKey,
          child: TextFormField(
            obscureText: isObscure,
            controller: widget.controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenSize.width / 15),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter ${widget.title}';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
