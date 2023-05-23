import 'dart:async';
import 'dart:developer';

import 'package:clean_beaches_app/api.dart';
import 'package:clean_beaches_app/camera_screen.dart';
import 'package:clean_beaches_app/relative_date.dart';
import 'package:clean_beaches_app/report.dart';
import 'package:clean_beaches_app/report_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();

  late Api _api;

  List<Report> _visualizedReports = [];
  late Future<List<Report>> _reports;

  late Timer _timer;

  LatLng _currentLocation = LatLng(45.345, -122.55);

  @override
  void initState() {
    _api = Api(ip: '192.168.0.150', port: 5000);
    _reports = _api.getReports();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _reports = _api.getReports();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FutureBuilder(
            future: _reports,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                log(snapshot.error.toString());
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 96,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'ERROR',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        snapshot.error?.toString() ?? '',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (snapshot.hasData) {
                _visualizedReports = snapshot.data ?? [];
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 280,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              FlutterMap(
                                mapController: _mapController,
                                options: MapOptions(
                                  slideOnBoundaries: true,
                                  center: _currentLocation,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  ),
                                  MarkerLayer(
                                    markers: _visualizedReports
                                        .map(
                                          (report) => Marker(
                                            point: report.position,
                                            width: 50,
                                            height: 50,
                                            builder: (_) => Icon(
                                              report.dateCleaned == null
                                                  ? Icons.beach_access
                                                  : Icons.flare,
                                              color: report.dateCleaned == null
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          ),
                                        )
                                        .toList(),
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
                      _visualizedReports.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (_, index) => GestureDetector(
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ReportDetailsPage(
                                        report: _visualizedReports[index],
                                      ),
                                    ),
                                  );

                                  _reports = _api.getReports();
                                },
                                child: BeachReportCard(
                                  report: _visualizedReports[index],
                                ),
                              ),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemCount: _visualizedReports.length,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.inbox_outlined,
                                      size: 96,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'NO BEACH REPORTS',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Try adding a new report',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraScreen(
                detailsField: true,
                onSubmit: (String filePath, String? details) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  String nickname = prefs.getString('nickname') ?? '';

                  Position location = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  );

                  Report report = Report(
                    id: '',
                    dateReported: DateTime.now(),
                    userReported: nickname,
                    userCleaned: '',
                    details: details!,
                    position: LatLng(location.latitude, location.longitude),
                  );

                  _api.sendReport(
                    context: context,
                    report: report,
                    dirtyImagePath: filePath,
                  );
                },
              ),
            ),
          );
        },
        label: const Text('REPORT DIRTY BEACH'),
        icon: const Icon(Icons.cleaning_services),
      ),
    );
  }

  void centerMap() async {
    await getLocation();
    _mapController.move(_currentLocation, 13);
  }

  Future<void> getLocation() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position locationData = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _currentLocation = LatLng(locationData.latitude, locationData.longitude);
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
    return Container(
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
                    const Text(
                      'Beach',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
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
                      color: report.dateCleaned != null
                          ? Colors.green.shade100
                          : Colors.red.shade100),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Icon(
                        report.dateCleaned != null
                            ? Icons.flare
                            : Icons.cleaning_services_outlined,
                        size: 18,
                        color: report.dateCleaned != null
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        report.dateCleaned != null
                            ? 'CLEANED'
                            : 'NEEDS CLEANING',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: report.dateCleaned != null
                              ? Colors.green
                              : Colors.red,
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
                  report.dateReported.relativeDateString,
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
    );
  }
}
