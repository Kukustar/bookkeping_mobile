import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bookkeping_mobile/balance/event.dart';
import 'package:bookkeping_mobile/balance/repository.dart';
import 'package:bookkeping_mobile/balance/state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  BalanceBloc({ required BalanceRepository balanceRepository }) :
        _balanceRepository = balanceRepository,
        super(BalanceState()) {
    _balanceSubscription = _balanceRepository.balance.listen(
            (balance)  => add(BalanceLoadSuccess(balance))
    );
    on<BalanceLoadSuccess>(_onBalanceLoadSuccess);
    on<BalanceLoad>(_onBalanceLoad);
  }

  final BalanceRepository _balanceRepository;
  late StreamSubscription<double> _balanceSubscription;

  void _onBalanceLoadSuccess(BalanceLoadSuccess event, Emitter<BalanceState> emit) {
    emit(state.copyWith(balance: event.balance));
  }
  void _onBalanceLoad(BalanceLoad event, Emitter<BalanceState> emit) async {
    emit(state.copyWith(isLoading: true));
    await _balanceRepository.getBalanceFromBackend();
    emit(state.copyWith(isLoading: false));
  }

  @override
  Future<void> close() async {
    _balanceSubscription.cancel();
    return super.close();
  }
}