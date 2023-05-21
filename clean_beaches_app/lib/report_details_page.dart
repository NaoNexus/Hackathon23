import 'dart:io';

import 'package:clean_beaches_app/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'camera_screen.dart';

class ReportDetailsPage extends StatefulWidget {
  final Report report;
  const ReportDetailsPage({super.key, required this.report});

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  @override
  void initState() {
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
          child: Column(
            children: [
              Flexible(
                flex: 1,
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
              Flexible(
                flex: 4,
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
                                  widget.report.id,
                                  style: const TextStyle(
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
                                      color: widget.report.dateCleaned != null
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Image.network(
                            'http://192.168.0.150/images/${widget.report.id}/dirty.${widget.report.dirtyImageExtension}')
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.report.dateCleaned == null
          ? FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Is the beach fully cleaned?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            final Directory directory =
                                Directory('/path/to/existing/folder');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CameraScreen(outputPath: directory.path),
                              ),
                            );
                            //Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              label: const Text('CLEAN BEACH'),
              icon: const Icon(Icons.cleaning_services),
            )
          : const SizedBox(),
    );
  }
}
