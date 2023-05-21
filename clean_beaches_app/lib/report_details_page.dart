import 'dart:io';

import 'package:clean_beaches_app/report.dart';
import 'package:flutter/material.dart';

import 'camera_screen.dart';

class ReportDetailsPage extends StatefulWidget {
  final Report report;
  const ReportDetailsPage({super.key, required this.report});

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
/*   late CameraController _controller;
  late List<CameraDescription> _cameras; */
  @override
  void initState() {
    super.initState();
    //initializeCamera();
  }

/*   Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.report.id),
            Text(widget.report.position.toString()),
            Text(widget.report.cleaned.toString()),
            Text(widget.report.date.toString()),
            Text(widget.report.details),
            //Image.asset(widget.report.imagePath),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final Directory directory = Directory('/path/to/existing/folder');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraScreen(outputPath: directory.path),
            ),
          );
        },
        backgroundColor: Colors.deepPurple,
        label: const Text('CLEAN BEACH'),
        icon: const Icon(Icons.cleaning_services),
      ),
    );
  }
}
