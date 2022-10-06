import 'package:bookkeping_mobile/purchase/entity.dart';
import 'package:flutter/material.dart';

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

class AddPurchase extends PurchaseEvent {
  AddPurchase(this._onSuccess);
  final VoidCallback _onSuccess;

  VoidCallback get onSuccess => _onSuccess;

}

class PurchaseDateChanged extends PurchaseEvent {
  PurchaseDateChanged(this._date);
  final DateTime _date;

  DateTime get date => _date;
}

class PurchaseAmountChanged extends PurchaseEvent {
  PurchaseAmountChanged(this._amount);
  final String _amount;

  String get amount => _amount;
}

class PurchaseTitleChanged extends PurchaseEvent {
  PurchaseTitleChanged(this._title);
  final String _title;

  String get title => _title;
}

class PurchaseDateFormControllerAdd extends PurchaseEvent {
  PurchaseDateFormControllerAdd(this._controller);
  final TextEditingController _controller;

  TextEditingController get controller => _controller;
}

class PurchaseErrorChanged extends PurchaseEvent {
  PurchaseErrorChanged(this._error);
  final Map<String, dynamic> _error;

  Map<String, dynamic> get error => _error;
}

class PurchaseIdChanged extends PurchaseEvent {
  PurchaseIdChanged(this._purchaseId);
  final int _purchaseId;

  int get purchaseId => _purchaseId;
}

class IsFormUpdateChanged extends PurchaseEvent {
  IsFormUpdateChanged(this._isFormUpdate);
  final bool _isFormUpdate;

  bool get isFormUpdate => _isFormUpdate;
}

class ClearPurchaseForm extends PurchaseEvent {}

class PurchaseUpdate extends PurchaseEvent {
  PurchaseUpdate(this._onSuccess);
  final VoidCallback _onSuccess;
  VoidCallback get onSuccess => _onSuccess;
}

class PurchaseDelete extends PurchaseEvent {
  PurchaseDelete(this._onSuccess);
  final VoidCallback _onSuccess;
  VoidCallback get onSuccess => _onSuccess;
}

class CanNavigateChanged extends PurchaseEvent {
  CanNavigateChanged(this._successSaved);
  final bool _successSaved;

  bool get successSaved => _successSaved;
}