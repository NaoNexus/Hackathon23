import 'package:clean_beaches_app/report.dart';
import 'package:latlong2/latlong.dart';

final testData = [
  Report(
    id: '12dd',
    position: LatLng(45.435651, 10.993239),
    cleaned: false,
    date: DateTime(2023, 12, 10),
    details: 'Spiaggia della morte',
    imagePath: '',
  ),
  Report(
    id: '11dd',
    position: LatLng(89.435651, 10.993239),
    cleaned: true,
    date: DateTime(2023, 11, 10),
    details: 'Spiaggia della morte 2',
    imagePath: '',
  ),
  Report(
    id: '10dd',
    position: LatLng(40.435651, 50.993239),
    cleaned: false,
    date: DateTime(2023, 10, 10),
    details: 'Spiaggia della morte 3',
    imagePath: '',
  ),
];
