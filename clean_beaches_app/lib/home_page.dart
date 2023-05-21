import 'package:clean_beaches_app/relative_date.dart';
import 'package:clean_beaches_app/report.dart';
import 'package:clean_beaches_app/report_details_page.dart';
import 'package:clean_beaches_app/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();

  List<Report> _visualizedReports = [];

  LatLng _currentLocation = LatLng(45.345, -122.55);

  @override
  void initState() {
    _visualizedReports = testData;
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          slideOnBoundaries: true,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                        ],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: InkWell(
                            child: GestureDetector(
                              onTap: () => centerMap(),
                              child: const Icon(
                                Icons.my_location_outlined,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                flex: 3,
                child: ListView.separated(
                  itemBuilder: (_, index) => BeachReportCard(
                    report: _visualizedReports[index],
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemCount: _visualizedReports.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void centerMap() async {
    await getLocation();
    _mapController.move(_currentLocation, 13);
  }

  Future<void> getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    _currentLocation =
        LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
  }
}

class BeachReportCard extends StatelessWidget {
  const BeachReportCard({
    Key? key,
    required this.report,
  }) : super(key: key);

  final Report report;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ReportDetailsPage(
            report: report,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.id,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        report.details,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: report.cleaned
                            ? Colors.green.shade100
                            : Colors.red.shade100),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Icon(
                          report.cleaned
                              ? Icons.flare
                              : Icons.cleaning_services_outlined,
                          size: 18,
                          color: report.cleaned ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          report.cleaned ? 'CLEANED' : 'NEEDS CLEANING',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: report.cleaned ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    report.date.relativeDateString,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
