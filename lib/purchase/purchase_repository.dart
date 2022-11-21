import 'dart:async';

import 'package:bookkeping_mobile/purchase/entity.dart';
import 'package:bookkeping_mobile/service/core/api_service.dart';
import 'package:bookkeping_mobile/service/core/network_service.dart';


// todo refactor: send response request to bloc and after it parse

class PurchaseRepository {
  String get purchaseEndPoint => '${const String.fromEnvironment('API_HOST')}/purchases/';
  String get purchaseTypeEndPoint => '${const String.fromEnvironment('API_HOST')}/purchase-types/';

  final _purchaseController = StreamController<List<Purchase>>();
  final _tokenExpireController = StreamController<bool>();
  final _countController = StreamController<int>();
  final _canNavigateController = StreamController<bool>();

  final _purchaseErrorController = StreamController<Map<String, dynamic>>();

  final _purchaseTypeController = StreamController<List<dynamic>>();

  Stream<List<dynamic>> get purchaseType async* {
    yield* _purchaseTypeController.stream;
  }

  Stream<Map<String, dynamic>> get error async* {
    yield* _purchaseErrorController.stream;
  }

  Stream<List<Purchase>> get purchaseList async* {
    yield* _purchaseController.stream;
  }

  Stream<bool> get tokenExpire async* {
    yield* _tokenExpireController.stream;
  }

  Stream<int> get listCount async* {
    yield* _countController.stream;
  }

  // todo use response network response for navigation
  Stream<bool> get canNavigate async* {
    yield* _canNavigateController.stream;
  }

  Future<void> deletePurchaseFromBackend(String purchaseId) async {
    NetworkResponse response = await ApiService()
        .wrapRequestWithTokenCheck(ApiService().deleteData, '$purchaseEndPoint$purchaseId/'
    );

    switch (response.status) {
      case NetworkResponseStatus.success:
        _canNavigateController.add(true);
        break;
      case NetworkResponseStatus.failed:
        break;
      case NetworkResponseStatus.tokenExpire:
        _tokenExpireController.add(true);
        break;
      case NetworkResponseStatus.waiting:
        // TODO: Handle this case.
        break;
    }
  }

  Future<void> getPurchaseTypes() async {
    NetworkResponse response = await ApiService()
      .wrapRequestWithTokenCheck(ApiService().fetch, purchaseTypeEndPoint);

    switch (response.status) {
      case NetworkResponseStatus.success:
        _purchaseTypeController.add(response.body['results']);
        break;
      case NetworkResponseStatus.failed:
      case NetworkResponseStatus.waiting:
      case NetworkResponseStatus.tokenExpire:
        break;
    }

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
      case NetworkResponseStatus.waiting:
        // TODO: Handle this case.
        break;
    }
  }

  Future<void> updatePurchaseOnBackend(Map<String, dynamic> object) async {
    NetworkResponse response = await ApiService().wrapPostRequestWithTokenCheck(
      ApiService().putData, '$purchaseEndPoint${object['id']}/', object
    );

    switch (response.status) {
      case NetworkResponseStatus.success:
        _canNavigateController.add(true);
        break;
      case NetworkResponseStatus.failed:
        break;
      case NetworkResponseStatus.tokenExpire:
        _tokenExpireController.add(true);
        break;
      case NetworkResponseStatus.waiting:
        // TODO: Handle this case.
        break;
    }
  }


  Future<void> addPurchaseToBackend(String amount, String title, DateTime date, int purchaseType) async {
    Map<String, dynamic> body = Map.from({ 'title': title, 'amount': amount, 'date': date.toString(), 'description': '', 'type_id': purchaseType  });
    NetworkResponse response = await ApiService().wrapPostRequestWithTokenCheck(
            ApiService().postData, purchaseEndPoint, body
    );

    switch (response.status) {
      case NetworkResponseStatus.success:
        _canNavigateController.add(true);
        break;
      case NetworkResponseStatus.failed:
        _purchaseErrorController.add(response.body);
        break;
      case NetworkResponseStatus.tokenExpire:
        _tokenExpireController.add(true);
        break;
      case NetworkResponseStatus.waiting:
        // TODO: Handle this case.
        break;
    }
  }
}