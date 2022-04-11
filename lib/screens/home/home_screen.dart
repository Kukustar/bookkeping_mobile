import 'package:bookkeping_mobile/entity/purchase.dart';
import 'package:bookkeping_mobile/repository/purchase.dart';
import 'package:bookkeping_mobile/screens/home/purchase_element.dart';
import 'package:bookkeping_mobile/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<Purchase> purchases = [];
  bool inProgress = true;

  void loadData () async {
    List<Purchase> response = await PurchaseRepository().getPurchasesFromBackend();
    setState(() {
      purchases = response;
      inProgress = false;
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: Drawer(
        child: Column(
          children: [
            const Spacer(),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 7),
                  Text('Выйти')
                ],
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false
                );
              },
            )
          ],
        ),
      ),
      appBar: AppBar(title: Text('Покупки'),),
      body: SingleChildScrollView(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            inProgress ? Center(child: CircularProgressIndicator()) : Column(
              children: [
                for (Purchase purchase in purchases)
                  PurchaseElement(title: purchase.title, amount: purchase.amount, date: purchase.date)
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
}