import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String repairerId;
  final String repairerName;
  final String category;
  final String issue;
  final String date;
  final String time;
  final double latitude;
  final double longitude;
  final int inspectionFee;
  final String status;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.repairerId,
    required this.repairerName,
    required this.category,
    required this.issue,
    required this.date,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.inspectionFee,
    required this.status,
    required this.createdAt,
  });

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is DateTime) {
      return value;
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    } else if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.now();
  }

  factory Booking.fromMap(Map<String, dynamic> map, {String? id}) {
    return Booking(
      id: id ?? (map['id'] as String? ?? ''),
      repairerId: map['repairerId'] as String? ?? '',
      repairerName: map['repairerName'] as String? ?? '',
      category: map['category'] as String? ?? '',
      issue: map['issue'] as String? ?? '',
      date: map['date'] as String? ?? '',
      time: map['time'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      inspectionFee: (map['inspectionFee'] as num?)?.toInt() ?? 0,
      status: map['status'] as String? ?? 'pending',
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  factory Booking.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, [
    SnapshotOptions? options,
  ]) {
    final data = snapshot.data();
    return Booking.fromMap(data ?? <String, dynamic>{}, id: snapshot.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'repairerId': repairerId,
      'repairerName': repairerName,
      'category': category,
      'issue': issue,
      'date': date,
      'time': time,
      'latitude': latitude,
      'longitude': longitude,
      'inspectionFee': inspectionFee,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Map<String, dynamic> toFirestore([SetOptions? options]) => toMap();

  Booking copyWith({
    String? id,
    String? repairerId,
    String? repairerName,
    String? category,
    String? issue,
    String? date,
    String? time,
    double? latitude,
    double? longitude,
    int? inspectionFee,
    String? status,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      repairerId: repairerId ?? this.repairerId,
      repairerName: repairerName ?? this.repairerName,
      category: category ?? this.category,
      issue: issue ?? this.issue,
      date: date ?? this.date,
      time: time ?? this.time,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      inspectionFee: inspectionFee ?? this.inspectionFee,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Booking &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          repairerId == other.repairerId &&
          repairerName == other.repairerName &&
          category == other.category &&
          issue == other.issue &&
          date == other.date &&
          time == other.time &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          inspectionFee == other.inspectionFee &&
          status == other.status &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      repairerId.hashCode ^
      repairerName.hashCode ^
      category.hashCode ^
      issue.hashCode ^
      date.hashCode ^
      time.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      inspectionFee.hashCode ^
      status.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'Booking(id: $id, repairerId: $repairerId, repairerName: $repairerName, category: $category, issue: $issue, date: $date, time: $time, latitude: $latitude, longitude: $longitude, inspectionFee: $inspectionFee, status: $status, createdAt: $createdAt)';
  }
}
