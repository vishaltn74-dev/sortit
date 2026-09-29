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
}
