import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../main/utils/Common.dart';
import '../../main/utils/Constants.dart';
import 'RestApis.dart';

Map<String, String> buildHeaderTokens() {
  Map<String, String> header = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    HttpHeaders.cacheControlHeader: 'no-cache',
    HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
  };
  if (!getStringAsync(USER_TOKEN).isEmptyOrNull) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${getStringAsync(USER_TOKEN)}');
  }
  log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$mBaseUrl$endPoint');

  log('URL: ${url.toString()}');

  return url;
}

Future<Response> buildHttpResponse(String endPoint, {HttpMethod method = HttpMethod.GET, Map? request}) async {
  if (await isNetworkAvailable()) {
    var headers = buildHeaderTokens();
    Uri url = buildBaseUrl(endPoint);

    try {
      Response response;

      if (method == HttpMethod.POST) {
        log('Request: $request');

        response = await http.post(url, body: jsonEncode(request), headers: headers).timeout(20.seconds, onTimeout: () => throw 'Timeout');
      } else if (method == HttpMethod.DELETE) {
        response = await delete(url, headers: headers).timeout(20.seconds, onTimeout: () => throw 'Timeout');
      } else if (method == HttpMethod.PUT) {
        response = await put(url, body: jsonEncode(request), headers: headers).timeout(20.seconds, onTimeout: () => throw 'Timeout');
      } else {
        response = await get(url, headers: headers).timeout(20.seconds, onTimeout: () => throw 'Timeout');
      }

      log('Response ($method): ${url.toString()} ${response.statusCode} ${response.body}');

      return response;
    } catch (e) {
      throw language.errorSomethingWentWrong;
    }
  } else {
    throw language.errorInternetNotAvailable;
  }
}

//region Common

Future handleResponse(Response response, [bool? avoidTokenError]) async {
  if (!await isNetworkAvailable()) {
    throw language.errorInternetNotAvailable;
  }
  if (response.statusCode == 401) {
    if (appStore.isLoggedIn) {
      Map req = {
        'email': appStore.userEmail,
        'password': getStringAsync(USER_PASSWORD),
      };

      await logInApi(req).then((value) {
        throw '';
      }).catchError((e) {
        throw TokenException(e);
      });
    } else {
      throw '';
    }
  }

  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    try {
      var body = jsonDecode(response.body);
      throw parseHtmlString(body['message']);
    } on Exception catch (e) {
      log(e);
      throw language.errorSomethingWentWrong;
    }
  }
}

enum HttpMethod { GET, POST, DELETE, PUT }

class TokenException implements Exception {
  final String message;

  const TokenException([this.message = ""]);

  String toString() => "FormatException: $message";
}
