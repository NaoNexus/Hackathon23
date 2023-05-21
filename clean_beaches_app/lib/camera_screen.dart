import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  final String outputPath;

  const CameraScreen({super.key, required this.outputPath});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final String ip = '192.168.0.150';
  final int port = 5000;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.max,
    );

    _initializeControllerFuture = _controller.initialize();
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureAndSaveImage() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    final Directory? externalDir = await getExternalStorageDirectory();

    if (externalDir == null) {
      return;
    }
    final String folderPath = '${externalDir.path}/Photos';
    final Directory folder = Directory(folderPath);

    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    final String fileName = '${DateTime.now()}.png';
    final String filePath = '$folderPath/$fileName';

    try {
      final image = await _controller.takePicture();

      File file = File(image.path);
      await file.copy(filePath);
      print(filePath);
    } catch (e) {
      print('Failed to capture picture: $e');
    }

    //show dialog with image preview and send button
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Preview'),
          content: Image.file(File(filePath)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                //TODO: send image to server

                Navigator.of(context).pop();
                Navigator.of(context).pop(filePath);
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Screen'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 600,
            width: double.infinity,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: _captureAndSaveImage,
            child: const Icon(Icons.camera),
          ),
        ],
      ),
    );
  }
}
