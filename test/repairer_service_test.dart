import 'package:flutter_test/flutter_test.dart';
import 'package:sortit/models/repairer.dart';
import 'package:sortit/services/repairer_service.dart';

void main() {
  group('RepairerService Tests', () {
    test('getRepairersByCategory returns empty list on empty category',
        () async {
      final result = await RepairerService.getRepairersByCategory('');
      expect(result, isEmpty);
      expect(result, isA<List<Repairer>>());
    });

    test('getRepairersByCategory returns empty list on whitespace category',
        () async {
      final result = await RepairerService.getRepairersByCategory('   ');
      expect(result, isEmpty);
      expect(result, isA<List<Repairer>>());
    });

    test('getRepairerById returns null on empty id', () async {
      final result = await RepairerService.getRepairerById('');
      expect(result, isNull);
    });

    test('getRepairerById returns null on whitespace id', () async {
      final result = await RepairerService.getRepairerById('   ');
      expect(result, isNull);
    });

    test(
        'getRepairersByCategory handles Firestore errors cleanly and returns empty list',
        () async {
      // In test environment without mock/initialized Firebase, it catches cleanly
      final result =
          await RepairerService.getRepairersByCategory('Plumbing');
      expect(result, isEmpty);
      expect(result, isA<List<Repairer>>());
    });

    test(
        'getRepairerById handles Firestore errors cleanly and returns null',
        () async {
      // In test environment without mock/initialized Firebase, it catches cleanly
      final result = await RepairerService.getRepairerById('non_existent_id');
      expect(result, isNull);
    });

    test('instance helper methods work as expected', () async {
      final service = RepairerService();
      final listResult = await service.fetchRepairersByCategory('');
      expect(listResult, isEmpty);

      final singleResult = await service.fetchRepairerById('');
      expect(singleResult, isNull);
    });
  });
}
