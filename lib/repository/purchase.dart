import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

// import 'package:http/http.dart' as http;

class PurchaseRepository {
  static const purchaseEndPoint = 'http://localhost:3003/purchases';

  Future<List> fetch() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String accessToken = prefs.getString('access').toString();

    Future<String> readResponse( response) {
      final completer = Completer<String>();
      final contents = StringBuffer();
      response.transform(utf8.decoder).listen((data) {
        contents.write(data);
      }, onDone: () => completer.complete(contents.toString()));
      return completer.future;
    }

    try {
      HttpClient client = HttpClient();
      HttpClientRequest request = await client.openUrl('get', Uri.parse(purchaseEndPoint));
      request.headers.set('Authorization', "Bearer $accessToken");
      request.headers.set('Content-Type', 'application/json');
      var response = await request.close();

      var resposeDecoded = await readResponse(response);
      print(resposeDecoded);
    } catch(e) {
      print(e);
    }

    return [];
  }
}