import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

enum NetworkResponseStatus {
  success,
  failed,
  tokenExpire,
  waiting
}

class NetworkResponse {
  final Map<String, dynamic> body;
  final NetworkResponseStatus status;

  const NetworkResponse({  required this.body, required this.status });

  factory NetworkResponse.fromBackend(body, int status) {
    NetworkResponseStatus apiResponseStatus = NetworkResponseStatus.success;
    if (status != 200 && status != 201) {
      apiResponseStatus = NetworkResponseStatus.failed;
    }
    return NetworkResponse(body: body, status: apiResponseStatus);
  }

  factory NetworkResponse.tokenExpire() {
    return const NetworkResponse(body: {}, status: NetworkResponseStatus.tokenExpire);
  }

  factory NetworkResponse.deleteResponse(int status) {
    NetworkResponseStatus apiResponseStatus = NetworkResponseStatus.success;
    if (status != 204) {
      apiResponseStatus = NetworkResponseStatus.failed;
    }
    return NetworkResponse(body: {}, status: apiResponseStatus);
  }
}

class NetworkService {
  /// decode http response to string
  Future<String> transformHttpResponse(HttpClientResponse response) {
    final completer = Completer<String>();
    final contents = StringBuffer();
    response.transform(utf8.decoder).listen((data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  Future<NetworkResponse> fetch(String endPoint, String accessToken) async {
    HttpClient client = HttpClient();
    HttpClientRequest request = await client.openUrl('get', Uri.parse(endPoint));
    request.headers.set('Authorization', "Bearer $accessToken");
    request.headers.contentType = ContentType("application", "json", charset: "utf-8");
    HttpClientResponse response = await request.close();
    String decodedStringResponse = await transformHttpResponse(response);
    var decodedJsonResponse = json.decode(decodedStringResponse);

    return NetworkResponse.fromBackend(decodedJsonResponse, response.statusCode);
  }

  Future<NetworkResponse> postData(String endPoint, String accessToken, Map<String, dynamic> body) async {

    var response = await http.post(
        Uri.parse(endPoint),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': "Bearer $accessToken"
      },
      body: json.encode(body)
    );

    Map<String, dynamic> decodedResponse = await json.decode(utf8.decode(response.bodyBytes));

    return NetworkResponse.fromBackend(decodedResponse, response.statusCode);
  }

  Future<NetworkResponse> deleteData(String endPoint, String accessToken) async {
    var response = await http.delete(
        Uri.parse(endPoint),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': "Bearer $accessToken"
        }
    );

    return NetworkResponse.deleteResponse(response.statusCode);
  }

  Future<NetworkResponse> putData(String endPoint, String accessToken, Map<String, dynamic> body) async {

    var response = await http.put(
        Uri.parse(endPoint),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': "Bearer $accessToken"
      },
      body: json.encode(body)
    );

    Map<String, dynamic> decodedResponse = await json.decode(utf8.decode(response.bodyBytes));

    return NetworkResponse.fromBackend(decodedResponse, response.statusCode);

  }

  Future<NetworkResponse> postWithOutAccessHeader(String endPoint, Map<String, dynamic> body) async {
    HttpClient client = HttpClient();
    HttpClientRequest request = await client.openUrl('post', Uri.parse(endPoint));
    final String bodyEncoded = json.encode(body);
    request.headers.contentType = ContentType("application", "json", charset: "utf-8");
    request.headers.contentLength = bodyEncoded.length;
    request.write(bodyEncoded);
    HttpClientResponse response = await request.close();
    String decodedStringResponse = await transformHttpResponse(response);
    var decodedJsonResponse = json.decode(decodedStringResponse);

    return NetworkResponse.fromBackend(decodedJsonResponse, response.statusCode);
  }
}