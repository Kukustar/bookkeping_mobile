import 'package:bookkeping_mobile/repository/purchase.dart';
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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //
  // void loadBalances() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final String accessToken = prefs.getString('access').toString();
  //
  //   try {
  //     http.Response response = await http.get(
  //       Uri.parse('http://localhost:3003/api/available-for-day/'),
  //       headers: {
  //         'Authorization': "Bearer $accessToken",
  //         'Content-Type': 'application/json'
  //       }
  //     );
  //
  //     print(response.statusCode);
  //   } catch (exception) {
  //     print(exception);
  //   }
  // }

  @override
  void initState() {
    PurchaseRepository().fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Balance'),
                      Text('Balance for day')
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  
}