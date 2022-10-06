import 'package:bloc/bloc.dart';
import 'package:bookkeping_mobile/home/event.dart';
import 'package:bookkeping_mobile/home/state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<ChangeWhatTransactionsView>(_onChangeWhatTransactionsView);
  }

  _onChangeWhatTransactionsView(ChangeWhatTransactionsView event, Emitter<HomeState> emit) {
    List<bool> viewTransactions = List.from(state.viewTransactions);
    for (int i = 0; i < viewTransactions.length; i++) {
      viewTransactions[i] = i == event.tapedIndex;
    }
    emit(state.copyWith(viewTransactions: viewTransactions));
  }
}