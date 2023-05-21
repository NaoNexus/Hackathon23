import 'package:latlong2/latlong.dart';

class Report {
  final String id;
  final LatLng position;
  final String details, userReported, userCleaned;
  final String dirtyImageExtension, cleanImageExtension;
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
    required this.dirtyImageExtension,
    required this.cleanImageExtension,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json['id'],
        position: position,
        cleaned: cleaned,
        date: date,
        details: details,
        imagePath: imagePath,
      ); */
}
