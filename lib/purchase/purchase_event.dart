import 'package:bookkeping_mobile/purchase/entity.dart';

abstract class PurchaseEvent {}

class LoadPurchases extends PurchaseEvent {}

class LoadPurchasesSuccess extends PurchaseEvent {
  LoadPurchasesSuccess(this._purchaseList);
  final List<Purchase> _purchaseList;

  List<Purchase> get purchaseList => _purchaseList;
}

class AuthStatusChangedByPurchase extends PurchaseEvent {
  AuthStatusChangedByPurchase(this._tokenExpire);
  final bool _tokenExpire;

  bool get tokenExpire => _tokenExpire;
}

