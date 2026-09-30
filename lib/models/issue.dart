import 'package:cloud_firestore/cloud_firestore.dart';

class Issue {
  final String id;
  final String categoryId;
  final String name;

  Issue({
    required this.id,
    required this.categoryId,
    required this.name,
  });

  factory Issue.fromMap(Map<String, dynamic> map, {String? id}) {
    return Issue(
      id: id ?? (map['id'] as String? ?? ''),
      categoryId: map['categoryId'] as String? ?? '',
      name: map['name'] as String? ?? '',
    );
  }

  factory Issue.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, [
    SnapshotOptions? options,
  ]) {
    final data = snapshot.data();
    return Issue.fromMap(data ?? <String, dynamic>{}, id: snapshot.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
    };
  }

  Map<String, dynamic> toFirestore([SetOptions? options]) => toMap();

  Issue copyWith({
    String? id,
    String? categoryId,
    String? name,
  }) {
    return Issue(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Issue &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          categoryId == other.categoryId &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ categoryId.hashCode ^ name.hashCode;

  @override
  String toString() => 'Issue(id: $id, categoryId: $categoryId, name: $name)';
}
