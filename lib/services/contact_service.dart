import 'package:url_launcher/url_launcher.dart';
import 'package:sortit/models/repairer.dart';

/// Service providing reusable helpers to launch external actions
/// such as telephone calls, WhatsApp messages, and Google Maps navigation.
///
/// Keeps platform-specific URL and scheme handling out of UI widgets.
class ContactService {
  const ContactService();

  /// Default singleton instance for convenience.
  static const ContactService instance = ContactService();

  /// Strips formatting characters from phone number while preserving digits and '+'.
  static String sanitizePhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }

  /// Cleans and formats a phone number for the WhatsApp wa.me API.
  ///
  /// Removes non-digit characters, removes leading zeroes, and defaults
  /// standard 10-digit numbers to the Indian country code (91) if omitted.
  static String formatPhoneForWhatsApp(String phone) {
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    // If standard 10-digit number without country code, prepend 91 (India)
    if (digits.length == 10) {
      digits = '91$digits';
    }
    return digits;
  }

  /// Initiates a telephone call using the `tel:` scheme.
  ///
  /// Returns `true` if the call intent was successfully launched, `false` otherwise.
  Future<bool> makePhoneCall(String phoneNumber) async {
    try {
      final sanitized = sanitizePhoneNumber(phoneNumber);
      if (sanitized.isEmpty) return false;

      final uri = Uri(scheme: 'tel', path: sanitized);
      return await launchUrl(uri);
    } catch (_) {
      return false;
    }
  }

  /// Opens WhatsApp conversation using `https://wa.me/` with an optional prefilled message.
  ///
  /// Launches using [LaunchMode.externalApplication] so the device WhatsApp app opens.
  /// Returns `true` if the URL was launched, `false` otherwise.
  Future<bool> openWhatsApp({
    required String phoneNumber,
    String? message,
  }) async {
    try {
      final cleanNumber = formatPhoneForWhatsApp(phoneNumber);
      if (cleanNumber.isEmpty) return false;

      final Map<String, String>? queryParams =
          (message != null && message.trim().isNotEmpty)
              ? {'text': message.trim()}
              : null;

      final uri = Uri.https('wa.me', '/$cleanNumber', queryParams);
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }

  /// Opens turn-by-turn navigation or directions to the specified coordinates in Google Maps.
  ///
  /// Returns `true` if launched successfully, `false` otherwise.
  Future<bool> openMapDirections({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    try {
      final queryParams = <String, String>{
        'api': '1',
        'destination': '$latitude,$longitude',
      };

      final uri = Uri.https('www.google.com', '/maps/dir/', queryParams);
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }

  /// Opens a pin location search at the given coordinates in Google Maps.
  Future<bool> openMapCoordinates({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    try {
      final query = (label != null && label.trim().isNotEmpty)
          ? '$latitude,$longitude (${label.trim()})'
          : '$latitude,$longitude';

      final uri = Uri.https('www.google.com', '/maps/search/', {
        'api': '1',
        'query': query,
      });

      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }

  /// Convenience helper to call a [Repairer] directly.
  Future<bool> callRepairer(Repairer repairer) {
    return makePhoneCall(repairer.phone);
  }

  /// Convenience helper to open a WhatsApp chat with a [Repairer].
  Future<bool> messageRepairerWhatsApp(
    Repairer repairer, {
    String? message,
  }) {
    final defaultMessage = message ??
        'Hello ${repairer.name}, I found your profile on SortIt and would like to inquire about repair services.';
    return openWhatsApp(
      phoneNumber: repairer.phone,
      message: defaultMessage,
    );
  }

  /// Convenience helper to open directions to a [Repairer]'s location in Google Maps.
  Future<bool> navigateToRepairer(Repairer repairer) {
    return openMapDirections(
      latitude: repairer.latitude,
      longitude: repairer.longitude,
      label: repairer.name,
    );
  }
}
