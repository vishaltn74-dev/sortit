import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sortit/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Suppress image asset loading errors in headless test environment
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.library == 'image resource service') {
        return;
      }
      FlutterError.presentError(details);
    };

    await tester.pumpWidget(const SortItApp());
    expect(find.text('SortIt'), findsWidgets);
  });
}
