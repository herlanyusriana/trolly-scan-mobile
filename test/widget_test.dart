import 'package:flutter_test/flutter_test.dart';

import 'package:geum_cheon_trolly/app.dart';

void main() {
  testWidgets('Login screen renders correctly', (tester) async {
    await tester.pumpWidget(const InOutTrolleyApp());

    expect(find.text('Login to Geum Cheon Trolly'), findsOneWidget);
    expect(find.text('Login Securely'), findsOneWidget);
  });
}
