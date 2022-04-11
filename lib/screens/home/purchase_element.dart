import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PurchaseElement extends StatelessWidget {
  const PurchaseElement({ Key? key, required this.title, required this.amount, required this.date }) : super(key: key);

  final String title;
  final double amount;
  final DateTime date;

  get formattedDate {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title),
                    const Spacer(),
                    Text('${amount.toString()} ₽')
                  ],
                ),
                Text(formattedDate)
              ],
            ),
          ),
        ),
      ),
    );
  }
}