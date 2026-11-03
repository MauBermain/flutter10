import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'detail_page.dart';
import 'profile_data.dart';
import 'edit_profile_page.dart';
import 'profile_image.dart';

/// Tag Hero agar foto profil "terbang" mulus ke halaman detail.
const String kAvatarHeroTag = 'avatar-profil';

enum _ProfileMenuAction { detail, edit }

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProfileData>(
      valueListenable: ProfileData.current,
      builder: (context, profile, _) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => _showSnack(context, 'Menu belum tersedia'),
          ),
          title: const Text(
            'Profil Mahasiswa',
            style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3),
          ),
          actions: [
            PopupMenuButton<_ProfileMenuAction>(
              icon: const Icon(Icons.more_vert_rounded),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onSelected: (action) {
                final page = switch (action) {
                  _ProfileMenuAction.detail => const DetailPage(),
                  _ProfileMenuAction.edit => const EditProfilePage(),
                };
                Navigator.of(context)
                    .push(MaterialPageRoute<void>(builder: (_) => page));
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _ProfileMenuAction.detail,
                  child: Text('Detail'),
                ),
                PopupMenuItem(
                  value: _ProfileMenuAction.edit,
                  child: Text('Edit profil'),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _ProfileHeader(profile: profile),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  children: [
                    _FadeSlide(order: 0, child: _InfoCard(profile: profile)),
                    const SizedBox(height: 16),
                    _FadeSlide(
                      order: 1,
                      child: _ExtraInfoCard(profile: profile),
                    ),
                    const SizedBox(height: 24),
                    _FadeSlide(
                      order: 2,
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DetailPage(),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text(
                            'Detail',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bagian atas: latar gradien, foto profil, nama, dan chip program studi.
class _ProfileHeader extends StatelessWidget {
  final ProfileData profile;

  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top + kToolbarHeight;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.only(top: topInset + 8, bottom: 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFB923C), Color(0xFFF97316), Color(0xFFC2410C)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Lingkaran dekoratif transparan
          Positioned(top: -20, right: -40, child: _bubble(140, 28)),
          Positioned(bottom: 10, left: -50, child: _bubble(120, 22)),
          Column(
            children: [
              Hero(
                tag: kAvatarHeroTag,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(235),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(60),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 62,
                    backgroundImage: profileImageProvider(profile.fotoPath),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                profile.nama,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withAlpha(70)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phone_android_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Mobile Developer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _bubble(double size, int alpha) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(alpha),
      ),
    );
  }
}

/// Kartu identitas: NIM, Program Studi, Universitas, Hobi.
class _InfoCard extends StatelessWidget {
  final ProfileData profile;

  const _InfoCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(icon: Icons.badge_rounded, label: 'NIM', value: profile.nim),
          _divider(scheme),
          _InfoRow(
            icon: Icons.menu_book_rounded,
            label: 'Program Studi',
            value: profile.prodi,
          ),
          _divider(scheme),
          _InfoRow(
            icon: Icons.account_balance_rounded,
            label: 'Universitas',
            value: profile.universitas,
          ),
          _divider(scheme),
          _InfoRow(
            icon: Icons.favorite_rounded,
            label: 'Hobi / Deskripsi Singkat',
            value: profile.hobi,
          ),
        ],
      ),
    );
  }

  static Widget _divider(ColorScheme scheme) =>
      Divider(height: 1, color: scheme.outlineVariant.withAlpha(120));
}

/// Satu baris informasi: ikon di kiri, label + nilai di kanan (Row).
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu "Informasi Tambahan" dengan kotak ikon di kiri dan teks di kanan.
class _ExtraInfoCard extends StatelessWidget {
  final ProfileData profile;

  const _ExtraInfoCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: scheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: scheme.outlineVariant.withAlpha(120)),
      ),
      child: InkWell(
        onTap: () =>
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const DetailPage())),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFB923C), Color(0xFFEA580C)],
                  ),
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.infoTambahanJudul,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      profile.infoTambahan,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animasi masuk: fade + geser sedikit dari bawah. [order] menentukan
/// urutan kemunculan (semakin besar, semakin lambat).
class _FadeSlide extends StatelessWidget {
  final int order;
  final Widget child;

  const _FadeSlide({required this.order, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + order * 200),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - t)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
