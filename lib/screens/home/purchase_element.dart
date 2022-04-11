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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Container(
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
        ),
      ),
    );
  }
}