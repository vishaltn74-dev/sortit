import 'package:flutter_test/flutter_test.dart';
import 'package:sortit/models/booking.dart';
import 'package:sortit/services/booking_service.dart';

void main() {
  group('BookingService Tests', () {
    final sampleBooking = Booking(
      id: 'test_book_1',
      repairerId: 'rep_1',
      repairerName: 'John Doe',
      category: 'Plumbing',
      issue: 'Pipe Leak',
      date: '2026-09-30',
      time: '10:00 AM',
      latitude: 12.9716,
      longitude: 77.5946,
      inspectionFee: 50,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    test('getBooking returns null on empty id', () async {
      final result = await BookingService.getBooking('');
      expect(result, isNull);
    });

    test('getBooking returns null on whitespace id', () async {
      final result = await BookingService.getBooking('   ');
      expect(result, isNull);
    });

    test('getBooking handles Firestore errors cleanly and returns null',
        () async {
      final result = await BookingService.getBooking('non_existent_id');
      expect(result, isNull);
    });

    test(
        'createBooking handles Firestore errors cleanly and returns null when not connected',
        () async {
      final result = await BookingService.createBooking(sampleBooking);
      expect(result, isNull);
    });

    test('createBookingFromDetails handles errors cleanly and returns null',
        () async {
      final result = await BookingService.createBookingFromDetails(
        repairerId: 'rep_1',
        repairerName: 'John Doe',
        category: 'Plumbing',
        issue: 'Pipe Leak',
        date: '2026-09-30',
        time: '10:00 AM',
        latitude: 12.9716,
        longitude: 77.5946,
        inspectionFee: 50,
      );
      expect(result, isNull);
    });

    test('instance helper methods work as expected', () async {
      final service = BookingService();
      final getResult = await service.fetchBooking('');
      expect(getResult, isNull);

      final addResult = await service.addBooking(sampleBooking);
      expect(addResult, isNull);
    });
  });
}
