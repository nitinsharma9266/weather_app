import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/screens/home/home_screen.dart';

void main() {
  testWidgets('Weather HomeScreen loads successfully', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(),
      ),
    );

    expect(find.text('Weather App'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsWidgets);
  });
}