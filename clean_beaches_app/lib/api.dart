import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class Api {
  String ip;
  int? port;

  Api({required this.ip, this.port});

  String get address => '$ip${port != null ? ':$port' : ''}';

  void beachCleanedDetails(
      BuildContext context,
      String idSpiaggia,
      String photoBase64,
      DateTime dateCleaned,
      LatLng latitude,
      LatLng longitude) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.http(address, '/api/clean_beach'))
            ..fields['id'] = idSpiaggia
            ..fields['photo'] = photoBase64
            ..fields['dateCleaned'] = dateCleaned.toString()
            ..fields['latitude'] = latitude.toString()
            ..fields['longitude'] = longitude.toString();

      await request.send();
    } catch (e) {
      log(e.toString());
    }
  }

  void dirtyBeachDetails(
      BuildContext context,
      String idSpiaggia,
      String photoBase64,
      DateTime dateReported,
      LatLng latitude,
      LatLng longitude,
      String details) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.http(address, '/api/report_beach'))
            ..fields['id'] = idSpiaggia
            ..fields['photo'] = photoBase64
            ..fields['dateReported'] = dateReported.toString()
            ..fields['latitude'] = latitude.toString()
            ..fields['longitude'] = longitude.toString()
            ..fields['details'] = details;

      await request.send();
    } catch (e) {
      log(e.toString());
    }
  }

  void postCredentials(BuildContext context, String fullName, String nickName,
      String password) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.http(address, '/api/register'))
            ..fields['fullName'] = fullName
            ..fields['nickName'] = nickName
            ..fields['password'] = encryptWithSHA256(password);

      await request.send();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String?> checkUsernameAndPassword(
      String? nicknameInInput, String? password) async {
    final response = await http.get(Uri.http(address, '/api/login', {
      'nickname': nicknameInInput,
      'password': encryptWithSHA256(password ?? "")
    }));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception('${response.statusCode} - Failed to load');
    }
  }

  String encryptWithSHA256(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    var encryptedString = digest.toString();
    return encryptedString;
  }

/*   Future<List<Report>> getReports() async {
    final response = await http.get(Uri.http(address, '/api/reports'));

    if (response.statusCode == 200) {
      List<Report> reports = [];

      for (Map<String, dynamic> report in jsonDecode(response.body)['data']) {
        reports.add(Report.fromJson(report));
      }

      return reports;
    } else {
      throw Exception('${response.statusCode} - Failed to load');
    }
  } */
}
