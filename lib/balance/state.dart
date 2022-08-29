class BalanceState {
  BalanceState({this.balance = 0, this.isLoading = false});
  final double balance;
  final bool isLoading;

  BalanceState copyWith({ double? balance, bool? isLoading }) {
    return BalanceState(
      balance: balance ?? this.balance,
      isLoading: isLoading ?? this.isLoading
    );
  }
}