import 'dart:async';

import 'package:bookkeping_mobile/entity/purchase.dart';
import 'package:bookkeping_mobile/service/core/api_service.dart';

class PurchaseRepository extends ApiService {
  static const purchaseEndPoint = 'http://localhost:3003/purchases';

  Future<List<Purchase>> getPurchasesFromBackend() async {
    Map<String, dynamic> response = await backendFetch(purchaseEndPoint);

    List<Purchase> purchases = List<Purchase>.from(response['results'].toList().map((element) => Purchase.fromJson(element)));

    return purchases;
  }
}