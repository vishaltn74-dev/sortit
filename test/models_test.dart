import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sortit/models/booking.dart';
import 'package:sortit/models/category.dart';
import 'package:sortit/models/issue.dart';
import 'package:sortit/models/repairer.dart';
import 'package:sortit/services/firebase_service.dart';

void main() {
  group('Category Model Tests', () {
    test('Category serialization and deserialization', () {
      final category = Category(
        id: 'cat_1',
        name: 'Plumbing',
        icon: 'plumbing_icon',
      );

      final map = category.toMap();
      expect(map['id'], 'cat_1');
      expect(map['name'], 'Plumbing');
      expect(map['icon'], 'plumbing_icon');

      final fromMap = Category.fromMap(map);
      expect(fromMap.id, 'cat_1');
      expect(fromMap.name, 'Plumbing');
      expect(fromMap.icon, 'plumbing_icon');
      expect(fromMap, equals(category));
    });

    test('Category safe defaults with empty map', () {
      final category = Category.fromMap({}, id: 'fallback_id');
      expect(category.id, 'fallback_id');
      expect(category.name, '');
      expect(category.icon, '');
    });
  });

  group('Issue Model Tests', () {
    test('Issue serialization and deserialization', () {
      final issue = Issue(
        id: 'issue_1',
        categoryId: 'cat_1',
        name: 'Leaky Pipe',
      );

      final map = issue.toMap();
      expect(map['id'], 'issue_1');
      expect(map['categoryId'], 'cat_1');
      expect(map['name'], 'Leaky Pipe');

      final fromMap = Issue.fromMap(map);
      expect(fromMap.id, 'issue_1');
      expect(fromMap.categoryId, 'cat_1');
      expect(fromMap.name, 'Leaky Pipe');
      expect(fromMap, equals(issue));
    });

    test('Issue safe defaults with empty map', () {
      final issue = Issue.fromMap({});
      expect(issue.id, '');
      expect(issue.categoryId, '');
      expect(issue.name, '');
    });
  });

  group('Repairer Model Tests', () {
    test('Repairer serialization and deserialization', () {
      final repairer = Repairer(
        id: 'rep_1',
        name: 'John Doe',
        category: 'Plumbing',
        rating: 4.8,
        jobsCompleted: 120,
        inspectionFee: 50,
        latitude: 12.9716,
        longitude: 77.5946,
        phone: '+1234567890',
        services: ['Pipe repair', 'Tap fixing'],
      );

      final map = repairer.toMap();
      expect(map['id'], 'rep_1');
      expect(map['name'], 'John Doe');
      expect(map['rating'], 4.8);
      expect(map['jobsCompleted'], 120);
      expect(map['inspectionFee'], 50);
      expect(map['latitude'], 12.9716);
      expect(map['longitude'], 77.5946);
      expect(map['phone'], '+1234567890');
      expect(map['services'], ['Pipe repair', 'Tap fixing']);

      final fromMap = Repairer.fromMap(map);
      expect(fromMap, equals(repairer));
    });

    test('Repairer safe parsing handles num types and nulls', () {
      final map = {
        'id': 'rep_2',
        'name': 'Jane Doe',
        'category': 'Electrical',
        'rating': 5, // int instead of double
        'jobsCompleted': 10.0, // num/double instead of int
        'inspectionFee': 75.5,
        'latitude': 12,
        'longitude': 77,
        'phone': '111',
        'services': ['Wiring', 123],
      };

      final repairer = Repairer.fromMap(map);
      expect(repairer.rating, 5.0);
      expect(repairer.jobsCompleted, 10);
      expect(repairer.inspectionFee, 75);
      expect(repairer.latitude, 12.0);
      expect(repairer.longitude, 77.0);
      expect(repairer.services, ['Wiring', '123']);
    });
  });

  group('Booking Model Tests', () {
    test('Booking serialization and deserialization with Timestamp', () {
      final now = DateTime(2026, 9, 29, 12, 0, 0);
      final booking = Booking(
        id: 'book_1',
        repairerId: 'rep_1',
        repairerName: 'John Doe',
        category: 'Plumbing',
        issue: 'Leaky Pipe',
        date: '2026-09-30',
        time: '14:00',
        latitude: 12.9716,
        longitude: 77.5946,
        inspectionFee: 50,
        status: 'pending',
        createdAt: now,
      );

      final map = booking.toMap();
      expect(map['id'], 'book_1');
      expect(map['createdAt'], isA<Timestamp>());

      final fromMap = Booking.fromMap(map);
      expect(fromMap.id, 'book_1');
      expect(fromMap.repairerId, 'rep_1');
      expect(fromMap.repairerName, 'John Doe');
      expect(fromMap.category, 'Plumbing');
      expect(fromMap.issue, 'Leaky Pipe');
      expect(fromMap.date, '2026-09-30');
      expect(fromMap.time, '14:00');
      expect(fromMap.latitude, 12.9716);
      expect(fromMap.longitude, 77.5946);
      expect(fromMap.inspectionFee, 50);
      expect(fromMap.status, 'pending');
      expect(fromMap.createdAt, now);
      expect(fromMap, equals(booking));
    });

    test('Booking parses ISO string and null safely', () {
      final map = {
        'id': 'book_2',
        'repairerId': 'rep_2',
        'createdAt': '2026-09-29T10:00:00.000Z',
      };

      final booking = Booking.fromMap(map);
      expect(booking.id, 'book_2');
      expect(booking.repairerId, 'rep_2');
      expect(booking.repairerName, '');
      expect(booking.status, 'pending');
      expect(booking.createdAt, DateTime.parse('2026-09-29T10:00:00.000Z'));
    });
  });

  group('FirebaseService Tests', () {
    test('FirebaseService has firestore getter', () {
      expect(FirebaseService.instance, isNotNull);
    });
  });
}
