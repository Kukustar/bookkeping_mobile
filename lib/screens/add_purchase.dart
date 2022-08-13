import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen({Key? key}) : super(key: key);

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}



class _AddPurchaseScreenState extends State<AddPurchaseScreen> {

  DateTime selectedDate = DateTime.now();
  TextEditingController dateTimeController = TextEditingController();

  @override
  void initState () {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    dateTimeController.text = formatter.format(selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добавить покупку')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 100,),
            TextField(),
            SizedBox(height: 26,),
            TextField(
              controller: dateTimeController,
              readOnly: true,
              onTap: () async {
                DateTime? date = await showDatePicker(
                    locale: Locale('ru'),
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
                    lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),

                );
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                    final DateFormat formatter = DateFormat('yyyy-MM-dd');
                    dateTimeController.text = formatter.format(date);
                  });
                }
              },
            ),
            SizedBox(height: 26,),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 20))
                      ),
                      onPressed: () {
                      },
                      child: Text('Добавить')
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
