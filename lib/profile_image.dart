import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'profile_data.dart';
import 'profile_image_stub.dart'
    if (dart.library.io) 'profile_image_io.dart'
    if (dart.library.js_interop) 'profile_image_web.dart'
    as implementation;

Future<String> persistProfilePhoto(XFile image) =>
    implementation.persistProfilePhoto(image);

Future<void> deleteProfilePhoto(String? reference) =>
    implementation.deleteProfilePhoto(reference);

ImageProvider<Object> profileImageProvider(String? reference) {
  if (reference == null) return const AssetImage(ProfileData.fotoAsset);
  return implementation.profileImageProvider(reference);
}
