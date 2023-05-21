import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class Api {
  String ip;
  int? port;

  Api({required this.ip, this.port});

  String get address => '$ip${port != null ? ':$port' : ''}';

  void beachCleanedDetails({
    required String id,
    required String photoBase64,
    required DateTime dateCleaned,
    required LatLng latitude,
    required LatLng longitude,
  }) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.http(address, '/api/clean_beach'))
            ..fields['id'] = id
            ..fields['photo'] = photoBase64
            ..fields['dateCleaned'] = dateCleaned.toString()
            ..fields['latitude'] = latitude.toString()
            ..fields['longitude'] = longitude.toString();

      await request.send();
    } catch (e) {
      log(e.toString());
    }
  }

  void dirtyBeachDetails({
    required String id,
    required String photoBase64,
    required DateTime dateReported,
    required LatLng latitude,
    required LatLng longitude,
    required String details,
  }) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.http(address, '/api/report_beach'))
            ..fields['id'] = id
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
        'password': password,
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
