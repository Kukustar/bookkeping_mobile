import 'dart:async';

import 'package:bookkeping_mobile/purchase/entity.dart';
import 'package:bookkeping_mobile/service/core/api_service.dart';
import 'package:bookkeping_mobile/service/core/network_service.dart';

class PurchaseRepository {
  static const purchaseEndPoint = 'http://localhost:3003/purchases';

  final _purchaseController = StreamController<List<Purchase>>();
  final _tokenExpireController = StreamController<bool>();

  Stream<List<Purchase>> get purchaseList async* {
    yield* _purchaseController.stream;
  }

  Stream<bool> get tokenExpire async* {
    yield* _tokenExpireController.stream;
  }

  Future<void> getPurchasesFromBackend() async {

    NetworkResponse response = await ApiService()
        .wrapRequestWithTokenCheck(ApiService().fetch, purchaseEndPoint);

    print(response.status);
    switch (response.status) {
      case NetworkResponseStatus.success:
        List<Purchase> purchases = List<Purchase>
            .from(response.body['results'].toList().map((element) => Purchase.fromJson(element)));
        _purchaseController.add(purchases);
        break;
      case NetworkResponseStatus.failed:
        break;
      case NetworkResponseStatus.tokenExpire:
        _tokenExpireController.add(true);
        break;
    }
  }
}