import 'package:bookkeping_mobile/auth/auth_bloc.dart';
import 'package:bookkeping_mobile/auth/auth_event.dart';
import 'package:bookkeping_mobile/balance/bloc.dart';
import 'package:bookkeping_mobile/balance/event.dart';
import 'package:bookkeping_mobile/balance/repository.dart';
import 'package:bookkeping_mobile/balance/state.dart';

import 'package:bookkeping_mobile/purchase/entity.dart';
import 'package:bookkeping_mobile/purchase/purchase_bloc.dart';
import 'package:bookkeping_mobile/purchase/purchase_event.dart';
import 'package:bookkeping_mobile/purchase/purchase_state.dart';
import 'package:bookkeping_mobile/screens/home/balance_element.dart';

import 'package:bookkeping_mobile/screens/home/purchase_element.dart';
import 'package:bookkeping_mobile/screens/purchase_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
      BlocProvider.of<BalanceBloc>(context).add(BalanceLoad());
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
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<PurchaseBloc>(context).add(LoadPurchases());
          BlocProvider.of<BalanceBloc>(context).add(BalanceLoad());
        },
        child: ListView(
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
            BlocBuilder<BalanceBloc, BalanceState>(
              builder: (context, state) {
                return state.isLoading ? Center(child: CircularProgressIndicator()) :  BalanceElement(
                    title: 'Общий баланс',
                    amount: NumberFormat('#,###').format(state.balance).toString().replaceAll(',', ' ') ,
                    date: DateTime.now(),
                    onTap: () {},
                );
              }
            ),
            SizedBox(height: 10,),
            Divider(
              color: Colors.red,
              height: 0.5,
              indent: 3,
              endIndent: 3,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20,right: 5),
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
                      TextButton(
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
            const SizedBox(height: 15),
            Divider(
              color: Colors.grey.withAlpha(90),
              height: 0.5, 
              indent: 3,
              endIndent: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 5),
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
                          ? TextButton(onPressed: () {}, child: Text('Еще'))
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
            const SizedBox(height: 15),
            Divider(
              color: Colors.grey.withAlpha(90),
              height: 0.5,
              indent: 3,
              endIndent: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 5),
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
                          ? TextButton(onPressed: () {}, child: Text('Еще'))
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