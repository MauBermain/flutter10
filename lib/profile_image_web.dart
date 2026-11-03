import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

Future<String> persistProfilePhoto(XFile image) async {
  final bytes = await image.readAsBytes();
  final mimeType = image.mimeType ?? 'image/jpeg';
  return 'data:$mimeType;base64,${base64Encode(bytes)}';
}

Future<void> deleteProfilePhoto(String? reference) async {}

ImageProvider<Object> profileImageProvider(String reference) {
  final separator = reference.indexOf(',');
  if (separator < 0) {
    throw const FormatException('Format foto profil tidak valid.');
  }
  return MemoryImage(base64Decode(reference.substring(separator + 1)));
}
