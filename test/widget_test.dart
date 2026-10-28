import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('App loads welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SaborCaribeApp());

    expect(find.text('Explorar sabores'), findsOneWidget);
  });
}