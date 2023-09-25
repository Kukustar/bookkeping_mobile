import 'package:bookkeping_mobile/constants.dart';
import 'package:flutter/material.dart';

class CalendarBuilder extends StatelessWidget {
  final Widget child;
  const CalendarBuilder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: const ColorScheme.light(
          primary: greenColor
        )
      ),
      child: child,
    );
  }
}
