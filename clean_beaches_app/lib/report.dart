import 'package:latlong2/latlong.dart';

class Report {
  final String id;
  final LatLng position;
  final String details;
  final String imagePath;
  final DateTime date;
  final bool cleaned;

  const Report({
    required this.id,
    required this.position,
    required this.cleaned,
    required this.date,
    required this.details,
    required this.imagePath,
  });
/* 
  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json['id'],
        position: position,
        cleaned: cleaned,
        date: date,
        details: details,
        imagePath: imagePath,
      ); */
}
