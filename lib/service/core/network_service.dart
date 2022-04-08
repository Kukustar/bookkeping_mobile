import 'dart:async';
import 'dart:convert';
import 'dart:io';

enum NetworkResponseStatus {
  success,
  failed
}

class NetworkResponse {
  final Map<String, dynamic> body;
  final NetworkResponseStatus status;

  const NetworkResponse({  required this.body, required this.status });

  factory NetworkResponse.fromBackend(body, int status) {
    NetworkResponseStatus apiResponseStatus = NetworkResponseStatus.success;
    if (status != 400) {
      apiResponseStatus = NetworkResponseStatus.failed;
    }
    return NetworkResponse(body: body, status: apiResponseStatus);
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
    request.headers.set('Content-Type', 'application/json');
    HttpClientResponse response = await request.close();
    String decodedStringResponse = await transformHttpResponse(response);
    var decodedJsonResponse = json.decode(decodedStringResponse);

    return NetworkResponse.fromBackend(decodedJsonResponse, response.statusCode);
  }
}