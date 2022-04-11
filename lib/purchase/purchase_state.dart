import 'package:collection/collection.dart';

import 'package:bookkeping_mobile/purchase/entity.dart';

class PurchaseState {
  PurchaseState({
    this.purchaseList = const [],
    this.isPurchaseListLoading = false
  });

  final List<Purchase> purchaseList;
  final bool isPurchaseListLoading;

  get firstThreePurchase {
    if (purchaseList.length <= 3) {
      return purchaseList;
    }

    return purchaseList.slice(purchaseList.length - 3, purchaseList.length);
  }

  PurchaseState copyWith({
    List<Purchase>? purchaseList,
    bool? isPurchaseListLoading
  }) {
    return PurchaseState(
      purchaseList: purchaseList ?? this.purchaseList,
      isPurchaseListLoading: isPurchaseListLoading ?? this.isPurchaseListLoading
    );
  }
}