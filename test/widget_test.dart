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
  });
}
