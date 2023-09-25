import 'dart:async';

import 'package:bookkeping_mobile/service/core/api_service.dart';
import 'package:bookkeping_mobile/service/core/network_service.dart';
import 'package:flutter/foundation.dart';

class BalanceRepository {
  String get purchaseEndPoint => '${const String.fromEnvironment('API_HOST')}/balance/';

  final _balanceController = StreamController<double>();

  Stream<double> get balance  async* {
    yield* _balanceController.stream;
  }

  Future<void> getBalanceFromBackend() async {
    NetworkResponse response = await ApiService().wrapRequestWithTokenCheck(ApiService().fetch, purchaseEndPoint);

    switch (response.status) {
      case NetworkResponseStatus.success:
        double balance = 0;
        try {
          balance = response.body['results'].first['mount'];
        } catch (exception) {
          if(kDebugMode) {
            print(exception);
          }
        }
        _balanceController.add(balance);
        break;
      case NetworkResponseStatus.failed:
      case NetworkResponseStatus.waiting:
        break;
      case NetworkResponseStatus.tokenExpire:
        break;
    }

  }
}