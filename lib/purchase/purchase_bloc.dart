import 'dart:async';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

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
   on<LoadPage>(_onLoadPage);
   on<PurchaseCountChanged>(_onPurchaseCountChanged);
   on<AddPurchase>(_onAddPurchase);
   on<PurchaseDateChanged>(_onPurchaseDateChanged);
   on<PurchaseTitleChanged>(_onPurchaseTitleChanged);
   on<PurchaseAmountChanged>(_onPurchaseAmountChanged);
   on<PurchaseDateFormControllerAdd>(_onPurchaseDateFormControllerAdd);
   on<PurchaseErrorChanged>(_onPurchaseErrorChanged);
   on<IsFormUpdateChanged>(_onIsFormUpdateChanged);
   on<ClearPurchaseForm>(_onClearPurchaseForm);
   on<PurchaseIdChanged>(_onPurchaseIdChanged);
   on<PurchaseUpdate>(_onPurchaseUpdate);
   on<CanNavigateChanged>(_onCanNavigateChanged);
   on<PurchaseDelete>(_onPurchaseDelete);
   on<LoadPurchaseTypesSuccess>(_onLoadPurchaseTypesSuccess);
   on<PurchaseTypeChanged>(_onPurchaseTypeChanged);
   _tokenExpireSubscription = _purchaseRepository.tokenExpire.listen(
           (tokenExpire) => add(AuthStatusChangedByPurchase(tokenExpire))
   );
   _purchaseListSubscription = _purchaseRepository.purchaseList.listen(
           (list)  => add(LoadPurchasesSuccess(list))
   );
   _purchaseCountSubscription = _purchaseRepository.listCount.listen(
           (count) => add(PurchaseCountChanged(count))
   );

   _errorSubscription = _purchaseRepository.error.listen(
           (error) => add(PurchaseErrorChanged(error))
   );
   _subscriptionCanNavigate = _purchaseRepository.canNavigate.listen(
           (flag) => add(CanNavigateChanged(flag))
   );
   _streamSubscriptionPurchaseType = _purchaseRepository.purchaseType.listen(
           (data) => add(LoadPurchaseTypesSuccess(data))
   );
  }

  final PurchaseRepository _purchaseRepository;
  final AuthRepository authRepository;

  late StreamSubscription<bool> _tokenExpireSubscription;
  late StreamSubscription<List<Purchase>> _purchaseListSubscription;
  late StreamSubscription<int> _purchaseCountSubscription;
  late StreamSubscription<Map<String, dynamic>> _errorSubscription;
  late StreamSubscription<bool> _subscriptionCanNavigate;
  late StreamSubscription<List<dynamic>> _streamSubscriptionPurchaseType;

  _onPurchaseTypeChanged(PurchaseTypeChanged event, Emitter<PurchaseState> emit) async {
    emit(state.copyWith(formStatePurchaseTypeId: event.id));
  }

  _onPurchaseUpdate(PurchaseUpdate event, Emitter<PurchaseState> emit) async {

    await _purchaseRepository.updatePurchaseOnBackend({
      'title': state.formStateTitle,
      'amount': state.formStateAmount,
      'id': state.purchaseId,
      'date': state.formStateDate.toString(),
      'description': '',
      'type_id': state.formStatePurchaseTypeId
    });
  }

  _onPurchaseDelete(PurchaseDelete event, Emitter<PurchaseState> emit) async {
    await _purchaseRepository.deletePurchaseFromBackend(state.purchaseId.toString());
  }

  _onPurchaseIdChanged(PurchaseIdChanged event, Emitter<PurchaseState> emit) {
    emit(state.copyWith(purchaseId: event.purchaseId));
  }

  _onClearPurchaseForm(ClearPurchaseForm event, Emitter<PurchaseState> emit) {
    emit(state.copyWith(
        formStateAmountError: '',
        formStateTitle: '',
        formStateDate: null,
        formStateTitleError: '',
        formStateAmount: '',
        isFormUpdate: false,
        purchaseId: 0,
        successSaved: false
    ));
  }

  _onPurchaseErrorChanged(PurchaseErrorChanged event, Emitter<PurchaseState> emit) {
    Map<String, dynamic> errors = event.error;

    if (errors.containsKey('amount')) {
      emit(state.copyWith(formStateAmountError: errors['amount'].first));
    }
    if (errors.containsKey('title')) {
      emit(state.copyWith(formStateTitleError: errors['title'].first));
    }
  }

  _onCanNavigateChanged(CanNavigateChanged event, Emitter<PurchaseState> emit) {
    emit(state.copyWith(successSaved: event.successSaved));
  }

  _onIsFormUpdateChanged(IsFormUpdateChanged event, Emitter<PurchaseState> emit) {
    emit(state.copyWith(isFormUpdate: event.isFormUpdate));
  }

  _onLoadPurchaseTypesSuccess(LoadPurchaseTypesSuccess event, Emitter<PurchaseState> emit) {
    List<PurchaseType> typeList = event.data.map((e) => PurchaseType.fromJson(e)).toList();
    emit(state.copyWith(purchaseTypeList: typeList));
  }

  _onLoadPurchases(LoadPurchases event, Emitter<PurchaseState> emit) async {
    emit(state.copyWith(isPurchaseListLoading: true));
    await _purchaseRepository.getPurchasesFromBackend();
    await _purchaseRepository.getPurchaseTypes();
    emit(state.copyWith(isPurchaseListLoading: false));
  }

  _onPurchaseDateFormControllerAdd(PurchaseDateFormControllerAdd event, Emitter<PurchaseState> emit) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    TextEditingController controller = event.controller;
    controller.text = formatter.format(state.formStateDate as DateTime);
    emit(state.copyWith(formStateDateTimeController: event.controller));
  }

  _onAddPurchase(AddPurchase event, Emitter<PurchaseState> emit) async {
    emit(state.copyWith(isPurchaseAdding: true));
    await _purchaseRepository.addPurchaseToBackend(
        state.formStateAmount,
        state.formStateTitle,
        state.formStateDate as DateTime,
        state.formStatePurchaseTypeId
    );
    emit(state.copyWith(isPurchaseAdding: false));
  }

  _onPurchaseDateChanged(PurchaseDateChanged event, Emitter<PurchaseState> emit) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    state.formStateDateTimeController ??= TextEditingController();
    state.formStateDateTimeController!.text = formatter.format(event.date);
    emit(state.copyWith(formStateDate: event.date));
  }

  _onPurchaseTitleChanged(PurchaseTitleChanged event, Emitter<PurchaseState> emit) {
    emit(state.copyWith(formStateTitle: event.title, formStateTitleError: ''));
  }

  _onPurchaseAmountChanged(PurchaseAmountChanged event, Emitter<PurchaseState> emit) {
    emit(state.copyWith(formStateAmount: event.amount, formStateAmountError: ''));
  }

  _onPurchaseCountChanged(PurchaseCountChanged event, Emitter<PurchaseState> emit) {
    emit(state.copyWith(count: event.count));
  }

  _onLoadPurchasesSuccess(LoadPurchasesSuccess event, Emitter<PurchaseState> emit) {
    emit(state.copyWith(purchaseList: event.purchaseList));
  }

  _onAuthStatusChangedByPurchase(AuthStatusChangedByPurchase event, Emitter<PurchaseState> emit) async {
    if (event.tokenExpire) {
      authRepository.logOut();
    }
  }


  _onLoadPage(LoadPage event, Emitter<PurchaseState> emit) async {
    // todo return page or change it after if request failed
    emit(state.copyWith(isPurchasePageLoading: true, page: event.page));
    await _purchaseRepository.getPurchasesFromBackend(page: event.page);
    emit(state.copyWith(isPurchasePageLoading: false));
  }

  @override
  Future<void> close() async {
    _tokenExpireSubscription.cancel();
    _purchaseListSubscription.cancel();
    _purchaseCountSubscription.cancel();
    _subscriptionCanNavigate.cancel();
    _errorSubscription.cancel();
    _streamSubscriptionPurchaseType.cancel();
    return super.close();
  }
}