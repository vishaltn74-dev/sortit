/// Assessment outcome of a repair versus replacement evaluation for an appliance issue.
class RepairAssessment {
  /// The appliance category (e.g., "Washing Machine").
  final String category;

  /// The reported problem/issue (e.g., "Not draining").
  final String issue;

  /// List of likely causes for the reported problem.
  final List<String> possibleCauses;

  /// Human-readable estimated repair cost range (e.g., "₹500–₹1,500").
  final String estimatedRepairCost;

  /// Human-readable estimated replacement price for a new unit (e.g., "₹12,000+").
  final String replacementEstimate;

  /// Clear, actionable recommendation on repair vs replacement.
  final String recommendation;

  /// Lower bound of estimated repair cost in numeric currency units.
  final int minRepairCost;

  /// Upper bound of estimated repair cost in numeric currency units.
  final int maxRepairCost;

  /// Estimated cost to buy a new replacement appliance.
  final int replacementCost;

  const RepairAssessment({
    required this.category,
    required this.issue,
    required this.possibleCauses,
    required this.estimatedRepairCost,
    required this.replacementEstimate,
    required this.recommendation,
    this.minRepairCost = 0,
    this.maxRepairCost = 0,
    this.replacementCost = 0,
  });

  /// Evaluates whether repair is strongly economical (e.g., max repair < 40% of replacement).
  bool get isRepairEconomical =>
      replacementCost > 0 && maxRepairCost < (replacementCost * 0.4);

  @override
  String toString() =>
      'RepairAssessment(category: $category, issue: $issue, repair: $estimatedRepairCost, replace: $replacementEstimate)';
}

/// Service providing deterministic decision rules for diagnosing issues
/// and recommending whether to repair or replace an appliance.
///
/// Designed cleanly so additional categories and issues can easily be added.
class RepairService {
  const RepairService();

  static const RepairService instance = RepairService();

  /// Normalized in-memory storage for custom rules added at runtime.
  static final Map<String, Map<String, RepairAssessment>> _customRules = {};

  /// Built-in deterministic prototype knowledge base.
  static final Map<String, Map<String, RepairAssessment>> _builtInRules = {
    'washing machine': {
      'not draining': const RepairAssessment(
        category: 'Washing Machine',
        issue: 'Not draining',
        possibleCauses: [
          'Clogged filter',
          'Blocked drain hose',
          'Drain pump issue',
        ],
        estimatedRepairCost: '₹500–₹1,500',
        replacementEstimate: '₹12,000+',
        recommendation: 'Repairing may be worth considering.',
        minRepairCost: 500,
        maxRepairCost: 1500,
        replacementCost: 12000,
      ),
      'not starting': const RepairAssessment(
        category: 'Washing Machine',
        issue: 'Not starting',
        possibleCauses: [
          'Blown fuse or faulty wall power socket',
          'Defective door lid lock switch',
          'Main control board malfunction',
        ],
        estimatedRepairCost: '₹600–₹2,500',
        replacementEstimate: '₹12,000+',
        recommendation:
            'Repairing may be worth considering. Common causes like door switches or power issues are quick and affordable fixes.',
        minRepairCost: 600,
        maxRepairCost: 2500,
        replacementCost: 12000,
      ),
      'water leaking': const RepairAssessment(
        category: 'Washing Machine',
        issue: 'Water leaking',
        possibleCauses: [
          'Damaged or loose inlet/drain hose',
          'Worn door gasket / rubber boot seal',
          'Blocked detergent drawer or dispenser',
        ],
        estimatedRepairCost: '₹500–₹2,000',
        replacementEstimate: '₹12,000+',
        recommendation:
            'Repairing is highly recommended. Replacing a hose or seal is straightforward and significantly cheaper than replacement.',
        minRepairCost: 500,
        maxRepairCost: 2000,
        replacementCost: 12000,
      ),
      'not spinning': const RepairAssessment(
        category: 'Washing Machine',
        issue: 'Not spinning',
        possibleCauses: [
          'Worn drive belt or motor coupling',
          'Defective motor capacitor or carbon brushes',
          'Unbalanced load or drum obstruction',
        ],
        estimatedRepairCost: '₹800–₹2,200',
        replacementEstimate: '₹12,000+',
        recommendation:
            'Repairing may be worth considering. Drive belt or capacitor replacements are typically low cost.',
        minRepairCost: 800,
        maxRepairCost: 2200,
        replacementCost: 12000,
      ),
      'making strange noise': const RepairAssessment(
        category: 'Washing Machine',
        issue: 'Making strange noise',
        possibleCauses: [
          'Worn drum bearings',
          'Foreign objects (coins, pins) trapped in drum or pump',
          'Damaged drive pulley or worn shock absorbers',
        ],
        estimatedRepairCost: '₹1,000–₹3,500',
        replacementEstimate: '₹12,000+',
        recommendation:
            'Repairing may be worth considering for loose items or shock absorbers. If drum bearings have worn out on an older machine, compare repair costs against replacement.',
        minRepairCost: 1000,
        maxRepairCost: 3500,
        replacementCost: 12000,
      ),
      'other': const RepairAssessment(
        category: 'Washing Machine',
        issue: 'Other',
        possibleCauses: [
          'General electrical or wiring issue',
          'Mechanical wear and tear',
          'Needs on-site technician inspection',
        ],
        estimatedRepairCost: '₹500–₹3,000',
        replacementEstimate: '₹12,000+',
        recommendation:
            'Schedule a technician inspection to diagnose the issue before deciding between repair and replacement.',
        minRepairCost: 500,
        maxRepairCost: 3000,
        replacementCost: 12000,
      ),
    },
    'refrigerator': {
      'not cooling': const RepairAssessment(
        category: 'Refrigerator',
        issue: 'Not cooling',
        possibleCauses: [
          'Dusty condenser coils',
          'Faulty thermostat or temperature sensor',
          'Defrost timer or compressor issue',
        ],
        estimatedRepairCost: '₹800–₹3,000',
        replacementEstimate: '₹15,000+',
        recommendation:
            'Repairing is worth considering if the compressor is intact.',
        minRepairCost: 800,
        maxRepairCost: 3000,
        replacementCost: 15000,
      ),
      'water leaking': const RepairAssessment(
        category: 'Refrigerator',
        issue: 'Water leaking',
        possibleCauses: [
          'Blocked defrost drain tube',
          'Cracked drain pan',
          'Damaged water inlet valve',
        ],
        estimatedRepairCost: '₹500–₹1,500',
        replacementEstimate: '₹15,000+',
        recommendation:
            'Repairing is highly recommended. Unclogging drains is usually inexpensive.',
        minRepairCost: 500,
        maxRepairCost: 1500,
        replacementCost: 15000,
      ),
      'making strange noise': const RepairAssessment(
        category: 'Refrigerator',
        issue: 'Making strange noise',
        possibleCauses: [
          'Evaporator or condenser fan blade obstruction',
          'Failing compressor mount springs',
          'Refrigerant circulation rattle',
        ],
        estimatedRepairCost: '₹700–₹2,500',
        replacementEstimate: '₹15,000+',
        recommendation:
            'Repairing is worth considering. Fan or mount fixes are cost-effective.',
        minRepairCost: 700,
        maxRepairCost: 2500,
        replacementCost: 15000,
      ),
      'other': const RepairAssessment(
        category: 'Refrigerator',
        issue: 'Other',
        possibleCauses: [
          'Door seal leak',
          'Electrical component failure',
          'Professional technician inspection required',
        ],
        estimatedRepairCost: '₹500–₹2,500',
        replacementEstimate: '₹15,000+',
        recommendation:
            'Schedule a technician inspection to assess whether repair is viable.',
        minRepairCost: 500,
        maxRepairCost: 2500,
        replacementCost: 15000,
      ),
    },
    'air conditioner': {
      'not cooling': const RepairAssessment(
        category: 'Air Conditioner',
        issue: 'Not cooling',
        possibleCauses: [
          'Clogged air filters',
          'Refrigerant gas leakage',
          'Dirty condenser coils or faulty capacitor',
        ],
        estimatedRepairCost: '₹700–₹2,500',
        replacementEstimate: '₹25,000+',
        recommendation:
            'Repairing is strongly recommended. Routine servicing and gas top-up usually solve the issue.',
        minRepairCost: 700,
        maxRepairCost: 2500,
        replacementCost: 25000,
      ),
      'water leaking': const RepairAssessment(
        category: 'Air Conditioner',
        issue: 'Water leaking',
        possibleCauses: [
          'Blocked drain line or pipe',
          'Damaged drain pan',
          'Dirty evaporator coil causing ice buildup',
        ],
        estimatedRepairCost: '₹500–₹1,800',
        replacementEstimate: '₹25,000+',
        recommendation:
            'Repairing is highly economical. Clearing the drain line resolves most leaks.',
        minRepairCost: 500,
        maxRepairCost: 1800,
        replacementCost: 25000,
      ),
      'other': const RepairAssessment(
        category: 'Air Conditioner',
        issue: 'Other',
        possibleCauses: [
          'Sensor error or PCB board issue',
          'Fan motor failure',
          'Requires technician diagnostic inspection',
        ],
        estimatedRepairCost: '₹800–₹3,500',
        replacementEstimate: '₹25,000+',
        recommendation:
            'Consult a certified technician to inspect the system before considering replacement.',
        minRepairCost: 800,
        maxRepairCost: 3500,
        replacementCost: 25000,
      ),
    },
    'microwave': {
      'not heating': const RepairAssessment(
        category: 'Microwave',
        issue: 'Not heating',
        possibleCauses: [
          'Blown high-voltage fuse',
          'Defective door safety switch',
          'Failing magnetron or diode',
        ],
        estimatedRepairCost: '₹600–₹1,800',
        replacementEstimate: '₹6,000+',
        recommendation:
            'Repairing is worth considering if the magnetron is intact.',
        minRepairCost: 600,
        maxRepairCost: 1800,
        replacementCost: 6000,
      ),
      'other': const RepairAssessment(
        category: 'Microwave',
        issue: 'Other',
        possibleCauses: [
          'Turntable motor failure',
          'Touchpad keypad malfunction',
          'Internal wiring damage',
        ],
        estimatedRepairCost: '₹400–₹1,500',
        replacementEstimate: '₹6,000+',
        recommendation:
            'Check repair quote. For small or low-cost microwaves, evaluate against new models.',
        minRepairCost: 400,
        maxRepairCost: 1500,
        replacementCost: 6000,
      ),
    },
  };

  /// Evaluates the given [category] and [issue] and returns a detailed [RepairAssessment].
  ///
  /// Matches case-insensitively and falls back to a sensible assessment if not found.
  RepairAssessment getAssessment({
    required String category,
    required String issue,
  }) {
    final normCat = _normalize(category);
    final normIssue = _normalize(issue);

    // 1. Check custom registered rules first
    if (_customRules.containsKey(normCat) &&
        _customRules[normCat]!.containsKey(normIssue)) {
      return _customRules[normCat]![normIssue]!;
    }

    // 2. Check built-in rules
    if (_builtInRules.containsKey(normCat)) {
      final categoryRules = _builtInRules[normCat]!;
      if (categoryRules.containsKey(normIssue)) {
        return categoryRules[normIssue]!;
      }

      // If category matches but specific issue not found, return 'other' for that category
      if (categoryRules.containsKey('other')) {
        final otherRule = categoryRules['other']!;
        return RepairAssessment(
          category: otherRule.category,
          issue: issue.trim().isEmpty ? 'General issue' : issue.trim(),
          possibleCauses: otherRule.possibleCauses,
          estimatedRepairCost: otherRule.estimatedRepairCost,
          replacementEstimate: otherRule.replacementEstimate,
          recommendation: otherRule.recommendation,
          minRepairCost: otherRule.minRepairCost,
          maxRepairCost: otherRule.maxRepairCost,
          replacementCost: otherRule.replacementCost,
        );
      }
    }

    // 3. Fallback for completely unknown categories
    return _buildDefaultAssessment(category: category, issue: issue);
  }

  /// Registers or overrides a rule dynamically at runtime for easy extensibility.
  static void registerRule(RepairAssessment assessment) {
    final normCat = _normalize(assessment.category);
    final normIssue = _normalize(assessment.issue);
    _customRules.putIfAbsent(normCat, () => {})[normIssue] = assessment;
  }

  /// Clears any registered custom rules (useful for testing).
  static void clearCustomRules() {
    _customRules.clear();
  }

  /// Lists all supported category display names.
  List<String> getSupportedCategories() {
    final categories = <String>{};
    for (final rules in _builtInRules.values) {
      if (rules.isNotEmpty) {
        categories.add(rules.values.first.category);
      }
    }
    for (final rules in _customRules.values) {
      if (rules.isNotEmpty) {
        categories.add(rules.values.first.category);
      }
    }
    return categories.toList();
  }

  /// Lists all supported issues for a given category.
  List<String> getIssuesForCategory(String category) {
    final normCat = _normalize(category);
    final issues = <String>{};

    if (_builtInRules.containsKey(normCat)) {
      for (final rule in _builtInRules[normCat]!.values) {
        issues.add(rule.issue);
      }
    }
    if (_customRules.containsKey(normCat)) {
      for (final rule in _customRules[normCat]!.values) {
        issues.add(rule.issue);
      }
    }

    return issues.toList();
  }

  static String _normalize(String input) {
    return input.trim().toLowerCase();
  }

  static RepairAssessment _buildDefaultAssessment({
    required String category,
    required String issue,
  }) {
    final cleanCategory =
        category.trim().isEmpty ? 'Appliance' : category.trim();
    final cleanIssue = issue.trim().isEmpty ? 'General problem' : issue.trim();

    return RepairAssessment(
      category: cleanCategory,
      issue: cleanIssue,
      possibleCauses: const [
        'Internal electrical or component fault',
        'Wear and tear from regular use',
        'On-site technician inspection needed',
      ],
      estimatedRepairCost: '₹500–₹2,500',
      replacementEstimate: '₹10,000+',
      recommendation:
          'Repairing may be worth considering. Have a local technician assess the problem before deciding to replace.',
      minRepairCost: 500,
      maxRepairCost: 2500,
      replacementCost: 10000,
    );
  }
}
