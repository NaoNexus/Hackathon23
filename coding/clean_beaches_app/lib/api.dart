import 'dart:convert';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:clean_beaches_app/report.dart';
import 'package:clean_beaches_app/utilities.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  String ip;
  int? port;

  Api({required this.ip, this.port});

  String get address => '$ip${port != null ? ':$port' : ''}';

  Future<void> sendReport(
      {required BuildContext context,
      required Report report,
      String? dirtyImagePath,
      String? cleanImagePath}) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.http(address, '/api/report'))
            ..fields['id'] = report.id
            ..fields['latitude'] = report.position.latitude.toString()
            ..fields['longitude'] = report.position.longitude.toString()
            ..fields['dateReported'] = report.dateReported.toIso8601String()
            ..fields['dateCleaned'] =
                report.dateCleaned?.toIso8601String() ?? ''
            ..fields['userReported'] = report.userReported
            ..fields['userCleaned'] = report.userCleaned
            ..fields['details'] = report.details;

      if (dirtyImagePath != null && dirtyImagePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('dirtyImage', dirtyImagePath),
        );
      }

      if (cleanImagePath != null && cleanImagePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('cleanImage', cleanImagePath),
        );
      }

      request.send().then((response) {
        if (response.statusCode != 200) {
          showSnackBar(
            context: context,
            text: 'Error when sending report',
            icon: Icons.error_outline,
            backgroundColor:
                Theme.of(context).buttonTheme.colorScheme!.errorContainer,
            color: Theme.of(context).buttonTheme.colorScheme!.onErrorContainer,
          );
          return;
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> checkNickname({required String nickname}) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest('GET', Uri.http(address, '/api/check_nickname'))
            ..fields['nickname'] = nickname;

      http.Response response =
          await http.Response.fromStream(await request.send());

      return !(json.decode(response.body)['message'] ==
          'Nickname already present');
    } catch (e) {
      log(e.toString());
    }
    return true;
  }

  Future<void> register({
    required String name,
    required String surname,
    required String nickname,
    required String password,
  }) async {
    http.Response response = await http.post(
      Uri.http(address, '/api/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': name,
        'surname': surname,
        'nickname': nickname,
        'password': encryptWithSHA256(password),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<String> login({String? nickname, String? password}) async {
    final response = await http.post(
      Uri.http(address, '/api/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'nickname': nickname,
        'password': encryptWithSHA256(password ?? "")
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  String encryptWithSHA256(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    var encryptedString = digest.toString();
    return encryptedString;
  }

  Future<String> convertImageToBase64(CameraImage image) async {
    final Uint8List bytes = concatenatePlanes(image.planes);
    final String base64Image = base64Encode(bytes);

    return base64Image;
  }

  Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  Future<List<Report>> getReports() async {
    final response =
        await http.get(Uri.http(address, '/api/reports', {'images': 'false'}));

    if (response.statusCode == 200) {
      List<Report> reports = [];

      for (Map<String, dynamic> report in jsonDecode(response.body)['data']) {
        reports.add(Report.fromJson(report));
      }

      return reports;
    } else {
      throw Exception('${response.statusCode} - Failed to load');
    }
  }
}
