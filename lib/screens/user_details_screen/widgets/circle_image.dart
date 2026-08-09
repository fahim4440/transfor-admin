import 'dart:convert';

import 'package:flutter/material.dart';

Widget circleImage({required String imageString, double radius = 60}) {
  return Builder(
    builder: (context) {
      return GestureDetector(
        onTap: () => _showFullImage(context, imageString),
        child: CircleAvatar(
          radius: radius,
          backgroundImage: MemoryImage(base64Decode(imageString)),
        ),
      );
    },
  );
}

void _showFullImage(BuildContext context, String imageString) {
  showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          InteractiveViewer(
            maxScale: 5,
            child: Image.memory(base64Decode(imageString)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ),
        ],
      ),
    ),
  );
}
