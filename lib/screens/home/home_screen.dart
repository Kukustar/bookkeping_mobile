import 'package:bookkeping_mobile/auth/auth_bloc.dart';
import 'package:bookkeping_mobile/auth/auth_event.dart';

import 'package:bookkeping_mobile/purchase/entity.dart';
import 'package:bookkeping_mobile/purchase/purchase_bloc.dart';
import 'package:bookkeping_mobile/purchase/purchase_event.dart';
import 'package:bookkeping_mobile/purchase/purchase_state.dart';

import 'package:bookkeping_mobile/screens/home/purchase_element.dart';
import 'package:bookkeping_mobile/screens/purchase_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<PurchaseBloc>(context).add(LoadPurchases());
    });
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
                BlocProvider
                    .of<AuthBloc>(context)
                    .add(LogOut());
              },
            )
          ],
        ),
      ),
      appBar: AppBar(title: Text(''),),
      body: SingleChildScrollView(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Счета',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary
                  )
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Траты',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  BlocBuilder<PurchaseBloc, PurchaseState>(
                    builder: (context, state) {
                      return state.purchaseList.length > 3 ?
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PurchaseListScreen()
                                )
                            );
                          },
                          child: Text('Еще')
                      ) :
                      SizedBox();
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<PurchaseBloc, PurchaseState>(
                builder: (context, state) {
                  return state.isPurchaseListLoading ? Center(child: CircularProgressIndicator()) : Column(
                    children: [
                      for (Purchase purchase in state.firstThreePurchase)
                        PurchaseElement(
                            title: purchase.title,
                            amount: purchase.amount,
                            date: purchase.date,
                            onTap: () {},
                        )
                    ],
                  );
                }
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Бюджет',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  BlocBuilder<PurchaseBloc, PurchaseState>(
                    builder: (context, state) {
                      return state.purchaseList.length > 3
                          ? ElevatedButton(onPressed: () {}, child: Text('Еще'))
                          : SizedBox();
                    },
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary
                      )
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Пополнения',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  BlocBuilder<PurchaseBloc, PurchaseState>(
                    builder: (context, state) {
                      return state.purchaseList.length > 3
                          ? ElevatedButton(onPressed: () {}, child: Text('Еще'))
                          : SizedBox();
                    },
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary
                      )
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
  
}