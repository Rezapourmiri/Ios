import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:optima_soft/helpers/environment_helpers.dart';
import 'package:optima_soft/models/refresh_token_output/refresh_token_output.dart';
import 'package:optima_soft/services/shared-preference-service.dart';

class HttpService {
  Future<Response?> postData(
      String url, dynamic data, String? token, bool? anonymous) async {
    anonymous ??= false;
    var timezone = await SharedPreferenceService().getTimeZone();
    if (anonymous == false) {
      var newToken = token ?? await getToken();
      if (newToken != null) {
        http.Response response = await http.post(
          Uri.parse(url),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $newToken",
            HttpHeaders.contentTypeHeader: "application/json",
            "timezone": timezone
          },
          body: jsonEncode(data),
        );
        return response;
      }
    } else {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "timezone": timezone
        },
        body: jsonEncode(data),
      );
      return response;
    }

    return null;
  }

  Future<Response?> get(
      String url, dynamic data, String? token, bool? anonymous) async {
    anonymous ??= false;
    var timezone = await SharedPreferenceService().getTimeZone();
    if (anonymous == false) {
      var newToken = token ?? await getToken();
      if (newToken != null) {
        http.Response response = await http.get(
          Uri.parse(url),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $newToken",
            HttpHeaders.contentTypeHeader: "application/json",
            "timezone": timezone
          },
        );
        return response;
      }
    } else {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "timezone": timezone
        },
      );
      return response;
    }

    return null;
  }

  Future<String?> getToken() async {
    String refreshToken = await SharedPreferenceService().getRefreshToken();
    String token = await SharedPreferenceService().getToken();
    final String url =
        "${await EnvironmentHelpers.getCurrentBackend()}/api/Login/RefreshToken";
    final String timeZone = await SharedPreferenceService().getTimeZone();
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        "timezone": timeZone,
        "Accept": "application/json",
        "Accept-Language": "en"
      },
      body: '{"refreshToken": "$refreshToken","token":"$token"}',
    );
    if (response.statusCode == 200) {
      var body = RefreshTokenOutput.fromJson(response.body);
      await SharedPreferenceService().saveToken(body.token ?? "");
      await SharedPreferenceService().saveExraInfo(body.extraInfo ?? []);
      return body.token;
    } else {
      return null;
    }
  }
}
