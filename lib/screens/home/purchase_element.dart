import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionElement extends StatelessWidget {
  const TransactionElement({
    Key? key,
    required this.title,
    required this.amount,
    required this.date,
    required this.onTap
  }) : super(key: key);

  final String title;
  final double amount;
  final DateTime date;
  final VoidCallback onTap;

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
          border: Border.all(color: Colors.grey.withAlpha(50)),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                              title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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