import 'package:flutter/material.dart';

class ReciverMessageWidget extends StatelessWidget {
  const ReciverMessageWidget({
    super.key,
    required this.message,
    this.isImage = false,
  });
  final String message;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 12),
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(maxWidth: 260),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple),
      ),
      child: isImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(message),
            )
          : Text(
              message,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
    );
  }
}
