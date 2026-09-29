import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sortit/models/booking.dart';
import 'package:sortit/services/firebase_service.dart';

class BookingService {
  final FirebaseFirestore? _customFirestore;

  BookingService({FirebaseFirestore? firestore})
      : _customFirestore = firestore;

  static const String collectionName = 'bookings';

  /// Creates a new Firestore booking document.
  ///
  /// Stores:
  /// - `repairerId`
  /// - `repairerName`
  /// - `category`
  /// - `issue`
  /// - `date`
  /// - `time`
  /// - `latitude`
  /// - `longitude`
  /// - `inspectionFee`
  /// - `status`
  /// - `createdAt`
  ///
  /// Sets `status = "confirmed"` and uses `FieldValue.serverTimestamp()` for `createdAt`.
  /// Returns the created [Booking] object with its assigned Firestore document ID,
  /// or `null` if an error occurs.
  static Future<Booking?> createBooking(
    Booking booking, {
    FirebaseFirestore? firestore,
  }) async {
    try {
      final db = firestore ?? FirebaseService.firestore;
      final docRef = booking.id.trim().isNotEmpty
          ? db.collection(collectionName).doc(booking.id.trim())
          : db.collection(collectionName).doc();

      final data = <String, dynamic>{
        'id': docRef.id,
        'repairerId': booking.repairerId,
        'repairerName': booking.repairerName,
        'category': booking.category,
        'issue': booking.issue,
        'date': booking.date,
        'time': booking.time,
        'latitude': booking.latitude,
        'longitude': booking.longitude,
        'inspectionFee': booking.inspectionFee,
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await docRef.set(data);

      return booking.copyWith(
        id: docRef.id,
        status: 'confirmed',
      );
    } catch (e, stackTrace) {
      debugPrint('BookingService.createBooking failed: $e\n$stackTrace');
      return null;
    }
  }

  /// Retrieves a single [Booking] from Firestore by document [id].
  /// Returns `null` if the document does not exist, data is null, or an error occurs.
  static Future<Booking?> getBooking(
    String id, {
    FirebaseFirestore? firestore,
  }) async {
    try {
      final trimmedId = id.trim();
      if (trimmedId.isEmpty) {
        return null;
      }

      final db = firestore ?? FirebaseService.firestore;
      final docSnapshot =
          await db.collection(collectionName).doc(trimmedId).get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return null;
      }

      return Booking.fromFirestore(docSnapshot);
    } catch (e, stackTrace) {
      debugPrint(
        'BookingService.getBooking failed for id "$id": $e\n$stackTrace',
      );
      return null;
    }
  }

  /// Convenience helper to create a booking directly from field values.
  static Future<Booking?> createBookingFromDetails({
    required String repairerId,
    required String repairerName,
    required String category,
    required String issue,
    required String date,
    required String time,
    required double latitude,
    required double longitude,
    required int inspectionFee,
    String status = 'confirmed',
    DateTime? createdAt,
    FirebaseFirestore? firestore,
  }) {
    return createBooking(
      Booking(
        id: '',
        repairerId: repairerId,
        repairerName: repairerName,
        category: category,
        issue: issue,
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        inspectionFee: inspectionFee,
        status: status,
        createdAt: createdAt ?? DateTime.now(),
      ),
      firestore: firestore,
    );
  }

  /// Instance method helper for creating a booking.
  Future<Booking?> addBooking(Booking booking) =>
      createBooking(booking, firestore: _customFirestore);

  /// Instance method helper for fetching a booking by id.
  Future<Booking?> fetchBooking(String id) =>
      getBooking(id, firestore: _customFirestore);
}
