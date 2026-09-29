import 'package:flutter_test/flutter_test.dart';
import 'package:sortit/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SortItApp());
    expect(find.text('SortIt'), findsWidgets);
  });
}
