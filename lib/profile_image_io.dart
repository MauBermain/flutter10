import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String> persistProfilePhoto(XFile image) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final destination = File(
      '${directory.path}${Platform.pathSeparator}'
      'profile_photo_${DateTime.now().microsecondsSinceEpoch}.jpg',
    );
    await File(image.path).copy(destination.path);
    return destination.path;
  } on FileSystemException catch (error) {
    throw StateError('Tidak dapat menyimpan foto: ${error.message}');
  }
}

Future<void> deleteProfilePhoto(String? reference) async {
  if (reference == null) return;

  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(reference);
    final isManagedPhoto =
        file.parent.path == directory.path &&
        file.uri.pathSegments.last.startsWith('profile_photo_');
    if (isManagedPhoto && await file.exists()) {
      await file.delete();
    }
  } on FileSystemException catch (error) {
    throw StateError('Tidak dapat menghapus foto lama: ${error.message}');
  }
}

ImageProvider<Object> profileImageProvider(String reference) =>
    FileImage(File(reference));
