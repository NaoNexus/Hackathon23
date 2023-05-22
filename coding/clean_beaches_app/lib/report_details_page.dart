import 'package:clean_beaches_app/api.dart';
import 'package:clean_beaches_app/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'camera_screen.dart';

class ReportDetailsPage extends StatefulWidget {
  final Report report;
  const ReportDetailsPage({super.key, required this.report});

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  late Api _api;

  @override
  void initState() {
    _api = Api(ip: '192.168.0.150', port: 5000);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FlutterMap(
                      options: MapOptions(
                        minZoom: 11.0,
                        maxZoom: 17.0,
                        center: widget.report.position,
                        interactiveFlags: InteractiveFlag.none,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: widget.report.position,
                              width: 50,
                              height: 50,
                              builder: (_) => Icon(
                                Icons.beach_access,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
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
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.report.details,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: widget.report.dateCleaned != null
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        widget.report.dateCleaned != null
                                            ? Icons.flare
                                            : Icons.cleaning_services_outlined,
                                        size: 18,
                                        color: widget.report.dateCleaned != null
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        widget.report.dateCleaned != null
                                            ? 'CLEANED'
                                            : 'NEEDS CLEANING',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              widget.report.dateCleaned != null
                                                  ? Colors.green
                                                  : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: Colors.grey.shade500,
                                    ),
                                    Text(
                                      '${widget.report.position.latitude}N ${widget.report.position.longitude}E',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                            ),
                            child: Column(children: [
                              Image.network(
                                'http://192.168.0.150:5000/images/${widget.report.id}/dirty.${widget.report.dirtyImageExtension}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              const Text(
                                'DIRTY IMAGE',
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 1.25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              size: 16,
                              color: Colors.grey.shade500,
                            ),
                            Text(
                              widget.report.userReported,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey.shade500,
                            ),
                            Text(
                              widget.report.dateReported
                                  .toString()
                                  .split('.')[0],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (widget.report.dateCleaned != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                              ),
                              child: Column(
                                children: [
                                  Image.network(
                                    'http://192.168.0.150:5000/images/${widget.report.id}/clean.${widget.report.dirtyImageExtension}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                  const Text(
                                    'CLEAN IMAGE',
                                    style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 1.25,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_circle_outlined,
                                        size: 16,
                                        color: Colors.grey.shade500,
                                      ),
                                      Text(
                                        widget.report.userCleaned,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.grey.shade500,
                                      ),
                                      Text(
                                        widget.report.dateCleaned
                                            .toString()
                                            .split('.')[0],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.report.dateCleaned == null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(
                      detailsField: false,
                      onSubmit: (filePath, details) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        String nickname = prefs.getString('nickname') ?? '';

                        Report report = widget.report.copyWith(
                          dateCleaned: DateTime.now(),
                          userCleaned: nickname,
                        );

                        await _api.sendReport(
                          context: context,
                          report: report,
                          cleanImagePath: filePath,
                        );

                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
              label: const Text('CLEAN BEACH'),
              icon: const Icon(Icons.cleaning_services),
            )
          : const SizedBox(),
    );
  }
}
