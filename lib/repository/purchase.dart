import 'dart:async';

import 'package:bookkeping_mobile/service/core/api_service.dart';

class PurchaseRepository {
  static const purchaseEndPoint = 'http://localhost:3003/purchases';

  Future<List> getPurchasesFromBackend() async {
    Map<String, dynamic> purchases = await ApiService().backendFetch(purchaseEndPoint);
    print(purchases);


    return [];
  }
}