import 'dart:async';

import 'package:bookkeping_mobile/service/core/api_service.dart';
import 'package:bookkeping_mobile/service/core/network_service.dart';

class DepositRepository {
  String get depositEndPoint => '${const String.fromEnvironment('API_HOST')}/deposits/';

  final _depositController = StreamController<List<dynamic>>();
  final _countController = StreamController<int>();

  final _networkResponseController = StreamController<NetworkResponse>();

  Stream<List<dynamic>> get deposit async* {
    yield* _depositController.stream;
  }

  Stream<int> get count async* {
    yield* _countController.stream;
  }

  Stream<NetworkResponse> get networkResponse async* {
    yield* _networkResponseController.stream;
  }

  Future<void> getDepositsFromBackend(int page) async {
    NetworkResponse response = await ApiService().wrapRequestWithTokenCheck(ApiService().fetch, '$depositEndPoint?page=$page');

    switch (response.status) {
      case NetworkResponseStatus.success:
        if (response.body.containsKey('results')) {
          _depositController.add(response.body['results']);
        }
        if (response.body.containsKey('count')) {
          _countController.add(response.body['count']);
        }
        break;
      case NetworkResponseStatus.failed:
      case NetworkResponseStatus.tokenExpire:
        break;
      case NetworkResponseStatus.waiting:
        // TODO: Handle this case.
        break;
    }
  }

  Future<void> addDepositToBackend(String amount, String title, DateTime date) async {
    Map<String, dynamic> body = Map.from({ 'title': title, 'amount': amount, 'date': date.toString(), 'description': ''  });
    NetworkResponse response = await ApiService().wrapPostRequestWithTokenCheck(
        ApiService().postData, depositEndPoint, body
    );

    _networkResponseController.add(response);
  }

  Future<void> deleteDepositOnBackend(String id) async {
    NetworkResponse response = await ApiService()
        .wrapRequestWithTokenCheck(ApiService().deleteData, '$depositEndPoint$id/'
    );

    _networkResponseController.add(response);
  }

  Future<void> updateDepositOnBackend(Map<String, dynamic> object) async {
    NetworkResponse response = await ApiService().wrapPostRequestWithTokenCheck(
        ApiService().putData, '$depositEndPoint${object['id']}/', object
    );

    _networkResponseController.add(response);
  }
}

