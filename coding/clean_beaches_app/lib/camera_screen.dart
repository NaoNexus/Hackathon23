import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
    this.detailsField = false,
    required this.onSubmit,
  });

  final bool detailsField;

  final Function(String filePath, String? details) onSubmit;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;

  late Future<void> _initializeControllerFuture;

  final TextEditingController _detailsController = TextEditingController();

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
    _detailsController.dispose();
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

      image.saveTo(filePath);

      if (widget.detailsField) {
        widget.onSubmit(filePath, _detailsController.text);
        Navigator.pop(context);
        return;
      }

      widget.onSubmit(filePath, null);

      Navigator.pop(context);
    } catch (e) {
      log('Failed to capture picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  if (widget.detailsField) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      child: TextFormField(
                        controller: _detailsController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                          labelText: 'Details',
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
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
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _captureAndSaveImage(),
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        child: const Icon(Icons.camera_outlined),
      ),
    );
  }
}
