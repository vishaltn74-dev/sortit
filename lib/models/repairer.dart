import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Repairer {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int jobsCompleted;
  final int inspectionFee;
  final double latitude;
  final double longitude;
  final String phone;
  final List<String> services;

  Repairer({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.jobsCompleted,
    required this.inspectionFee,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.services,
  });

  factory Repairer.fromMap(Map<String, dynamic> map, {String? id}) {
    return Repairer(
      id: id ?? (map['id'] as String? ?? ''),
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      jobsCompleted: (map['jobsCompleted'] as num?)?.toInt() ?? 0,
      inspectionFee: (map['inspectionFee'] as num?)?.toInt() ?? 0,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      phone: map['phone'] as String? ?? '',
      services: (map['services'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
    );
  }

  factory Repairer.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, [
    SnapshotOptions? options,
  ]) {
    final data = snapshot.data();
    return Repairer.fromMap(data ?? <String, dynamic>{}, id: snapshot.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'rating': rating,
      'jobsCompleted': jobsCompleted,
      'inspectionFee': inspectionFee,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'services': services,
    };
  }

  Map<String, dynamic> toFirestore([SetOptions? options]) => toMap();

  Repairer copyWith({
    String? id,
    String? name,
    String? category,
    double? rating,
    int? jobsCompleted,
    int? inspectionFee,
    double? latitude,
    double? longitude,
    String? phone,
    List<String>? services,
  }) {
    return Repairer(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      jobsCompleted: jobsCompleted ?? this.jobsCompleted,
      inspectionFee: inspectionFee ?? this.inspectionFee,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      services: services ?? List<String>.from(this.services),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Repairer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          category == other.category &&
          rating == other.rating &&
          jobsCompleted == other.jobsCompleted &&
          inspectionFee == other.inspectionFee &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          phone == other.phone &&
          listEquals(services, other.services);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      category.hashCode ^
      rating.hashCode ^
      jobsCompleted.hashCode ^
      inspectionFee.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      phone.hashCode ^
      Object.hashAll(services);

  @override
  String toString() {
    return 'Repairer(id: $id, name: $name, category: $category, rating: $rating, jobsCompleted: $jobsCompleted, inspectionFee: $inspectionFee, latitude: $latitude, longitude: $longitude, phone: $phone, services: $services)';
  }
}
