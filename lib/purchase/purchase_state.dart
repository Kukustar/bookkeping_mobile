import 'package:bookkeping_mobile/extensions.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:bookkeping_mobile/purchase/entity.dart';
import 'package:intl/intl.dart';

class PurchaseState {
  PurchaseState({
    // todo need to refactor and use network status for navigation
    this.successSaved = false,
    this.purchaseId = 0,
    // todo need to refactor and id for status form
    this.isFormUpdate = false,
    this.purchaseList = const [],
    this.isPurchaseListLoading = false,
    this.isPurchasePageLoading = false,
    this.isPurchaseAdding = false,
    this.formStateAmount = '',
    this.formStateTitle = '',
    this.formStateDate,
    this.formStateDateTimeController,
    this.formStateTitleError = '',
    this.formStateAmountError = '',
    this.formStatePurchaseTypeId = 0,
    this.page = 1,
    this.count = 0,
    this.purchaseTypeList = const []
  });

  final bool successSaved;

  final int purchaseId;
  final int formStatePurchaseTypeId;

  final String formStateAmount;
  final String formStateTitleError;
  final String formStateAmountError;
  final String formStateTitle;
  DateTime? formStateDate;

  TextEditingController? formStateDateTimeController;

  final List<PurchaseType> purchaseTypeList;
  final List<Purchase> purchaseList;
  final bool isPurchaseListLoading;
  final bool isPurchasePageLoading;
  final bool isPurchaseAdding;
  final bool isFormUpdate;
  final int page;
  final int count;

  List<Purchase> get firstTenPurchase {
    if (purchaseList.length <= 10) {
      return purchaseList;
    }

    return purchaseList.slice(0, 10);
  }

  String getPurchaseTitleById(int id) {
    List<PurchaseType> res = purchaseTypeList.where((element) => element.id == id).toList();
    if (res.isEmpty) {
      return '-';
    }
    return res.first.title;
  }

  String purchaseTypeTitleWrapper(int id) {
    if (id == 1) {
      return '-';
    }
    return getPurchaseTitleById(id);
  }

  String getSumByDate(String date) {
    List<Purchase> filteredPurchaseList = purchaseList.where((deposit) => deposit.date.toHashMapKeyFormat() == date).toList();
    double amount = filteredPurchaseList.map((e) => e.amount).fold<double>(0, (previousValue, element) => previousValue + element);
    return '${NumberFormat('#,###').format(amount).toString().replaceAll(',', ' ')} ₽';
  }

  String get fromToHeader {
    if (purchaseList.isNotEmpty) {
      String start = purchaseList.first.date.toHashMapKeyFormat();
      String end = purchaseList.last.date.toHashMapKeyFormat();

      return '$start - $end';
    }

    return '';
  }


  List<String> get firstTenDates {
    return firstTenPurchase
        .map((e) => e.date.toHashMapKeyFormat())
        .toSet()
        .toList();
  }

  List<String> get purchaseListDates {
    return purchaseList
        .map((e) => e.date.toHashMapKeyFormat())
        .toSet()
        .toList();
  }

  bool get canTapPrevButton {
    int totalPage = (count ~/ 25) + 1;
    if (page <= totalPage) {
      return true;
    }

    return false;
  }

  PurchaseState copyWith({
    List<Purchase>? purchaseList,
    bool? isPurchaseListLoading,
    bool? isPurchasePageLoading,
    bool? isPurchaseAdding,
    bool? isFormUpdate,
    int? page,
    int? purchaseId,
    int? count,
    String? formStateAmount,
    String? formStateTitle,
    String? formStateTitleError,
    String? formStateAmountError,
    DateTime? formStateDate,
    TextEditingController? formStateDateTimeController,
    bool? successSaved,
    List<PurchaseType>? purchaseTypeList,
    int? formStatePurchaseTypeId
  }) {
    return PurchaseState(
      count: count ?? this.count,
      purchaseList: purchaseList ?? this.purchaseList,
      purchaseTypeList: purchaseTypeList ?? this.purchaseTypeList,
      formStatePurchaseTypeId: formStatePurchaseTypeId ?? this.formStatePurchaseTypeId,
      isPurchaseListLoading: isPurchaseListLoading ?? this.isPurchaseListLoading,
      isPurchasePageLoading: isPurchasePageLoading ?? this.isPurchasePageLoading,
      isPurchaseAdding: isPurchaseAdding ?? this.isPurchaseAdding,
      page: page ?? this.page,
      purchaseId: purchaseId ?? this.purchaseId,
      formStateAmount: formStateAmount ?? this.formStateAmount,
      formStateTitle: formStateTitle ?? this.formStateTitle,
      formStateDate: formStateDate ?? this.formStateDate,
      formStateDateTimeController: formStateDateTimeController ?? this.formStateDateTimeController,
      formStateAmountError: formStateAmountError ?? this.formStateAmountError,
      formStateTitleError: formStateTitleError ?? this.formStateTitleError,
      isFormUpdate: isFormUpdate ?? this.isFormUpdate,
      successSaved: successSaved ?? this.successSaved,
    );
  }
}