import 'dart:async';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:sortit/models/repairer.dart';

/// Represents error types encountered when fetching user location.
enum LocationErrorType {
  /// GPS or location services disabled on device.
  serviceDisabled,

  /// Permission denied by user.
  permissionDenied,

  /// Permission permanently denied. User must enable in settings.
  permissionDeniedForever,

  /// Request timed out.
  timeout,

  /// An unknown or platform exception occurred.
  unknown,
}

/// Result object for location queries providing null-safe success or failure details.
class LocationResult {
  final double? latitude;
  final double? longitude;
  final bool isSuccess;
  final String? errorMessage;
  final LocationErrorType? errorType;

  const LocationResult.success({
    required this.latitude,
    required this.longitude,
  })  : isSuccess = true,
        errorMessage = null,
        errorType = null;

  const LocationResult.failure({
    required this.errorMessage,
    required this.errorType,
  })  : latitude = null,
        longitude = null,
        isSuccess = false;

  @override
  String toString() {
    if (isSuccess) {
      return 'LocationResult.success(lat: $latitude, lon: $longitude)';
    }
    return 'LocationResult.failure($errorType: $errorMessage)';
  }
}

/// Represents a [Repairer] associated with a calculated distance from the user.
class NearbyRepairer {
  final Repairer repairer;
  final double distanceKm;
  final String formattedDistance;

  const NearbyRepairer({
    required this.repairer,
    required this.distanceKm,
    required this.formattedDistance,
  });

  @override
  String toString() =>
      'NearbyRepairer(${repairer.name}, distance: $formattedDistance)';
}

/// Service handling GPS location requests, permission validation,
/// geographic distance calculations, and repairer proximity sorting.
class LocationService {
  const LocationService();

  /// Default singleton instance for convenience.
  static const LocationService instance = LocationService();

  /// Checks if location services are enabled on the host device.
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (_) {
      return false;
    }
  }

  /// Checks the current location permission status.
  Future<LocationPermission> checkPermission() async {
    try {
      return await Geolocator.checkPermission();
    } catch (_) {
      return LocationPermission.denied;
    }
  }

  /// Requests location permission from the user.
  Future<LocationPermission> requestPermission() async {
    try {
      return await Geolocator.requestPermission();
    } catch (_) {
      return LocationPermission.denied;
    }
  }

  /// Obtains the current GPS coordinates of the user.
  ///
  /// Gracefully handles disabled services, denied permissions,
  /// permanent denials, and request timeouts without throwing unhandled exceptions.
  Future<LocationResult> getCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration timeLimit = const Duration(seconds: 15),
  }) async {
    try {
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const LocationResult.failure(
          errorMessage:
              'Location services are disabled on this device. Please turn on GPS.',
          errorType: LocationErrorType.serviceDisabled,
        );
      }

      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          return const LocationResult.failure(
            errorMessage: 'Location permission was denied.',
            errorType: LocationErrorType.permissionDenied,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const LocationResult.failure(
          errorMessage:
              'Location permissions are permanently denied. Please enable them in app settings.',
          errorType: LocationErrorType.permissionDeniedForever,
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: timeLimit,
        ),
      );

      return LocationResult.success(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on TimeoutException {
      return const LocationResult.failure(
        errorMessage: 'Location request timed out. Please try again.',
        errorType: LocationErrorType.timeout,
      );
    } catch (e) {
      return LocationResult.failure(
        errorMessage: 'Could not obtain location: ${e.toString()}',
        errorType: LocationErrorType.unknown,
      );
    }
  }

  /// Calculates the geographic distance in kilometers between two points
  /// using the WGS84 geodesic calculation, with a pure Haversine fallback.
  ///
  /// Does NOT use simple latitude/longitude subtraction.
  double calculateDistanceInKm({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    try {
      final distanceInMeters = Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
      return distanceInMeters / 1000.0;
    } catch (_) {
      // Pure mathematical Haversine formula fallback for headless or test environments
      return calculateHaversineDistanceKm(
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
      );
    }
  }

  /// Mathematical Haversine formula for spherical distance in kilometers.
  static double calculateHaversineDistanceKm({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _toRadians(endLatitude - startLatitude);
    final double dLon = _toRadians(endLongitude - startLongitude);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(startLatitude)) *
            math.cos(_toRadians(endLatitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _toRadians(double degree) => degree * math.pi / 180.0;

  /// Returns a clean, user-friendly distance string (e.g., "0.4 km", "1.2 km", "8.7 km").
  String formatDistance(double distanceInKm) {
    if (distanceInKm < 0) return '0.0 km';
    return '${distanceInKm.toStringAsFixed(1)} km';
  }

  /// Calculates the distance from [userLatitude], [userLongitude] to each repairer,
  /// sorts the list nearest-first, and returns a list of [NearbyRepairer] items
  /// exposing the calculated distance and formatted string for the UI.
  List<NearbyRepairer> getNearestRepairers({
    required double userLatitude,
    required double userLongitude,
    required List<Repairer> repairers,
  }) {
    final list = repairers.map((repairer) {
      final dist = calculateDistanceInKm(
        startLatitude: userLatitude,
        startLongitude: userLongitude,
        endLatitude: repairer.latitude,
        endLongitude: repairer.longitude,
      );
      return NearbyRepairer(
        repairer: repairer,
        distanceKm: dist,
        formattedDistance: formatDistance(dist),
      );
    }).toList();

    list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return list;
  }

  /// Sorts a given list of [Repairer] entities by nearest distance from the user.
  List<Repairer> sortRepairersByDistance({
    required double userLatitude,
    required double userLongitude,
    required List<Repairer> repairers,
  }) {
    final nearby = getNearestRepairers(
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      repairers: repairers,
    );
    return nearby.map((n) => n.repairer).toList();
  }
}
