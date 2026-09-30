import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sortit/models/repairer.dart';
import 'package:sortit/services/firebase_service.dart';

class RepairerService {
  final FirebaseFirestore? _customFirestore;

  RepairerService({FirebaseFirestore? firestore})
      : _customFirestore = firestore;

  static const String collectionName = 'repairers';

  /// Reads repairers from Firestore filtered by [category].
  /// Returns a clean `List<Repairer>`, or empty list if an error occurs.
  static Future<List<Repairer>> getRepairersByCategory(
    String category, {
    FirebaseFirestore? firestore,
  }) async {
    try {
      final trimmedCategory = category.trim();
      if (trimmedCategory.isEmpty) {
        return <Repairer>[];
      }

      final db = firestore ?? FirebaseService.firestore;
      final querySnapshot = await db
          .collection(collectionName)
          .where('category', isEqualTo: trimmedCategory)
          .get();

      return querySnapshot.docs
          .map((doc) => Repairer.fromFirestore(doc))
          .toList();
    } catch (e, stackTrace) {
      debugPrint(
        'RepairerService.getRepairersByCategory failed for category "$category": $e\n$stackTrace',
      );
      return <Repairer>[];
    }
  }

  /// Retrieves a single [Repairer] from Firestore by document [id].
  /// Returns `null` if the document does not exist, data is null, or an error occurs.
  static Future<Repairer?> getRepairerById(
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

      return Repairer.fromFirestore(docSnapshot);
    } catch (e, stackTrace) {
      debugPrint(
        'RepairerService.getRepairerById failed for id "$id": $e\n$stackTrace',
      );
      return null;
    }
  }

  /// Instance method helper for fetching repairers by category.
  Future<List<Repairer>> fetchRepairersByCategory(String category) =>
      getRepairersByCategory(category, firestore: _customFirestore);

  /// Instance method helper for fetching a repairer by id.
  Future<Repairer?> fetchRepairerById(String id) =>
      getRepairerById(id, firestore: _customFirestore);
}
