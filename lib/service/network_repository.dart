import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:test_12_oct_2021/auth/model/CommonModel.dart';
import 'package:test_12_oct_2021/utils/app_string.dart';
import 'package:test_12_oct_2021/utils/common/Unauthorised.dart';

Future callGetMethod(BuildContext mContext, String url) async {
  String _timezone = await FlutterNativeTimezone.getLocalTimezone();
  commonHeaders['timezone'] = _timezone;
  try {
    commonHeaders.remove('Authorization');
  } catch (e) {}
  printWrapped("baseUrl--" + APPStrings.baseUrl + url);
  printWrapped("timezone--" + _timezone);

  return await http
      .get(Uri.parse(APPStrings.baseUrl + url), headers: commonHeaders)
      .then((http.Response response) {
    return getResponse(response);
  });
}

Future callPostMethod(
    BuildContext mContext, String url, Map<String, dynamic> params) async {
  String _timezone = await FlutterNativeTimezone.getLocalTimezone();
  commonHeaders['timezone'] = _timezone;
  printWrapped("baseUrl--" + APPStrings.baseUrl + url);
  printWrapped("baseUrl--body-" + params.toString());

  return await http
      .post(Uri.parse(APPStrings.baseUrl + url),
          body: params, headers: commonHeaders)
      .then((http.Response response) {
    return getResponse(response);
  });
}

Future getResponse(Response response) async {
  final int statusCode = response.statusCode;
  printWrapped("response--statusCode--" + response.statusCode.toString());
  printWrapped("response--" + response.body);
  if (statusCode == 500) {
    return "{\"status\":\"0\",\"message\":\"${APPStrings.internalServerError}\"}";
  } else if (statusCode == 401) {
    Unauthorised streams = Unauthorised.fromJson(json.decode(response.body));
    return "{\"status\":\"0\",\"message\":\"${streams.message}\"}";
  } else if (statusCode == 400) {
    Unauthorised streams = Unauthorised.fromJson(json.decode(response.body));
    return "{\"status\":\"0\",\"message\":\"${streams.message}\"}";
  } else if (statusCode < 200 || statusCode > 404) {
    String error = response.headers['message'].toString();
    printWrapped("response--" + error);
    return "{\"status\":\"0\",\"message\":\"$error\"}";
  }
  return response.body;
}

void printWrapped(String text) {
  final pattern = new RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

Map<String, String> commonHeaders = {
  'Accept': 'application/json',
  'deviceType': Platform.isIOS ? '2' : '1',
  'lancode': 'en',
  "platform": Platform.operatingSystem,
  "appversion": "1.0.1",
};

Future<String> post(String url, {headers, body, encoding}) async {
  Map<String, String> defaultHeaders = _initHeaders(headers);

  return responseHandler(await http.get(Uri.parse(APPStrings.baseUrl + url),
      headers: defaultHeaders));
}

Map<String, String> _initHeaders(Map<String, String> headers,
    {bool isMultiPart = false}) {
  Map<String, String> defaultHeaders = Map();

  if (!isMultiPart) {
    defaultHeaders.addAll({
      'Content-type': 'application/json',
      'Accept-app-version': '1.0.0',
    });
  }

  if (headers != null) {
    defaultHeaders.addAll(headers);
    return defaultHeaders;
  }

  return defaultHeaders;
}

Future<String> responseHandler(http.Response response) async {
  final String res = response.body;
  print('RESPONSE =' +
      response.statusCode.toString() +
      " " +
      response.request.toString());
  print('RESPONSE =' + res);
  final int statusCode = response.statusCode;
  String errorMessage = "";

  if (statusCode == 200) {
    // Success

    return res;
  } else if (statusCode == 425) {
    // Success
    return res;
  } else if (statusCode == 401) {
    CommonModel errorResponse = new CommonModel();
    errorResponse.status = statusCode;
    errorResponse.message = errorMessage;

    throw (jsonEncode(errorResponse));
  } else if (statusCode == 204) {
    CommonModel errorResponse = new CommonModel();
    errorResponse.status = statusCode;
    errorResponse.message = errorMessage;

    throw (jsonEncode(errorResponse));
  } else {
    try {
      final body = json.decode(response.body);
      errorMessage = body['message'];
      CommonModel errorResponse = new CommonModel();
      errorResponse.status = statusCode;
      if (errorMessage == null || errorMessage.isEmpty) {
        errorResponse.message = APPStrings.internalServerError;
      } else {
        errorResponse.message = errorMessage;
      }
      throw (jsonEncode(errorResponse));
    } catch (e) {
      if (e.toString().isEmpty) {
        CommonModel errorResponse = new CommonModel();
        errorResponse.status = statusCode;
        errorResponse.message = APPStrings.internalServerError;
        throw (jsonEncode(errorResponse));
      } else {
        throw (e.toString());
      }
    }
  }
}
