import 'package:bookkeping_mobile/service/core/network_service.dart';
import 'package:flutter/material.dart';

abstract class DepositEvent {}

class LoadDeposits extends DepositEvent {
  LoadDeposits(this._page);
  final int _page;

  int get page => _page;
}

class DepositCountChanged extends DepositEvent {
  DepositCountChanged(this._count);
  final int _count;

  int get count => _count;
}

class LoadDepositsSuccess extends DepositEvent {
  LoadDepositsSuccess(this._depositList);
  final List<dynamic> _depositList;

  List<dynamic> get depositList => _depositList;
}

class DepositDateChanged extends DepositEvent {
  DepositDateChanged(this._dateTime);
  final DateTime _dateTime;

  DateTime get dateTime => _dateTime;
}

class DepositDateFormControllerAdd extends DepositEvent {
  DepositDateFormControllerAdd(this._controller);
  final TextEditingController _controller;

  TextEditingController get controller => _controller;
}

class ClearDepositForm extends DepositEvent {}

class DepositAmountChanged extends DepositEvent {
  DepositAmountChanged(this._amount);
  final String _amount;

  String get amount => _amount;
}

class DepositTitleChanged extends DepositEvent {
  DepositTitleChanged(this._title);
  final String _title;

  String get title => _title;
}


class DepositResponseChanged extends DepositEvent {
  DepositResponseChanged(this._networkResponse);
  final NetworkResponse _networkResponse;

  NetworkResponse get networkResponse => _networkResponse;
}

class DepositIdChanged extends DepositEvent {
  DepositIdChanged(this._id);
  final int _id;

  int get id => _id;
}

class AddNewDeposit extends DepositEvent {}
class UpdateDeposit extends DepositEvent {}
class DeleteDeposit extends DepositEvent {}