import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:times_now/constants.dart';
import 'package:http/http.dart' as http;
import 'package:times_now/network/base_response_model.dart';
import 'package:times_now/network/loading_notifier.dart';

enum HttpMethod { get, post, put, delete, patch }

class ApiService {
  ApiService._privateConstructor();
  static final ApiService _instance = ApiService._privateConstructor();
  factory ApiService() {
    return _instance;
  }

  final String apiUrl = "${Constants.baseUrl}/api/v1/get-mealcategories";
  // final String API_URL = '${BASE_URL}api/v1';

  BuildContext? context;

  http.MultipartRequest getMultipartRequest(
    final String url, {
    bool isAddCustomerToUrl = true,
    HttpMethod method = HttpMethod.post,
  }) {
    String urlLocal = getApiUrl(url);
    return http.MultipartRequest(
        method.name.toUpperCase(), Uri.parse(urlLocal));
  }

  Future<T?> execute<T extends BaseApiResponse>(
      final String url, T responseInstance,
      {Map? params,
      Map? queryParams,
      bool isJsonBody = true,
      HttpMethod method = HttpMethod.post,
      bool showSuccessAlert = false,
      bool isTokenRequired = true,
      String? token,
      LoadingNotifer? loadingNotifer,
      // LoadingNotifer? loadingNotifer,
      http.MultipartRequest? multipartRequest,
      bool isThrowExc = false}) async {
    if (await checkInternet() == false) {
      if (isThrowExc) {
        return Future.error("No Internet Connetction");
      }
      showToast("No Internet Connetction");
      return null;
    }
    loadingNotifer?.isLoading = true;
    String localUrl = getApiUrl(url);
    final queryParamsValues =
        queryParams?.values.where((element) => element != null);
    if (queryParamsValues != null && queryParamsValues.isNotEmpty) {
      queryParams!.removeWhere((key, value) => value == null);
      final queryParamsStr = queryParams.entries.map((entry) {
        final key = Uri.encodeComponent(entry.key);
        final value = Uri.encodeComponent(entry.value.toString());
        return '$key=$value';
      }).join('&');

      localUrl += '${localUrl.contains('?') ? '&' : '?'}$queryParamsStr';
    }
    params ??= {};

    params.removeWhere((key, value) => value == null);

    final header = <String, String>{};

    // final token = await SharedPreferenceUtils().getString(SharedPreferenceUtils.token);
    // if (token != null && token.trim().isNotEmpty) {
    //   header['Authorization'] = 'Bearer $token';
    // }

    if (isJsonBody && params.isNotEmpty) {
      header['content-type'] = 'application/json';
    }
    // header['Access-Control-Allow-Origin'] = '*';
    // header['Accept'] = '*/*';

    printWrapped("api headers: $header");

    Uri uri = Uri.parse(localUrl);
    http.Response resp;
    print('0000000000  ======  : $uri');
    try {
      if (multipartRequest != null) {
        multipartRequest.headers.addAll(header);
        // multipartRequest.fields.removeWhere((key, value) => value == null);
        _printMultipartParameters(multipartRequest);
        var response = await multipartRequest.send();
        resp = await http.Response.fromStream(response);
      } else {
        debugPrint("api url: $localUrl \n params: $params");
        final postBody =
            (isJsonBody && params.isNotEmpty) ? json.encode(params) : params;

        switch (method) {
          case HttpMethod.get:
            resp = await http.get(uri, headers: header);
            break;
          case HttpMethod.post:
            resp = await http.post(uri, headers: header, body: postBody);
            break;
          case HttpMethod.put:
            resp = await http.put(uri, headers: header, body: postBody);
            break;
          case HttpMethod.patch:
            resp = await http.patch(uri, headers: header, body: postBody);
            break;
          case HttpMethod.delete:
            resp = await http.delete(uri, headers: header, body: postBody);
            break;
          default:
            throw ArgumentError('Invalid HTTP method: $method');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      debugPrint("Unable to connect to server!");
      showToast("Unable to connect to server!");
      if (isThrowExc) {
        return Future.error("Unable to connect to server!");
      }
      return null;
    }

    String response = resp.body.trim().isNotEmpty ? resp.body : "{}";
    printWrapped(" $url - code = ${resp.statusCode} - response: $response");

    dynamic responseJson;
    try {
      responseJson = json.decode(response);
    } catch (e) {
      debugPrint('json decode exception $e');
    }

    if (responseJson == null) {
      if (isThrowExc) {
        return Future.error("Something went wrong!");
      }

      showToast("Something went wrong!");
      return null;
    }

    String? message;
    if (responseJson['message'] is String) {
      message = responseJson['message'];
    }

    final successCode = [200, 201, 202, 203, 204];
    // bool isSuccess = responseJson['success'] ?? responseJson['status'] ?? true;
    bool isSuccess = successCode.contains(resp.statusCode);
    if (showSuccessAlert && context != null && isSuccess) {
      showAlert(message);
    } else {
      showToast(message);
    }
    loadingNotifer?.isLoading = false;

    final responseModel = ((responseInstance)).fromJson(responseJson);
    responseModel.statusCode = resp.statusCode;
    responseModel.success = isSuccess;
    // return fromJsonToModel<T>(responseJson);
    return responseModel as T;
  }

  String getApiUrl(final String url) {
    String localUrl = url;
    if (!url.startsWith("http")) {
      // _url = "$API_URL${isAddCustomerToUrl ? 'customerapp/' : ''}$url";
      localUrl = "$apiUrl$url";
    }
    return localUrl;
  }

  void _printMultipartParameters(http.MultipartRequest multipartRequest) {
    debugPrint(
        "mulipart url: ${multipartRequest.url.toString()} \n params: ${multipartRequest.fields}");
    for (var element in multipartRequest.files) {
      debugPrint(
          "params mulipart file: ${element.field} : ${element.filename} contentType: ${element.contentType}");
    }
  }

  void printWrapped(String text) {
    debugPrint('Response: ');
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }

  Future<bool> checkInternet() async {
    if (kIsWeb) {
      return await _hasNetworkWeb();
    } else {
      return await _hasNetworkMobile();
    }
  }

  Future<bool> _hasNetworkWeb() async {
    try {
      final result = await http.get(Uri.parse('google.com'));
      if (result.statusCode == 200) return true;
    } on SocketException catch (_) {}
    return false;
  }

  Future<bool> _hasNetworkMobile() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {}
    return false;
  }

  void showToast(String? message) {
    if (message == null ||
        message.trim().isEmpty ||
        context == null ||
        message.trim().toLowerCase() == 'success') {
      return;
    }
    // try {
    //   Fluttertoast.cancel();
    // } catch (e) {}
    // Fluttertoast.showToast(
    //     msg: message,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.black87,
    //     textColor: Colors.white,
    //     fontSize: 16.0);

    try {
      // ignore: empty_catches
    } catch (e) {}

    Get.snackbar('', message);
  }

  void showAlert(String? message) {
    if (context == null || message == null || message.trim().isEmpty) {
      return;
    }
    try {
      showDialog(
        context: context!,
        builder: (context) => AlertDialog(
          title: const Text("Message"),
          content: Text(message),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'))
          ],
        ),
      );
    } catch (e) {
      debugPrint('ApiService showAlert error:${e.toString()}');
    }
  }

  // List<K> _fronJsonToList<K>(List? jsonList) {
  //   List<K> output = List.empty();
  //   if (jsonList != null) {
  //     for (Map<String, dynamic> json in jsonList) {
  //       output.add(fromJsonToModel(json));
  //     }
  //   }
  //   return output;
  // }
}
