import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bookkeping_mobile/auth/auth_repository.dart';
import 'package:bookkeping_mobile/deposit/entity.dart';
import 'package:bookkeping_mobile/deposit/event.dart';
import 'package:bookkeping_mobile/deposit/repository.dart';
import 'package:bookkeping_mobile/deposit/state.dart';
import 'package:bookkeping_mobile/service/core/network_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  DepositBloc({required DepositRepository repository, required authRepository }) :
        _repository = repository,
        _authRepository = authRepository,
        super(DepositState()) {
    _depositSubscription = _repository.deposit.listen(
            (depositList) => add(LoadDepositsSuccess(depositList))
    );
    _countSubscription = _repository.count.listen(
            (count) => add(DepositCountChanged(count))
    );
    _networkResponseSubscription = _repository.networkResponse.listen(
            (response) => add(DepositResponseChanged(response))
    );
    on<LoadDepositsSuccess>(_onLoadDepositsSuccess);
    on<LoadDeposits>(_onLoadDeposits);
    on<DepositCountChanged>(_onDepositCountChanged);
    on<DepositDateChanged>(_onDepositDateChanged);
    on<DepositDateFormControllerAdd>(_onDepositDateFormControllerAdd);
    on<ClearDepositForm>(_onClearDepositForm);
    on<DepositAmountChanged>(_onDepositAmountChanged);
    on<DepositTitleChanged>(_onDepositTitleChanged);
    on<AddNewDeposit>(_onAddNewDeposit);
    on<UpdateDeposit>(_onUpdateDeposit);
    on<DepositResponseChanged>(_onDepositResponseChanged);
    on<DepositIdChanged>(_onDepositIdChanged);
    on<DeleteDeposit>(_onDeleteDeposit);
  }

  final DepositRepository _repository;
  final AuthRepository _authRepository;
  late StreamSubscription<List<dynamic>> _depositSubscription;
  late StreamSubscription<int> _countSubscription;
  late StreamSubscription<NetworkResponse> _networkResponseSubscription;

  void _onDepositResponseChanged(DepositResponseChanged event, Emitter<DepositState> emit) {
    switch (event.networkResponse.status) {
      case NetworkResponseStatus.success:
        emit(state.copyWith(saveResponseStatus: NetworkResponseStatus.success));
        break;
      case NetworkResponseStatus.failed:
        if (event.networkResponse.body.containsKey('amount')) {
          emit(state.copyWith(formStateAmountError: event.networkResponse.body['amount'].first));
        }
        if (event.networkResponse.body.containsKey('title')) {
          emit(state.copyWith(formStateTitleError: event.networkResponse.body['title'].first));
        }
        break;
      case NetworkResponseStatus.tokenExpire:
        _authRepository.logOut();
        break;
      case NetworkResponseStatus.waiting:
        // TODO: Handle this case.
        break;
    }
  }

  void _onDepositIdChanged(DepositIdChanged event,  Emitter<DepositState> emit) {
    emit(state.copyWith(depositId: event.id));
  }

  void _onUpdateDeposit(UpdateDeposit event, Emitter<DepositState> emit) async {
    emit(state.copyWith(isLoading: true));
    await _repository.updateDepositOnBackend({
      'title': state.formStateTitle,
      'amount': state.formStateAmount,
      'id': state.depositId,
      'date': state.formStateDate.toString(),
    });
    emit(state.copyWith(isLoading: false));
  }

  void _onDeleteDeposit(DeleteDeposit event, Emitter<DepositState> emit) async {
    emit(state.copyWith(isLoading: true));
    await _repository.deleteDepositOnBackend(state.depositId.toString());
    emit(state.copyWith(isLoading: false));
  }

  void _onAddNewDeposit(AddNewDeposit event, Emitter<DepositState> emit) async {
    emit(state.copyWith(isLoading: true));
    await _repository.addDepositToBackend(state.formStateAmount, state.formStateTitle, state.formStateDate as DateTime);
    emit(state.copyWith(isLoading: false));
  }

  void _onDepositAmountChanged(DepositAmountChanged event, Emitter<DepositState> emit) {
    emit(state.copyWith(formStateAmount: event.amount, formStateAmountError: ''));
  }

  void _onDepositTitleChanged(DepositTitleChanged event, Emitter<DepositState> emit) {
    emit(state.copyWith(formStateTitle: event.title, formStateTitleError: ''));
  }

  void _onDepositDateFormControllerAdd(DepositDateFormControllerAdd event, Emitter<DepositState> emit) {
    emit(state.copyWith(formStateDateTimeController: event.controller));
  }

  void _onClearDepositForm(ClearDepositForm event, Emitter<DepositState> emit) {
    emit(state.copyWith(
        formStateAmountError: '',
        formStateTitle: '',
        formStateDate: null,
        formStateTitleError: '',
        formStateAmount: '',
        depositId: 0,
        saveResponseStatus: NetworkResponseStatus.waiting
    ));
  }

  void _onDepositDateChanged(DepositDateChanged event, Emitter<DepositState> emit) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    TextEditingController textEditingController = state.formStateDateTimeController ?? TextEditingController();
    textEditingController.text = formatter.format(event.dateTime);
    emit(state.copyWith(formStateDate: event.dateTime, formStateDateTimeController: textEditingController));
  }

  void _onDepositCountChanged(DepositCountChanged event, Emitter<DepositState> emit) {
    emit(state.copyWith(count: event.count));
  }

  void _onLoadDepositsSuccess(LoadDepositsSuccess event, Emitter<DepositState> emit) {
    List<Deposit> depositList = event.depositList.map((e) => Deposit.fromJson(e)).toList();
    emit(state.copyWith(depositList: depositList));
  }

  void _onLoadDeposits(LoadDeposits event, Emitter<DepositState> emit) async {
    emit(state.copyWith(isLoading: true, page: event.page));
    await _repository.getDepositsFromBackend(event.page);
    emit(state.copyWith(isLoading: false));
  }

  @override
  Future<void> close() async{
    _depositSubscription.cancel();
    _countSubscription.cancel();
    _networkResponseSubscription.cancel();
    return super.close();
  }
}