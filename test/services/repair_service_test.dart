import 'package:flutter_test/flutter_test.dart';
import 'package:sortit/services/repair_service.dart';

void main() {
  group('RepairService Decision Logic', () {
    const service = RepairService();

    test('Washing Machine + Not draining returns exact prototype requirements', () {
      final assessment = service.getAssessment(
        category: 'Washing Machine',
        issue: 'Not draining',
      );

      expect(assessment.category, 'Washing Machine');
      expect(assessment.issue, 'Not draining');
      expect(assessment.possibleCauses, [
        'Clogged filter',
        'Blocked drain hose',
        'Drain pump issue',
      ]);
      expect(assessment.estimatedRepairCost, '₹500–₹1,500');
      expect(assessment.replacementEstimate, '₹12,000+');
      expect(assessment.recommendation, 'Repairing may be worth considering.');
      expect(assessment.isRepairEconomical, isTrue);
    });

    test('supports all required Washing Machine issues', () {
      final requiredIssues = [
        'Not draining',
        'Not starting',
        'Water leaking',
        'Not spinning',
        'Making strange noise',
        'Other',
      ];

      for (final issue in requiredIssues) {
        final assessment = service.getAssessment(
          category: 'Washing Machine',
          issue: issue,
        );

        expect(assessment.category, 'Washing Machine');
        expect(assessment.possibleCauses, isNotEmpty);
        expect(assessment.estimatedRepairCost, isNotEmpty);
        expect(assessment.replacementEstimate, isNotEmpty);
        expect(assessment.recommendation, isNotEmpty);
      }
    });

    test('matches issues case-insensitively and handles whitespace', () {
      final assessment = service.getAssessment(
        category: '  washing MACHINE ',
        issue: ' NOT DRAINING  ',
      );

      expect(assessment.issue, 'Not draining');
      expect(assessment.estimatedRepairCost, '₹500–₹1,500');
    });

    test('falls back gracefully to category default for unlisted issue', () {
      final assessment = service.getAssessment(
        category: 'Washing Machine',
        issue: 'Smelling like burnt plastic',
      );

      expect(assessment.category, 'Washing Machine');
      expect(assessment.issue, 'Smelling like burnt plastic');
      expect(assessment.recommendation, contains('technician'));
    });

    test('falls back safely for unknown appliance category', () {
      final assessment = service.getAssessment(
        category: 'Electric Toaster',
        issue: 'Lever stuck',
      );

      expect(assessment.category, 'Electric Toaster');
      expect(assessment.issue, 'Lever stuck');
      expect(assessment.possibleCauses, isNotEmpty);
      expect(assessment.estimatedRepairCost, isNotEmpty);
      expect(assessment.replacementEstimate, isNotEmpty);
    });

    test('supports dynamic rule registration for extensibility', () {
      const customRule = RepairAssessment(
        category: 'Smart TV',
        issue: 'No display but audio works',
        possibleCauses: ['Backlight LED strip failure', 'T-Con board fault'],
        estimatedRepairCost: '₹1,500–₹3,000',
        replacementEstimate: '₹20,000+',
        recommendation: 'Repairing the backlight is much cheaper than buying a new panel.',
        minRepairCost: 1500,
        maxRepairCost: 3000,
        replacementCost: 20000,
      );

      RepairService.registerRule(customRule);

      final assessment = service.getAssessment(
        category: 'Smart TV',
        issue: 'No display but audio works',
      );

      expect(assessment.category, 'Smart TV');
      expect(assessment.possibleCauses, contains('Backlight LED strip failure'));
      expect(assessment.isRepairEconomical, isTrue);

      RepairService.clearCustomRules();
    });
  });
}
