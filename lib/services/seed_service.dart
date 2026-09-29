import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:sortit/models/category.dart';
import 'package:sortit/models/issue.dart';
import 'package:sortit/models/repairer.dart';
import 'package:sortit/services/firebase_service.dart';

/// Seed utility for populating Firestore with initial demo data.
///
/// Kept separate from production application logic.
///
/// HOW TO RUN THE SEED:
/// 1. From code (e.g. inside `main()` during initial setup or in a debug/admin screen):
///    ```dart
///    await FirebaseService.initialize();
///    final result = await SeedService.seedAll();
///    debugPrint('Seed completed: $result');
///    ```
/// 2. Or seed individual collections on demand:
///    ```dart
///    await SeedService.seedCategories();
///    await SeedService.seedIssues();
///    await SeedService.seedRepairers();
///    ```
///
/// DUPLICATE PREVENTION:
/// All documents use fixed, deterministic IDs (e.g. `ac`, `ac_not_cooling`, `rep_ac_1`).
/// Using `doc(id).set(...)` with Firestore batch writes guarantees that running the seed
/// repeatedly updates existing records in place rather than creating duplicate documents.
class SeedService {
  SeedService._();

  static const String categoriesCollection = 'categories';
  static const String issuesCollection = 'issues';
  static const String repairersCollection = 'repairers';

  /// Exactly 6 demo categories with stable IDs.
  static final List<Category> demoCategories = [
    Category(
      id: 'ac',
      name: 'AC',
      icon: 'ac_unit',
    ),
    Category(
      id: 'phone',
      name: 'Phone',
      icon: 'smartphone',
    ),
    Category(
      id: 'washing_machine',
      name: 'Washing Machine',
      icon: 'local_laundry_service',
    ),
    Category(
      id: 'laptop',
      name: 'Laptop',
      icon: 'laptop',
    ),
    Category(
      id: 'bicycle',
      name: 'Bicycle',
      icon: 'pedal_bike',
    ),
    Category(
      id: 'electrical',
      name: 'Electrical',
      icon: 'electrical_services',
    ),
  ];

  /// Exactly 24 issues (4 realistic issues per category).
  static final List<Issue> demoIssues = [
    // --- AC Issues ---
    Issue(
      id: 'ac_not_cooling',
      categoryId: 'ac',
      name: 'AC not cooling',
    ),
    Issue(
      id: 'ac_water_leak',
      categoryId: 'ac',
      name: 'Water leaking',
    ),
    Issue(
      id: 'ac_not_turning_on',
      categoryId: 'ac',
      name: 'AC not turning on',
    ),
    Issue(
      id: 'ac_strange_noise',
      categoryId: 'ac',
      name: 'Strange noise',
    ),

    // --- Phone Issues ---
    Issue(
      id: 'phone_screen_damage',
      categoryId: 'phone',
      name: 'Screen damage',
    ),
    Issue(
      id: 'phone_battery_drain',
      categoryId: 'phone',
      name: 'Battery draining quickly',
    ),
    Issue(
      id: 'phone_not_charging',
      categoryId: 'phone',
      name: 'Phone not charging',
    ),
    Issue(
      id: 'phone_overheating',
      categoryId: 'phone',
      name: 'Phone overheating',
    ),

    // --- Washing Machine Issues ---
    Issue(
      id: 'washer_not_starting',
      categoryId: 'washing_machine',
      name: 'Not starting',
    ),
    Issue(
      id: 'washer_not_draining',
      categoryId: 'washing_machine',
      name: 'Not draining water',
    ),
    Issue(
      id: 'washer_water_leak',
      categoryId: 'washing_machine',
      name: 'Water leaking',
    ),
    Issue(
      id: 'washer_strange_noise',
      categoryId: 'washing_machine',
      name: 'Strange noise',
    ),

    // --- Laptop Issues ---
    Issue(
      id: 'laptop_not_turning_on',
      categoryId: 'laptop',
      name: 'Laptop not turning on',
    ),
    Issue(
      id: 'laptop_overheating',
      categoryId: 'laptop',
      name: 'Overheating',
    ),
    Issue(
      id: 'laptop_slow',
      categoryId: 'laptop',
      name: 'Laptop running slowly',
    ),
    Issue(
      id: 'laptop_battery_issue',
      categoryId: 'laptop',
      name: 'Battery issue',
    ),

    // --- Bicycle Issues ---
    Issue(
      id: 'bicycle_flat_tire',
      categoryId: 'bicycle',
      name: 'Flat tire',
    ),
    Issue(
      id: 'bicycle_brake_issue',
      categoryId: 'bicycle',
      name: 'Brake problem',
    ),
    Issue(
      id: 'bicycle_chain_problem',
      categoryId: 'bicycle',
      name: 'Chain problem',
    ),
    Issue(
      id: 'bicycle_gear_problem',
      categoryId: 'bicycle',
      name: 'Gear problem',
    ),

    // --- Electrical Issues ---
    Issue(
      id: 'power_outage',
      categoryId: 'electrical',
      name: 'Power outage',
    ),
    Issue(
      id: 'switch_not_working',
      categoryId: 'electrical',
      name: 'Switch not working',
    ),
    Issue(
      id: 'socket_not_working',
      categoryId: 'electrical',
      name: 'Socket not working',
    ),
    Issue(
      id: 'wiring_issue',
      categoryId: 'electrical',
      name: 'Wiring issue',
    ),
  ];

  /// Exactly 24 believable demo repairers (4 per category across Bengaluru).
  static final List<Repairer> demoRepairers = [
    // === AC Repairers (4) ===
    Repairer(
      id: 'rep_ac_1',
      name: 'CoolCare AC Services (Ramesh Kumar)',
      category: 'AC',
      rating: 4.8,
      jobsCompleted: 154,
      inspectionFee: 199,
      latitude: 12.9784,
      longitude: 77.6408, // Indiranagar
      phone: '+91 98450 11001',
      services: [
        'AC Installation',
        'Gas Refill',
        'Filter Cleaning',
        'PCB Repair',
      ],
    ),
    Repairer(
      id: 'rep_ac_2',
      name: 'FrostAir Cooling Tech (Suresh Babu)',
      category: 'AC',
      rating: 4.6,
      jobsCompleted: 98,
      inspectionFee: 149,
      latitude: 12.9352,
      longitude: 77.6245, // Koramangala
      phone: '+91 98450 11002',
      services: [
        'Split AC Servicing',
        'Window AC Repair',
        'Compressor Check',
      ],
    ),
    Repairer(
      id: 'rep_ac_3',
      name: 'BreezePoint HVAC Care (Farhan Akhtar)',
      category: 'AC',
      rating: 4.9,
      jobsCompleted: 215,
      inspectionFee: 249,
      latitude: 12.9121,
      longitude: 77.6446, // HSR Layout
      phone: '+91 98450 11003',
      services: [
        'Emergency Cooling Fix',
        'Duct Cleaning',
        'Thermostat Replacement',
      ],
    ),
    Repairer(
      id: 'rep_ac_4',
      name: 'Whitefield AC Masters (Manjunath R)',
      category: 'AC',
      rating: 4.4,
      jobsCompleted: 78,
      inspectionFee: 149,
      latitude: 12.9698,
      longitude: 77.7499, // Whitefield
      phone: '+91 98450 11004',
      services: [
        'Deep Coil Cleaning',
        'Leakage Detection',
        'Annual Maintenance',
      ],
    ),

    // === Phone Repairers (4) ===
    Repairer(
      id: 'rep_phone_1',
      name: 'QuickFix Mobiles (Syed Imran)',
      category: 'Phone',
      rating: 4.7,
      jobsCompleted: 310,
      inspectionFee: 99,
      latitude: 12.9352,
      longitude: 77.6245, // Koramangala
      phone: '+91 98450 22001',
      services: [
        'Screen Replacement',
        'Battery Swap',
        'Charging Port Fix',
      ],
    ),
    Repairer(
      id: 'rep_phone_2',
      name: 'iDoctor Smartphone Clinic (Prashanth N)',
      category: 'Phone',
      rating: 4.9,
      jobsCompleted: 420,
      inspectionFee: 149,
      latitude: 12.9784,
      longitude: 77.6408, // Indiranagar
      phone: '+91 98450 22002',
      services: [
        'iPhone Specialists',
        'OLED Display Fix',
        'Speaker & Mic Repair',
      ],
    ),
    Repairer(
      id: 'rep_phone_3',
      name: 'Malleshwaram Mobile Hub (Venkatesh K)',
      category: 'Phone',
      rating: 4.5,
      jobsCompleted: 185,
      inspectionFee: 99,
      latitude: 13.0031,
      longitude: 77.5643, // Malleshwaram
      phone: '+91 98450 22003',
      services: [
        'Android Motherboard Fix',
        'Water Damage Recovery',
        'Camera Module Swap',
      ],
    ),
    Repairer(
      id: 'rep_phone_4',
      name: 'SmartPhone Care Station (Anand Joshi)',
      category: 'Phone',
      rating: 4.8,
      jobsCompleted: 260,
      inspectionFee: 120,
      latitude: 12.9308,
      longitude: 77.5838, // Jayanagar
      phone: '+91 98450 22004',
      services: [
        'Glass Replacement',
        'Battery Health Restore',
        'Software Flashing',
      ],
    ),

    // === Washing Machine Repairers (4) ===
    Repairer(
      id: 'rep_wm_1',
      name: 'SpinTech Appliance Care (Jagadish M)',
      category: 'Washing Machine',
      rating: 4.7,
      jobsCompleted: 165,
      inspectionFee: 199,
      latitude: 12.9121,
      longitude: 77.6446, // HSR Layout
      phone: '+91 98450 33001',
      services: [
        'Front Load Drum Repair',
        'Drain Pump Replacement',
        'Bearing Replacement',
      ],
    ),
    Repairer(
      id: 'rep_wm_2',
      name: 'HomeEase Washer Care (Santosh Patil)',
      category: 'Washing Machine',
      rating: 4.8,
      jobsCompleted: 190,
      inspectionFee: 199,
      latitude: 12.9982,
      longitude: 77.5530, // Rajajinagar
      phone: '+91 98450 33002',
      services: [
        'Top Load Servicing',
        'PCB Board Repair',
        'Inlet Valve Fix',
      ],
    ),
    Repairer(
      id: 'rep_wm_3',
      name: 'Metro Appliance Doctor (Girish Rao)',
      category: 'Washing Machine',
      rating: 4.3,
      jobsCompleted: 88,
      inspectionFee: 149,
      latitude: 12.9591,
      longitude: 77.6974, // Marathahalli
      phone: '+91 98450 33003',
      services: [
        'Vibration Damper Fix',
        'Belt Replacement',
        'Descaling Service',
      ],
    ),
    Repairer(
      id: 'rep_wm_4',
      name: 'SmartWash Tech Works (Karthik S)',
      category: 'Washing Machine',
      rating: 4.6,
      jobsCompleted: 112,
      inspectionFee: 179,
      latitude: 13.0285,
      longitude: 77.5457, // Yeshwanthpur
      phone: '+91 98450 33004',
      services: [
        'Semi-Automatic Fix',
        'Fully Automatic Servicing',
        'Motor Rewinding',
      ],
    ),

    // === Laptop Repairers (4) ===
    Repairer(
      id: 'rep_lap_1',
      name: 'Silicon Valley LapCare (Naveen Chandra)',
      category: 'Laptop',
      rating: 4.9,
      jobsCompleted: 380,
      inspectionFee: 199,
      latitude: 12.9352,
      longitude: 77.6245, // Koramangala
      phone: '+91 98450 44001',
      services: [
        'MacBook Chip Level Repair',
        'Screen Replacement',
        'Thermal Paste Renewal',
      ],
    ),
    Repairer(
      id: 'rep_lap_2',
      name: 'Indiranagar Laptop Center (Manoj Gowda)',
      category: 'Laptop',
      rating: 4.7,
      jobsCompleted: 240,
      inspectionFee: 149,
      latitude: 12.9784,
      longitude: 77.6408, // Indiranagar
      phone: '+91 98450 44002',
      services: [
        'Keyboard Replacement',
        'Battery Upgrade',
        'RAM & SSD Installation',
      ],
    ),
    Repairer(
      id: 'rep_lap_3',
      name: 'Whitefield IT Doctor (Arun Kumar)',
      category: 'Laptop',
      rating: 4.8,
      jobsCompleted: 195,
      inspectionFee: 199,
      latitude: 12.9698,
      longitude: 77.7499, // Whitefield
      phone: '+91 98450 44003',
      services: [
        'Hinge & Body Repair',
        'Motherboard Power IC Fix',
        'OS & Data Recovery',
      ],
    ),
    Repairer(
      id: 'rep_lap_4',
      name: 'West Gate Computer Clinic (Deepak Verma)',
      category: 'Laptop',
      rating: 4.4,
      jobsCompleted: 130,
      inspectionFee: 149,
      latitude: 12.9982,
      longitude: 77.5530, // Rajajinagar
      phone: '+91 98450 44004',
      services: [
        'Liquid Spill Cleaning',
        'Fan Replacement',
        'Charging Jack Fix',
      ],
    ),

    // === Bicycle Repairers (4) ===
    Repairer(
      id: 'rep_bike_1',
      name: 'PedalPower Cycle Works (Sanjay Srinivas)',
      category: 'Bicycle',
      rating: 4.8,
      jobsCompleted: 210,
      inspectionFee: 99,
      latitude: 12.9308,
      longitude: 77.5838, // Jayanagar
      phone: '+91 98450 55001',
      services: [
        'Gear Tuning',
        'Disc Brake Bleeding',
        'Bottom Bracket Overhaul',
      ],
    ),
    Repairer(
      id: 'rep_bike_2',
      name: 'HSR Cycle Clinic (Praveen Yadav)',
      category: 'Bicycle',
      rating: 4.6,
      jobsCompleted: 175,
      inspectionFee: 79,
      latitude: 12.9121,
      longitude: 77.6446, // HSR Layout
      phone: '+91 98450 55002',
      services: [
        'Doorstep Puncture Repair',
        'Chain Lubrication',
        'Spoke Truing',
      ],
    ),
    Repairer(
      id: 'rep_bike_3',
      name: 'Malleshwaram Cyclery (Mohan Das)',
      category: 'Bicycle',
      rating: 4.9,
      jobsCompleted: 290,
      inspectionFee: 99,
      latitude: 13.0031,
      longitude: 77.5643, // Malleshwaram
      phone: '+91 98450 55003',
      services: [
        'Complete Bike Overhaul',
        'Hydraulic Brake Setup',
        'Wheel Alignment',
      ],
    ),
    Repairer(
      id: 'rep_bike_4',
      name: 'Marathahalli Bike Station (Kishore Reddy)',
      category: 'Bicycle',
      rating: 4.3,
      jobsCompleted: 95,
      inspectionFee: 69,
      latitude: 12.9591,
      longitude: 77.6974, // Marathahalli
      phone: '+91 98450 55004',
      services: [
        'Inner Tube Replacement',
        'Derailleur Alignment',
        'Brake Cable Tuning',
      ],
    ),

    // === Electrical Repairers (4) ===
    Repairer(
      id: 'rep_elec_1',
      name: 'BrightSpark Electricals (Shiva Kumar)',
      category: 'Electrical',
      rating: 4.9,
      jobsCompleted: 340,
      inspectionFee: 149,
      latitude: 12.9308,
      longitude: 77.5838, // Jayanagar
      phone: '+91 98450 66001',
      services: [
        'Home Rewiring',
        'Short Circuit Troubleshooting',
        'Fan & Light Installation',
      ],
    ),
    Repairer(
      id: 'rep_elec_2',
      name: 'Indiranagar Power Solutions (Bhaskar Rao)',
      category: 'Electrical',
      rating: 4.7,
      jobsCompleted: 225,
      inspectionFee: 149,
      latitude: 12.9784,
      longitude: 77.6408, // Indiranagar
      phone: '+91 98450 66002',
      services: [
        'MCB Distribution Box Setup',
        'Earthing & Grounding',
        'Inverter Wiring',
      ],
    ),
    Repairer(
      id: 'rep_elec_3',
      name: 'Metro Spark Electricians (Syed Ahmed)',
      category: 'Electrical',
      rating: 4.5,
      jobsCompleted: 180,
      inspectionFee: 129,
      latitude: 13.0285,
      longitude: 77.5457, // Yeshwanthpur
      phone: '+91 98450 66003',
      services: [
        'Geyser Electrical Repair',
        'Switchboard Replacement',
        'Meter Box Inspection',
      ],
    ),
    Repairer(
      id: 'rep_elec_4',
      name: 'Whitefield Voltage Pro (Harish Gowda)',
      category: 'Electrical',
      rating: 4.8,
      jobsCompleted: 210,
      inspectionFee: 149,
      latitude: 12.9698,
      longitude: 77.7499, // Whitefield
      phone: '+91 98450 66004',
      services: [
        '3-Phase Panel Service',
        'LED Profile Light Setup',
        'Emergency Power Restore',
      ],
    ),
  ];

  /// Seeds all 6 categories into Firestore. Returns the count of seeded categories.
  static Future<int> seedCategories({FirebaseFirestore? firestore}) async {
    try {
      final db = firestore ?? FirebaseService.firestore;
      final batch = db.batch();
      for (final category in demoCategories) {
        final docRef = db.collection(categoriesCollection).doc(category.id);
        batch.set(docRef, category.toMap());
      }
      await batch.commit();
      debugPrint('Successfully seeded ${demoCategories.length} categories.');
      return demoCategories.length;
    } catch (e, stackTrace) {
      debugPrint('SeedService.seedCategories failed: $e\n$stackTrace');
      return 0;
    }
  }

  /// Seeds all 24 issues into Firestore. Returns the count of seeded issues.
  static Future<int> seedIssues({FirebaseFirestore? firestore}) async {
    try {
      final db = firestore ?? FirebaseService.firestore;
      final batch = db.batch();
      for (final issue in demoIssues) {
        final docRef = db.collection(issuesCollection).doc(issue.id);
        batch.set(docRef, issue.toMap());
      }
      await batch.commit();
      debugPrint('Successfully seeded ${demoIssues.length} issues.');
      return demoIssues.length;
    } catch (e, stackTrace) {
      debugPrint('SeedService.seedIssues failed: $e\n$stackTrace');
      return 0;
    }
  }

  /// Seeds all 24 repairers into Firestore. Returns the count of seeded repairers.
  static Future<int> seedRepairers({FirebaseFirestore? firestore}) async {
    try {
      final db = firestore ?? FirebaseService.firestore;
      final batch = db.batch();
      for (final repairer in demoRepairers) {
        final docRef = db.collection(repairersCollection).doc(repairer.id);
        batch.set(docRef, repairer.toMap());
      }
      await batch.commit();
      debugPrint('Successfully seeded ${demoRepairers.length} repairers.');
      return demoRepairers.length;
    } catch (e, stackTrace) {
      debugPrint('SeedService.seedRepairers failed: $e\n$stackTrace');
      return 0;
    }
  }

  /// Seeds categories, issues, and repairers in sequence.
  /// Returns a [SeedResult] summary.
  static Future<SeedResult> seedAll({FirebaseFirestore? firestore}) async {
    final categoriesCount = await seedCategories(firestore: firestore);
    final issuesCount = await seedIssues(firestore: firestore);
    final repairersCount = await seedRepairers(firestore: firestore);

    return SeedResult(
      categoriesCount: categoriesCount,
      issuesCount: issuesCount,
      repairersCount: repairersCount,
    );
  }
}

/// Summary report of the Firestore seed operation.
class SeedResult {
  final int categoriesCount;
  final int issuesCount;
  final int repairersCount;

  const SeedResult({
    required this.categoriesCount,
    required this.issuesCount,
    required this.repairersCount,
  });

  bool get isSuccess =>
      categoriesCount > 0 && issuesCount > 0 && repairersCount > 0;

  @override
  String toString() =>
      'SeedResult(categories: $categoriesCount, issues: $issuesCount, repairers: $repairersCount)';
}
