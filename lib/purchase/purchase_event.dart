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

class LoadPage extends PurchaseEvent {
  LoadPage(this._page);
  final int _page;

  int get page => _page;
}

class PurchaseCountChanged extends PurchaseEvent {
  PurchaseCountChanged(this._count);
  final int _count;

  int get count => _count;
}

