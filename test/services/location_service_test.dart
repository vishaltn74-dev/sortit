import 'package:flutter_test/flutter_test.dart';
import 'package:sortit/models/repairer.dart';
import 'package:sortit/services/location_service.dart';

void main() {
  group('LocationService Distance Calculations', () {
    const service = LocationService();

    test('calculates correct geographic distance between coordinates', () {
      // Coordinates: Bangalore City Railway Station to Indiranagar (approx 7.5 - 7.8 km)
      const userLat = 12.9784;
      const userLng = 77.5700;
      const destLat = 12.9784;
      const destLng = 77.6408;

      final distanceKm = service.calculateDistanceInKm(
        startLatitude: userLat,
        startLongitude: userLng,
        endLatitude: destLat,
        endLongitude: destLng,
      );

      // Verify distance is calculated geographically, not by simple subtraction
      expect(distanceKm, greaterThan(7.0));
      expect(distanceKm, lessThan(8.5));
    });

    test('returns 0 for identical coordinates', () {
      final distance = service.calculateDistanceInKm(
        startLatitude: 12.9716,
        startLongitude: 77.5946,
        endLatitude: 12.9716,
        endLongitude: 77.5946,
      );
      expect(distance, closeTo(0.0, 0.001));
    });

    test('formats distance sensibly with 1 decimal place', () {
      expect(service.formatDistance(0.42), '0.4 km');
      expect(service.formatDistance(1.23), '1.2 km');
      expect(service.formatDistance(8.68), '8.7 km');
      expect(service.formatDistance(0.0), '0.0 km');
    });

    test('sorts repairers by nearest distance and returns NearbyRepairer objects', () {
      const userLat = 12.9716;
      const userLng = 77.5946;

      final r1 = Repairer(
        id: '1',
        name: 'Far Repairer',
        category: 'Washing Machine',
        rating: 4.5,
        jobsCompleted: 30,
        inspectionFee: 200,
        latitude: 13.0827, // Chennai (~290 km)
        longitude: 80.2707,
        phone: '9876543210',
        services: ['Wash Repair'],
      );

      final r2 = Repairer(
        id: '2',
        name: 'Near Repairer',
        category: 'Washing Machine',
        rating: 4.8,
        jobsCompleted: 50,
        inspectionFee: 150,
        latitude: 12.9750, // Close to user (~0.5 km)
        longitude: 77.5970,
        phone: '9876543211',
        services: ['Wash Repair'],
      );

      final r3 = Repairer(
        id: '3',
        name: 'Mid Repairer',
        category: 'Washing Machine',
        rating: 4.2,
        jobsCompleted: 20,
        inspectionFee: 180,
        latitude: 12.9900, // (~2.5 km)
        longitude: 77.6000,
        phone: '9876543212',
        services: ['Wash Repair'],
      );

      final sortedNearby = service.getNearestRepairers(
        userLatitude: userLat,
        userLongitude: userLng,
        repairers: [r1, r2, r3],
      );

      expect(sortedNearby.length, 3);
      expect(sortedNearby[0].repairer.id, '2'); // Near Repairer first
      expect(sortedNearby[1].repairer.id, '3'); // Mid Repairer second
      expect(sortedNearby[2].repairer.id, '1'); // Far Repairer last

      expect(sortedNearby[0].distanceKm, lessThan(sortedNearby[1].distanceKm));
      expect(sortedNearby[1].distanceKm, lessThan(sortedNearby[2].distanceKm));
      expect(sortedNearby[0].formattedDistance.endsWith('km'), isTrue);

      final sortedRaw = service.sortRepairersByDistance(
        userLatitude: userLat,
        userLongitude: userLng,
        repairers: [r1, r2, r3],
      );
      expect(sortedRaw.map((r) => r.id).toList(), ['2', '3', '1']);
    });

    test('LocationResult returns expected state on success and failure', () {
      const success = LocationResult.success(latitude: 12.97, longitude: 77.59);
      expect(success.isSuccess, isTrue);
      expect(success.latitude, 12.97);
      expect(success.longitude, 77.59);
      expect(success.errorMessage, isNull);

      const failure = LocationResult.failure(
        errorMessage: 'GPS Disabled',
        errorType: LocationErrorType.serviceDisabled,
      );
      expect(failure.isSuccess, isFalse);
      expect(failure.latitude, isNull);
      expect(failure.errorType, LocationErrorType.serviceDisabled);
      expect(failure.errorMessage, 'GPS Disabled');
    });
  });
}
