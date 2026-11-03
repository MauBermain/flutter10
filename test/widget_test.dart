import 'package:biodata_ahmad_badrul_furqon/profile_data.dart';
import 'package:biodata_ahmad_badrul_furqon/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ProfileData.current.value = ProfileData.defaults;
  });

  test('selected profile photo is persisted', () async {
    final profile = ProfileData(
      nama: ProfileData.defaults.nama,
      nim: ProfileData.defaults.nim,
      prodi: ProfileData.defaults.prodi,
      universitas: ProfileData.defaults.universitas,
      hobi: ProfileData.defaults.hobi,
      infoTambahan: ProfileData.defaults.infoTambahan,
      fokusBelajar: ProfileData.defaults.fokusBelajar,
      bahasaPemrograman: ProfileData.defaults.bahasaPemrograman,
      target: ProfileData.defaults.target,
      email: ProfileData.defaults.email,
      fotoPath: 'selected-photo.jpg',
    );

    await profile.save();
    await ProfileData.load();

    expect(ProfileData.current.value.fotoPath, 'selected-photo.jpg');
  });

  testWidgets('menu opens detail and profile edit saves changes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));

    await tester.tap(find.byIcon(Icons.more_vert_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Detail'), findsWidgets);
    expect(find.text('Edit profil'), findsOneWidget);

    await tester.tap(find.text('Detail').last);
    await tester.pumpAndSettle();
    expect(find.text('Detail Profil'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit profil'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Profil'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'Ahmad Badrul Furqon Baru',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Simpan Perubahan'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Profil'), findsNothing);
    expect(find.text('Ahmad Badrul Furqon Baru'), findsOneWidget);

    await ProfileData.load();
    expect(ProfileData.current.value.nama, 'Ahmad Badrul Furqon Baru');
  });
}
