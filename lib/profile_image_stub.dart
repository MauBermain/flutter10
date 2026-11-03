import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

Future<String> persistProfilePhoto(XFile image) =>
    throw UnsupportedError('Pemilihan foto tidak didukung pada platform ini.');

Future<void> deleteProfilePhoto(String? reference) async {}

ImageProvider<Object> profileImageProvider(String reference) =>
    throw UnsupportedError('Foto profil tidak didukung pada platform ini.');
