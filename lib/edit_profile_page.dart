import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'profile_data.dart';
import 'profile_image.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _nimController;
  late final TextEditingController _prodiController;
  late final TextEditingController _universitasController;
  late final TextEditingController _hobiController;
  late final TextEditingController _infoTambahanController;
  late final TextEditingController _fokusBelajarController;
  late final TextEditingController _bahasaPemrogramanController;
  late final TextEditingController _targetController;
  late final TextEditingController _emailController;
  String? _fotoPath;
  bool _isPickingPhoto = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = ProfileData.current.value;
    _fotoPath = profile.fotoPath;
    _namaController = TextEditingController(text: profile.nama);
    _nimController = TextEditingController(text: profile.nim);
    _prodiController = TextEditingController(text: profile.prodi);
    _universitasController = TextEditingController(text: profile.universitas);
    _hobiController = TextEditingController(text: profile.hobi);
    _infoTambahanController = TextEditingController(text: profile.infoTambahan);
    _fokusBelajarController = TextEditingController(text: profile.fokusBelajar);
    _bahasaPemrogramanController = TextEditingController(
      text: profile.bahasaPemrograman,
    );
    _targetController = TextEditingController(text: profile.target);
    _emailController = TextEditingController(text: profile.email);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _prodiController.dispose();
    _universitasController.dispose();
    _hobiController.dispose();
    _infoTambahanController.dispose();
    _fokusBelajarController.dispose();
    _bahasaPemrogramanController.dispose();
    _targetController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final previousPhoto = ProfileData.current.value.fotoPath;
      final updatedProfile = ProfileData(
        nama: _namaController.text.trim(),
        nim: _nimController.text.trim(),
        prodi: _prodiController.text.trim(),
        universitas: _universitasController.text.trim(),
        hobi: _hobiController.text.trim(),
        infoTambahan: _infoTambahanController.text.trim(),
        fokusBelajar: _fokusBelajarController.text.trim(),
        bahasaPemrograman: _bahasaPemrogramanController.text.trim(),
        target: _targetController.text.trim(),
        email: _emailController.text.trim(),
        fotoPath: _fotoPath,
      );
      await updatedProfile.save();
      if (previousPhoto != _fotoPath) {
        await deleteProfilePhoto(previousPhoto);
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } on PlatformException catch (error) {
      _showSaveError(error.message ?? error.code);
    } on StateError catch (error) {
      _showSaveError(error.message);
    } on UnsupportedError catch (error) {
      _showSaveError(error.message ?? 'Operasi tidak didukung.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _pickPhoto() async {
    setState(() => _isPickingPhoto = true);
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );
      if (image == null || !mounted) return;

      final nextPath = await persistProfilePhoto(image);
      if (!mounted) {
        await deleteProfilePhoto(nextPath);
        return;
      }
      setState(() => _fotoPath = nextPath);
    } on PlatformException catch (error) {
      _showSaveError(error.message ?? error.code);
    } on UnsupportedError catch (error) {
      _showSaveError(error.message ?? 'Operasi tidak didukung.');
    } finally {
      if (mounted) setState(() => _isPickingPhoto = false);
    }
  }

  void _removePhoto() {
    setState(() => _fotoPath = null);
  }

  void _showSaveError(Object error) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan profil: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    key: ValueKey(_fotoPath),
                    radius: 56,
                    backgroundImage: profileImageProvider(_fotoPath),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _isPickingPhoto ? null : _pickPhoto,
                    icon: _isPickingPhoto
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.photo_library_outlined),
                    label: Text(
                      _isPickingPhoto ? 'Memilih foto...' : 'Ganti Foto',
                    ),
                  ),
                  if (_fotoPath != null)
                    TextButton(
                      onPressed: _isSaving ? null : _removePhoto,
                      child: const Text('Gunakan foto awal'),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            _ProfileField(label: 'Nama', controller: _namaController),
            _ProfileField(label: 'NIM', controller: _nimController),
            _ProfileField(label: 'Program Studi', controller: _prodiController),
            _ProfileField(
              label: 'Universitas',
              controller: _universitasController,
            ),
            _ProfileField(
              label: 'Hobi / Deskripsi Singkat',
              controller: _hobiController,
              maxLines: 3,
            ),
            _ProfileField(
              label: 'Informasi Tambahan',
              controller: _infoTambahanController,
              maxLines: 3,
            ),
            _ProfileField(
              label: 'Fokus Belajar',
              controller: _fokusBelajarController,
            ),
            _ProfileField(
              label: 'Bahasa Pemrograman',
              controller: _bahasaPemrogramanController,
            ),
            _ProfileField(label: 'Target', controller: _targetController),
            _ProfileField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _saveProfile,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_rounded),
                label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
        validator: (value) =>
            value == null || value.trim().isEmpty ? '$label wajib diisi' : null,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: maxLines > 1,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
