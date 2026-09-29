import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String icon;

  Category({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory Category.fromMap(Map<String, dynamic> map, {String? id}) {
    return Category(
      id: id ?? (map['id'] as String? ?? ''),
      name: map['name'] as String? ?? '',
      icon: map['icon'] as String? ?? '',
    );
  }

  factory Category.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, [
    SnapshotOptions? options,
  ]) {
    final data = snapshot.data();
    return Category.fromMap(data ?? <String, dynamic>{}, id: snapshot.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  Map<String, dynamic> toFirestore([SetOptions? options]) => toMap();

  Category copyWith({
    String? id,
    String? name,
    String? icon,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          icon == other.icon;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ icon.hashCode;

  @override
  String toString() => 'Category(id: $id, name: $name, icon: $icon)';
}
