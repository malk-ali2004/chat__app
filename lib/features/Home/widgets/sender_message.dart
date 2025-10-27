// import 'package:flutter/material.dart';

// class SenderMessageWidget extends StatelessWidget {
//   const SenderMessageWidget({
//     super.key,
//     required this.message,
//     this.isImage = false,
//   });
//   final String message;
//   final bool isImage;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(top: 8, bottom: 8, right: 12),
//       padding: const EdgeInsets.all(10),
//       constraints: const BoxConstraints(maxWidth: 260),
//       decoration: BoxDecoration(
//         color: Colors.purple,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: isImage
//           ? ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.network(message),
//             )
//           : Text(
//               message,
//               style: const TextStyle(color: Colors.white, fontSize: 14),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class SenderMessageWidget extends StatelessWidget {
  const SenderMessageWidget({
    super.key,
    required this.message,
    this.isImage = false,
  });
  final String message;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8, right: 12),
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(maxWidth: 260),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(16),
      ),
      child: isImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(message),
            )
          : Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
    );
  }
}
