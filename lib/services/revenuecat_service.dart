import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  // Provide your RevenueCat public SDK keys via --dart-define or --dart-define-from-file
  static const String _appleApiKey = String.fromEnvironment('REVENUECAT_APPLE_API_KEY');
  static const String _googleApiKey = String.fromEnvironment('REVENUECAT_GOOGLE_API_KEY');

  static Future<void> init() async {
    // We conditionally configure Purchases only if the keys are provided.
    // This safely keeps configuration pending without causing the app to crash.
    if (Platform.isIOS && _appleApiKey.isNotEmpty) {
      await Purchases.configure(PurchasesConfiguration(_appleApiKey));
    } else if (Platform.isAndroid && _googleApiKey.isNotEmpty) {
      await Purchases.configure(PurchasesConfiguration(_googleApiKey));
    } else {
      debugPrint('RevenueCat initialization pending: API keys are missing.');
    }
  }
  static Future<void> trackAdRevenue({
    required String adUnitId,
    required double valueMicros,
    required String currencyCode,
    required String impressionId,
    required String precisionString, // Maps from AdMob PrecisionType.name
  }) async {
    // Only proceed if keys are provided (which implies Purchases is configured)
    if (_appleApiKey.isEmpty && _googleApiKey.isEmpty) {
      return;
    }

    AdRevenuePrecision rcPrecision;
    switch (precisionString) {
      case 'precise':
        rcPrecision = AdRevenuePrecision.exact;
        break;
      case 'publisherProvided':
        rcPrecision = AdRevenuePrecision.publisherDefined;
        break;
      case 'estimated':
        rcPrecision = AdRevenuePrecision.estimated;
        break;
      case 'unknown':
      default:
        rcPrecision = AdRevenuePrecision.unknown;
        break;
    }

    final data = AdRevenueData(
      mediatorName: AdMediatorName.adMob,
      adFormat: AdFormat.banner,
      adUnitId: adUnitId,
      impressionId: impressionId,
      revenueMicros: valueMicros.toInt(),
      currency: currencyCode,
      precision: rcPrecision,
    );

    try {
      await Purchases.adTracker.trackAdRevenue(data);
    } catch (e) {
      debugPrint('Error tracking ad revenue: $e');
    }
  }
}
