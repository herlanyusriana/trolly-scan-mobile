import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:geum_cheon_trolly/app.dart';

void main() {
  testWidgets('Login screen renders correctly', (tester) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(InOutTrolleyApp(preferences: preferences));

    expect(find.text('Login to Geum Cheon Trolly'), findsOneWidget);
    expect(find.text('Login Securely'), findsOneWidget);
    expect(find.text('Lupa Kata Sandi?'), findsOneWidget);
  });

  testWidgets('Navigates to ForgotPasswordPage and renders correctly', (tester) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(InOutTrolleyApp(preferences: preferences));

    final forgotPasswordButton = find.text('Lupa Kata Sandi?');
    expect(forgotPasswordButton, findsOneWidget);

    await tester.tap(forgotPasswordButton);
    await tester.pumpAndSettle();

    expect(find.text('Atur Ulang Kata Sandi'), findsOneWidget);
    expect(find.text('Simpan Kata Sandi Baru'), findsOneWidget);
  });
}
