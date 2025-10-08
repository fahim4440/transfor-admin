import 'dart:convert';

import 'package:flutter/material.dart';

CircleAvatar circleImage({required String imageString}) {
  return CircleAvatar(
    radius: 60,
    backgroundImage: MemoryImage(base64Decode(imageString)),
  );
}
