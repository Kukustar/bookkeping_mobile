class Purchase {
  const Purchase({ required this.date, required this.title, required this.amount });

  final DateTime date;
  final String title;
  final double amount;

  factory Purchase.fromJson(json) {
    return Purchase(
        date: DateTime.parse(json['date']),
        title: json['title'].toString(),
        amount: json['amount'] as double
    );
  }
}