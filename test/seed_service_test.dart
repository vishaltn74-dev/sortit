import 'package:flutter_test/flutter_test.dart';
import 'package:sortit/services/seed_service.dart';

void main() {
  group('SeedService Demo Data Structure & Integrity Tests', () {
    test('contains exactly 6 required categories with stable IDs', () {
      final categories = SeedService.demoCategories;
      expect(categories.length, 6);

      final expectedCategories = {
        'ac': 'AC',
        'phone': 'Phone',
        'washing_machine': 'Washing Machine',
        'laptop': 'Laptop',
        'bicycle': 'Bicycle',
        'electrical': 'Electrical',
      };

      for (final cat in categories) {
        expect(expectedCategories.containsKey(cat.id), isTrue,
            reason: 'Category ID "${cat.id}" should be one of the expected stable IDs');
        expect(cat.name, equals(expectedCategories[cat.id]));
        expect(cat.icon, isNotEmpty);
      }
    });

    test('contains exactly 24 issues with 4 issues per category', () {
      final issues = SeedService.demoIssues;
      expect(issues.length, 24);

      final expectedCategoryIds = {
        'ac',
        'phone',
        'washing_machine',
        'laptop',
        'bicycle',
        'electrical',
      };

      final issueIds = <String>{};

      for (final catId in expectedCategoryIds) {
        final categoryIssues =
            issues.where((issue) => issue.categoryId == catId).toList();
        expect(categoryIssues.length, 4,
            reason: 'Category "$catId" must have exactly 4 issues');

        for (final issue in categoryIssues) {
          expect(issue.id, isNotEmpty);
          expect(issue.name, isNotEmpty);
          expect(issueIds.contains(issue.id), isFalse,
              reason: 'Issue ID "${issue.id}" must be unique');
          issueIds.add(issue.id);
        }
      }
    });

    test(
        'contains exactly 24 repairers distributed evenly (4 per category) with Bengaluru locations',
        () {
      final repairers = SeedService.demoRepairers;
      expect(repairers.length, 24);

      final expectedCategories = [
        'AC',
        'Phone',
        'Washing Machine',
        'Laptop',
        'Bicycle',
        'Electrical',
      ];

      final repairerIds = <String>{};

      for (final categoryName in expectedCategories) {
        final categoryRepairers =
            repairers.where((r) => r.category == categoryName).toList();
        expect(categoryRepairers.length, 4,
            reason: 'Category "$categoryName" must have exactly 4 repairers');

        for (final rep in categoryRepairers) {
          expect(rep.id, isNotEmpty);
          expect(rep.name, isNotEmpty);
          expect(rep.category, equals(categoryName));
          expect(rep.rating, inInclusiveRange(4.2, 5.0));
          expect(rep.jobsCompleted, greaterThan(0));
          expect(rep.inspectionFee, greaterThan(0));
          // Bengaluru coordinates bounding box (~12.8 to ~13.2 lat, ~77.4 to ~77.8 lng)
          expect(rep.latitude, inInclusiveRange(12.8, 13.2));
          expect(rep.longitude, inInclusiveRange(77.4, 77.8));
          expect(rep.phone, isNotEmpty);
          expect(rep.services.length, greaterThanOrEqualTo(2));
          expect(repairerIds.contains(rep.id), isFalse,
              reason: 'Repairer ID "${rep.id}" must be unique and deterministic');
          repairerIds.add(rep.id);
        }
      }
    });

    test('all models map to valid Firestore data structures', () {
      for (final cat in SeedService.demoCategories) {
        final map = cat.toMap();
        expect(map['id'], cat.id);
        expect(map['name'], cat.name);
        expect(map['icon'], cat.icon);
      }

      for (final issue in SeedService.demoIssues) {
        final map = issue.toMap();
        expect(map['id'], issue.id);
        expect(map['categoryId'], issue.categoryId);
        expect(map['name'], issue.name);
      }

      for (final rep in SeedService.demoRepairers) {
        final map = rep.toMap();
        expect(map['id'], rep.id);
        expect(map['name'], rep.name);
        expect(map['category'], rep.category);
        expect(map['rating'], rep.rating);
        expect(map['jobsCompleted'], rep.jobsCompleted);
        expect(map['inspectionFee'], rep.inspectionFee);
        expect(map['latitude'], rep.latitude);
        expect(map['longitude'], rep.longitude);
        expect(map['phone'], rep.phone);
        expect(map['services'], rep.services);
      }
    });

    test('seedAll handles uninitialized Firestore cleanly without crashing',
        () async {
      final result = await SeedService.seedAll();
      expect(result.categoriesCount, 0);
      expect(result.issuesCount, 0);
      expect(result.repairersCount, 0);
      expect(result.isSuccess, isFalse);
    });
  });
}
