import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ludogams/screens/menu_screen.dart';

void main() {
  testWidgets('Menu shows title and start button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MenuScreen()));

    expect(find.text('LUDO'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
    for (final count in ['2', '3', '4']) {
      expect(find.text(count), findsOneWidget);
    }
  });
}
