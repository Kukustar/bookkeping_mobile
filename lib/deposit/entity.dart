class Deposit {
  const Deposit({
    required this.date,
    required this.title,
    required this.amount,
    required this.id,
  });

  final DateTime date;
  final String title;
  final double amount;
  final int id;

  factory Deposit.fromJson(json) {
    return Deposit(
        id: json['id'],
        date: DateTime.parse(json['date']),
        title: json['title'].toString(),
        amount: json['amount'] as double
    );
  }
}