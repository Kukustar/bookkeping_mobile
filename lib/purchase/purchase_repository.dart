import 'dart:async';

import 'package:bookkeping_mobile/purchase/entity.dart';
import 'package:bookkeping_mobile/service/core/api_service.dart';
import 'package:bookkeping_mobile/service/core/network_service.dart';

class PurchaseRepository {
  static const purchaseEndPoint = 'http://192.168.1.122:3003/purchases';

  final _purchaseController = StreamController<List<Purchase>>();
  final _tokenExpireController = StreamController<bool>();
  final _countController = StreamController<int>();

  Stream<List<Purchase>> get purchaseList async* {
    yield* _purchaseController.stream;
  }

  Stream<bool> get tokenExpire async* {
    yield* _tokenExpireController.stream;
  }

  Stream<int> get listCount async* {
    yield* _countController.stream;
  }

  Future<void> getPurchasesFromBackend({ page = 1 }) async {

    NetworkResponse response = await ApiService()
        .wrapRequestWithTokenCheck(ApiService().fetch, '$purchaseEndPoint?page=$page');

    switch (response.status) {
      case NetworkResponseStatus.success:
        List<Purchase> purchases = List<Purchase>
            .from(response.body['results'].toList().map((element) => Purchase.fromJson(element)));
        _purchaseController.add(purchases);
        _countController.add(response.body['count']);
        break;
      case NetworkResponseStatus.failed:
        break;
      case NetworkResponseStatus.tokenExpire:
        _tokenExpireController.add(true);
        break;
    }
  }
}