import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:sortit/firebase_options.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  static FirebaseFirestore? _customFirestore;

  /// Returns the [FirebaseFirestore] instance.
  static FirebaseFirestore get firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  /// Instance getter for [FirebaseFirestore].
  FirebaseFirestore get db => firestore;

  @visibleForTesting
  static void setFirestoreForTesting(FirebaseFirestore firestore) {
    _customFirestore = firestore;
  }

  /// Initializes Firebase using platform configuration or custom [options] if available.
  static Future<FirebaseApp> initialize({
    String? name,
    FirebaseOptions? options,
  }) async {
    return await Firebase.initializeApp(
      name: name,
      options: options ?? DefaultFirebaseOptions.currentPlatform,
    );
  }
}
