abstract class BalanceEvent{}

class BalanceLoadSuccess extends BalanceEvent {
  BalanceLoadSuccess(this._balance);
  final double _balance;

  double get balance => _balance;
}

class BalanceLoad extends BalanceEvent {}