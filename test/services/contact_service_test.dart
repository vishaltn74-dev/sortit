import 'package:flutter_test/flutter_test.dart';
import 'package:sortit/services/contact_service.dart';

void main() {
  group('ContactService formatting helpers', () {
    test('sanitizes telephone numbers correctly', () {
      expect(ContactService.sanitizePhoneNumber('+91 98765-43210'), '+919876543210');
      expect(ContactService.sanitizePhoneNumber('(080) 1234-5678'), '08012345678');
      expect(ContactService.sanitizePhoneNumber('9876543210'), '9876543210');
    });

    test('formats phone numbers for WhatsApp wa.me API', () {
      // 10-digit number should have 91 prepended
      expect(ContactService.formatPhoneForWhatsApp('9876543210'), '919876543210');
      // Number with +91 should drop the +
      expect(ContactService.formatPhoneForWhatsApp('+91 98765 43210'), '919876543210');
      // Number with leading zero
      expect(ContactService.formatPhoneForWhatsApp('09876543210'), '919876543210');
      // Full international number (e.g., US)
      expect(ContactService.formatPhoneForWhatsApp('+1 415 555 2671'), '14155552671');
    });
  });
}
