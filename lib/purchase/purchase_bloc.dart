import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:bookkeping_mobile/auth/auth_repository.dart';
import 'package:bookkeping_mobile/purchase/entity.dart';
import 'package:bookkeping_mobile/purchase/purchase_event.dart';
import 'package:bookkeping_mobile/purchase/purchase_repository.dart';
import 'package:bookkeping_mobile/purchase/purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  PurchaseBloc({ required PurchaseRepository purchaseRepository, required this.authRepository }) :
        _purchaseRepository = purchaseRepository,
        super(PurchaseState()) {
   on<LoadPurchases>(_onLoadPurchases);
   on<AuthStatusChangedByPurchase>(_onAuthStatusChangedByPurchase);
   on<LoadPurchasesSuccess>(_onLoadPurchasesSuccess);
   _tokenExpireSubscription = _purchaseRepository.tokenExpire.listen(
           (tokenExpire) => add(AuthStatusChangedByPurchase(tokenExpire))
   );
   _purchaseListSubscription = _purchaseRepository.purchaseList.listen(
           (list)  => add(LoadPurchasesSuccess(list))
   );
  }

  final PurchaseRepository _purchaseRepository;
  final AuthRepository authRepository;

  late StreamSubscription<bool> _tokenExpireSubscription;
  late StreamSubscription<List<Purchase>> _purchaseListSubscription;

  _onLoadPurchases(LoadPurchases event, Emitter<PurchaseState> emit) async {
    emit(state.copyWith(isPurchaseListLoading: true));
    await _purchaseRepository.getPurchasesFromBackend();
    emit(state.copyWith(isPurchaseListLoading: false));
  }

  _onLoadPurchasesSuccess(LoadPurchasesSuccess event, Emitter<PurchaseState> emit) {
    emit(state.copyWith(purchaseList: event.purchaseList));
  }

  _onAuthStatusChangedByPurchase(AuthStatusChangedByPurchase event, Emitter<PurchaseState> emit) async {
    if (event.tokenExpire) {
      authRepository.logOut();
    }
  }

  @override
  Future<void> close() async {
    _tokenExpireSubscription.cancel();
    _purchaseListSubscription.cancel();
    return super.close();
  }
}