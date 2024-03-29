class Purchase {
  const Purchase({
    required this.date,
    required this.title,
    required this.amount,
    required this.id,
    required this.typeId
  });

  final DateTime date;
  final String title;
  final double amount;
  final int id;
  final int typeId;

  factory Purchase.fromJson(json) {
    return Purchase(
        id: json['id'],
        typeId: json['type_id'],
        date: DateTime.parse(json['date']),
        title: json['title'].toString(),
        amount: json['amount'] as double
    );
  }
}

class PurchaseType {

  final int id;
  final String title;

  const PurchaseType({ this.id = 0, this.title = '' });

  factory PurchaseType.fromJson(json) {
    return PurchaseType(id: json['id'], title: json['title']);
  }

  @override
  String toString() {
    // TODO: implement toString
    return '$id : $title';
  }
}