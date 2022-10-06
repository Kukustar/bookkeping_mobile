abstract class HomeEvent {}

class ChangeWhatTransactionsView extends HomeEvent {
  ChangeWhatTransactionsView(this._tapedIndex);
  final int _tapedIndex;

  int get tapedIndex => _tapedIndex;
}