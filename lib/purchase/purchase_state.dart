import 'package:collection/collection.dart';

import 'package:bookkeping_mobile/purchase/entity.dart';

class PurchaseState {
  PurchaseState({
    this.purchaseList = const [],
    this.isPurchaseListLoading = false,
    this.isPurchasePageLoading = false,
    this.page = 1,
    this.count = 0
  });

  final List<Purchase> purchaseList;
  final bool isPurchaseListLoading;
  final bool isPurchasePageLoading;
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
    int? page,
    int? count
  }) {
    return PurchaseState(
      purchaseList: purchaseList ?? this.purchaseList,
      isPurchaseListLoading: isPurchaseListLoading ?? this.isPurchaseListLoading,
      isPurchasePageLoading: isPurchasePageLoading ?? this.isPurchasePageLoading,
      page: page ?? this.page,
      count: count ?? this.count
    );
  }
}