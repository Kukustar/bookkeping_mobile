class HomeState {
  HomeState({
    this.viewTransactions = const [true, false]
  });

  final List<bool> viewTransactions;

  HomeState copyWith({ List<bool>? viewTransactions }) {
    return HomeState(
        viewTransactions: viewTransactions ?? this.viewTransactions
    );
  }
}