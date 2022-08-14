import 'package:bookkeping_mobile/service/core/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService extends NetworkService {
   bool isAccessTokenValid(String? tokenSaveDateTime) {
     if(tokenSaveDateTime == null) {
       return false;
     }

     if (DateTime.now().difference(DateTime.parse(tokenSaveDateTime.toString())).inMinutes > 5) {
       return false;
     }

     return true;
   }

   bool isCanUpdateAccessToken(String? tokenSaveDateTime) {
     if(tokenSaveDateTime == null) {
       return false;
     }

     if (DateTime.now().difference(DateTime.parse(tokenSaveDateTime.toString())).inDays > 0) {
       return false;
     }

     return true;
   }

  Future<NetworkResponse> wrapRequestWithTokenCheck(Future<NetworkResponse> Function(String, String) requestFunction, String endPoint) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? expireDateString = prefs.getString('expire_date');

    if (isAccessTokenValid(expireDateString)) {
      final String accessToken = prefs.getString('access').toString();
      NetworkResponse response = await requestFunction(endPoint, accessToken);

      return response;
    } else if (isCanUpdateAccessToken(expireDateString)) {

      await updateAccessToken();
      final String accessToken = prefs.getString('access').toString();
      NetworkResponse response = await requestFunction(endPoint, accessToken);

      return response;
    } else {

      return NetworkResponse.tokenExpire();
    }
  }

  Future<NetworkResponse> wrapPostRequestWithTokenCheck(
      Future<NetworkResponse> Function(String, String, Map<String, dynamic>) requestFunction,
      String endPoint, Map<String, dynamic> body) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? expireDateString = prefs.getString('expire_date');

    if (isAccessTokenValid(expireDateString)) {
      final String accessToken = prefs.getString('access').toString();
      NetworkResponse response = await requestFunction(endPoint, accessToken, body);

      return response;
    } else if (isCanUpdateAccessToken(expireDateString)) {

      await updateAccessToken();
      final String accessToken = prefs.getString('access').toString();
      NetworkResponse response = await requestFunction(endPoint, accessToken, body);

      return response;
    } else {

      return NetworkResponse.tokenExpire();
    }
  }

  Future<NetworkResponseStatus> updateAccessToken( ) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String refreshToken = prefs.getString('refresh').toString();
    NetworkResponse response = await postWithOutAccessHeader('http://192.168.1.104:3003/api/token/refresh/', { 'refresh': refreshToken });

    if (response.status == NetworkResponseStatus.success) {
       prefs.setString('access', response.body['access'].toString());
       prefs.setString('refresh', response.body['refresh'].toString());
       prefs.setString('expire_date', DateTime.now().toString());

       return NetworkResponseStatus.success;
    } else {
      return NetworkResponseStatus.failed;
    }
  }

  Future<void> updateTokensFromResponse(Map<String, dynamic> responseBody) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setString('access', responseBody['access'].toString());
    prefs.setString('refresh', responseBody['refresh'].toString());
    prefs.setString('expire_date', DateTime.now().toString());
  }

  Future<NetworkResponse> authUser(String email, password) async {
    NetworkResponse response = await postWithOutAccessHeader('http://192.168.1.104:3003/api/token/', {
        'username': email,
        'password': password
    });

    await updateTokensFromResponse(response.body);

    return response;
  }

  Future<dynamic> updateAllTokens() async {}
}