import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:bookkeping_mobile/purchase/entity.dart';

class PurchaseState {
  PurchaseState({
    this.purchaseId = 0,
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
    this.page = 1,
    this.count = 0
  });

  final int purchaseId;

  final String formStateAmount;
  final String formStateTitleError;
  final String formStateAmountError;
  final String formStateTitle;
  DateTime? formStateDate;

  TextEditingController? formStateDateTimeController;

  final List<Purchase> purchaseList;
  final bool isPurchaseListLoading;
  final bool isPurchasePageLoading;
  final bool isPurchaseAdding;
  final bool isFormUpdate;
  final int page;
  final int count;

  List<Purchase> get firstThreePurchase {
    if (purchaseList.length <= 3) {
      return purchaseList;
    }

    return purchaseList.slice(0, 3);
  }

  bool get canTapPrevButton {
    int totalPage = (count ~/ 25) + 1;
    if (page <= totalPage && (count % 25) != 0 ) {
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
    TextEditingController? formStateDateTimeController
  }) {
    return PurchaseState(
      count: count ?? this.count,
      purchaseList: purchaseList ?? this.purchaseList,
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
    );
  }
}