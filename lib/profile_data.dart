import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Model sederhana untuk satu baris informasi pada halaman detail.
class DetailItem {
  final IconData icon;
  final String title;
  final String value;

  const DetailItem({
    required this.icon,
    required this.title,
    required this.value,
  });
}

class ProfileData {
  const ProfileData({
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.universitas,
    required this.hobi,
    required this.infoTambahan,
    required this.fokusBelajar,
    required this.bahasaPemrograman,
    required this.target,
    required this.email,
    this.fotoPath,
  });

  static const String fotoAsset = 'assets/Joke owi.jpg';
  static const String _storageKey = 'profile_data_v1';

  static const ProfileData defaults = ProfileData(
    nama: 'Ahmad Badrul Furqon',
    nim: '2495114004',
    prodi: 'Teknik Informatika',
    universitas: 'Universitas Hasyim Asy\'ari (UNHASY)',
    hobi: 'Ngoding, ngopi, dan eksplor teknologi baru.',
    infoTambahan: 'Sedang belajar pengembangan aplikasi mobile menggunakan Flutter dan Dart.',
    fokusBelajar: 'Pemrograman Mobile dengan Flutter',
    bahasaPemrograman: 'bahasa jawa',
    target: 'Menjadi Presiden',
    email: 'furqonbadrul@mhs.unhasy.ac.id',
    fotoPath: null,
  );

  static final ValueNotifier<ProfileData> current = ValueNotifier<ProfileData>(
    defaults,
  );

  final String nama;
  final String nim;
  final String prodi;
  final String universitas;
  final String hobi;
  final String infoTambahan;
  final String fokusBelajar;
  final String bahasaPemrograman;
  final String target;
  final String email;
  final String? fotoPath;

  String get infoTambahanJudul => 'Informasi Tambahan';

  List<DetailItem> get detail => [
    DetailItem(
      icon: Icons.school_rounded,
      title: 'Fokus Belajar',
      value: fokusBelajar,
    ),
    DetailItem(
      icon: Icons.code_rounded,
      title: 'Bahasa Pemrograman',
      value: bahasaPemrograman,
    ),
    DetailItem(icon: Icons.flag_rounded, title: 'Target', value: target),
    DetailItem(icon: Icons.mail_rounded, title: 'Email', value: email),
  ];

  static Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final storedData = preferences.getString(_storageKey);
    if (storedData != null) {
      current.value = ProfileData.fromJson(storedData);
    }
  }

  Future<void> save() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _storageKey,
      jsonEncode({
        'nama': nama,
        'nim': nim,
        'prodi': prodi,
        'universitas': universitas,
        'hobi': hobi,
        'infoTambahan': infoTambahan,
        'fokusBelajar': fokusBelajar,
        'bahasaPemrograman': bahasaPemrograman,
        'target': target,
        'email': email,
        'fotoPath': fotoPath,
      }),
    );
    if (!saved) {
      throw StateError('Penyimpanan profil gagal.');
    }
    current.value = this;
  }

  factory ProfileData.fromJson(String encoded) {
    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Format data profil tidak valid.');
    }

    String read(String key) {
      final value = decoded[key];
      if (value is! String) {
        throw FormatException('Data profil "$key" tidak valid.');
      }
      return value;
    }

    final storedPhotoPath = decoded['fotoPath'];
    if (storedPhotoPath != null && storedPhotoPath is! String) {
      throw const FormatException('Data foto profil tidak valid.');
    }

    return ProfileData(
      nama: read('nama'),
      nim: read('nim'),
      prodi: read('prodi'),
      universitas: read('universitas'),
      hobi: read('hobi'),
      infoTambahan: read('infoTambahan'),
      fokusBelajar: read('fokusBelajar'),
      bahasaPemrograman: read('bahasaPemrograman'),
      target: read('target'),
      email: read('email'),
      fotoPath: storedPhotoPath as String?,
    );
  }
}
