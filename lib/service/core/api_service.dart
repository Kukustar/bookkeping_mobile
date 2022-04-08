import 'package:bookkeping_mobile/service/core/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService extends NetworkService {
   Future<Map<String, dynamic>> backendFetch(String endPoint) async {

    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String accessToken = prefs.getString('access').toString();

    // todo check access token expire date
    // todo first iteration: if expire date end navigate user to login
    // todo second iteration: if expire date end refresh all tokens by face id
    NetworkResponse response = await fetch(endPoint, accessToken);

    if(response.status == NetworkResponseStatus.failed) {
      //  todo view some error
    }

    return response.body;
  }

  wrapRequestWithTokenCheck(Function() requestFunction) async {

  }


}