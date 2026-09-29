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
}
