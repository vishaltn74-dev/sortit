import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sortit/models/category.dart';
import 'package:sortit/models/issue.dart';
import 'package:sortit/models/repairer.dart';
import 'package:sortit/screens/repairers/repairers_screen.dart';
import 'package:sortit/services/location_service.dart';
import 'package:sortit/services/repairer_service.dart';

class MockLocationService extends LocationService {
  final LocationResult result;

  MockLocationService({required this.result});

  @override
  Future<LocationResult> getCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration timeLimit = const Duration(seconds: 15),
  }) async {
    return result;
  }
}

class MockRepairerService extends RepairerService {
  final List<Repairer> repairers;
  final bool shouldThrow;

  MockRepairerService({this.repairers = const [], this.shouldThrow = false});

  @override
  Future<List<Repairer>> fetchRepairersByCategory(String category) async {
    if (shouldThrow) throw Exception('Test error');
    return repairers;
  }
}

void main() {
  final testCategory = const Category(id: 'c1', name: 'Appliance', icon: 'appliance_icon');
  final testIssue = Issue(id: 'i1', categoryId: 'c1', name: 'Not working');

  setUpAll(() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.library == 'image resource service') return;
      FlutterError.presentError(details);
    };
  });

  testWidgets('RepairersScreen shows loading and then repairers', (WidgetTester tester) async {
    final mockLocation = MockLocationService(
      result: const LocationResult.success(latitude: 10.0, longitude: 20.0),
    );

    final mockRepairers = [
      Repairer(
        id: 'r1',
        name: 'Test Repairer',
        category: 'Appliance',
        rating: 4.5,
        jobsCompleted: 10,
        inspectionFee: 50,
        latitude: 10.1,
        longitude: 20.1,
        phone: '1234567890',
        services: [],
      )
    ];

    final mockRepairerService = MockRepairerService(repairers: mockRepairers);

    await tester.pumpWidget(MaterialApp(
      home: RepairersScreen(
        category: testCategory,
        issue: testIssue,
        locationService: mockLocation,
        repairerService: mockRepairerService,
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Test Repairer'), findsWidgets);
    expect(find.text('Location obtained'), findsOneWidget);
  });

  testWidgets('RepairersScreen handles location failure gracefully', (WidgetTester tester) async {
    final mockLocation = MockLocationService(
      result: const LocationResult.failure(errorMessage: 'Location denied', errorType: LocationErrorType.permissionDenied),
    );

    final mockRepairerService = MockRepairerService(repairers: []);

    await tester.pumpWidget(MaterialApp(
      home: RepairersScreen(
        category: testCategory,
        issue: testIssue,
        locationService: mockLocation,
        repairerService: mockRepairerService,
      ),
    ));

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Location denied'), findsOneWidget);
    expect(find.text('No repairers found in this category.'), findsOneWidget);
  });

  testWidgets('RepairersScreen handles service exception gracefully', (WidgetTester tester) async {
    final mockLocation = MockLocationService(
      result: const LocationResult.success(latitude: 10.0, longitude: 20.0),
    );

    final mockRepairerService = MockRepairerService(shouldThrow: true);

    await tester.pumpWidget(MaterialApp(
      home: RepairersScreen(
        category: testCategory,
        issue: testIssue,
        locationService: mockLocation,
        repairerService: mockRepairerService,
      ),
    ));

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Failed to load repairers.'), findsOneWidget);
  });
}
