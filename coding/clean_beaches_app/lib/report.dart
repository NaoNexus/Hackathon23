import 'package:latlong2/latlong.dart';

class Report {
  final String id;
  final LatLng position;
  final String details, userReported, userCleaned;
  final DateTime dateReported;
  final DateTime? dateCleaned;

  const Report({
    required this.id,
    required this.position,
    required this.dateReported,
    this.dateCleaned,
    required this.userCleaned,
    required this.userReported,
    required this.details,
  });

  Report copyWith({
    String? id,
    LatLng? position,
    DateTime? dateReported,
    DateTime? dateCleaned,
    String? userReported,
    String? userCleaned,
    String? details,
  }) =>
      Report(
        id: id ?? this.id,
        position: position ?? this.position,
        dateReported: dateReported ?? this.dateReported,
        dateCleaned: dateCleaned ?? this.dateCleaned,
        userReported: userReported ?? this.userReported,
        userCleaned: userCleaned ?? this.userCleaned,
        details: details ?? this.details,
      );

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json['id'],
        position: LatLng(json['latitude'] ?? 0, json['longitude'] ?? 0),
        dateCleaned: DateTime.tryParse(json['dateCleaned']),
        dateReported: DateTime.parse(json['dateReported']),
        userCleaned: json['userCleaned'] ?? '',
        userReported: json['userReported'],
        details: json['details'],
      );
}
