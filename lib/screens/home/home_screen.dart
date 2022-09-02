import 'package:bookkeping_mobile/auth/auth_bloc.dart';
import 'package:bookkeping_mobile/auth/auth_event.dart';
import 'package:bookkeping_mobile/balance/bloc.dart';
import 'package:bookkeping_mobile/balance/event.dart';
import 'package:bookkeping_mobile/balance/state.dart';
import 'package:bookkeping_mobile/constants.dart';
import 'package:bookkeping_mobile/deposit/bloc.dart';
import 'package:bookkeping_mobile/deposit/entity.dart';
import 'package:bookkeping_mobile/deposit/event.dart';
import 'package:bookkeping_mobile/deposit/repository.dart';
import 'package:bookkeping_mobile/deposit/state.dart';
import 'package:bookkeping_mobile/home/bloc.dart';
import 'package:bookkeping_mobile/home/event.dart';
import 'package:bookkeping_mobile/home/state.dart';

import 'package:bookkeping_mobile/purchase/entity.dart';
import 'package:bookkeping_mobile/purchase/purchase_bloc.dart';
import 'package:bookkeping_mobile/purchase/purchase_event.dart';
import 'package:bookkeping_mobile/purchase/purchase_state.dart';
import 'package:bookkeping_mobile/screens/deposit_form.dart';
import 'package:bookkeping_mobile/screens/deposit_list.dart';
import 'package:bookkeping_mobile/screens/home/balance_element.dart';

import 'package:bookkeping_mobile/screens/home/purchase_element.dart';
import 'package:bookkeping_mobile/screens/purchase_form.dart';
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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _tabIndex = _tabController.index;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<PurchaseBloc>(context).add(LoadPurchases());
      BlocProvider.of<BalanceBloc>(context).add(BalanceLoad());
      BlocProvider.of<DepositBloc>(context).add(LoadDeposits(1));
    });
    super.initState();
  }

  late TabController _tabController;
  int _tabIndex = 0;

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
                  Icon(Icons.logout, color: coralColor),
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
      floatingActionButton: _tabIndex != 2 ? ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(15),
            primary: greenColor.withOpacity(0.4),
        ),
        child: Icon(Icons.add),
        onPressed: () {
          DateTime now = DateTime.now();
          switch (_tabIndex) {
            case 0:
              BlocProvider.of<PurchaseBloc>(context).add(PurchaseDateChanged(now));
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PurchaseFormScreen()
                )
              );
              break;
            case 1:
              BlocProvider.of<DepositBloc>(context).add(DepositDateChanged(now));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DepositFormScreen()
                  )
              );
              break;
          }
        },
      ) : null,
      appBar: AppBar(
        title: Text(''),),
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
            const SizedBox(height: 15),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.grey
                      ),
                      child: BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            return ToggleButtons(
                                constraints: BoxConstraints(
                                    minWidth: (MediaQuery.of(context).size.width - 35) / 2,
                                    minHeight: 30
                                ),
                                children: [
                                  Text('Прошедшие'),
                                  Text('Будущие')
                                ],
                                onPressed: (int index) {
                                  BlocProvider.of<HomeBloc>(context).add(ChangeWhatTransactionsView(index));
                                },
                                borderWidth: 0,
                                borderRadius: const BorderRadius.all(Radius.circular(3)),
                                selectedColor: Colors.white,
                                fillColor: greenColor,
                                color: greenColor,
                                isSelected: state.viewTransactions
                            );
                          }
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TabBar(
                      indicatorColor: coralColor,
                      labelColor: coralColor,
                      unselectedLabelColor: Colors.grey,
                      controller: _tabController,
                      tabs: [
                        Tab(text: 'Траты'),
                        Tab(text: 'Пополнения'),
                        Tab(text: 'Все')
                      ],
                    ),
                  ),
                  Container(
                    child: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
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
                                        child: Text(
                                            'Еще',
                                            style: TextStyle(
                                              color: coralColor
                                            ),
                                        )
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
                                    for (Purchase purchase in state.firstTenPurchase)
                                      TransactionElement(
                                        title: purchase.title,
                                        amount: purchase.amount,
                                        date: purchase.date,
                                        onTap: () {},
                                      )
                                  ],
                                );
                              }
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BlocBuilder<DepositBloc, DepositState>(
                                  builder: (context, state) {
                                    return state.depositList.length > 10 ?
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => DepositListScreen()
                                              )
                                          );
                                        },
                                        child: Text(
                                          'Еще',
                                          style: TextStyle(
                                              color: coralColor
                                          ),
                                        )
                                    ) :
                                    SizedBox();
                                  },
                                ),
                              ],
                            ),
                          ),
                          BlocBuilder<DepositBloc, DepositState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    for (Deposit deposit in state.depositList)
                                      TransactionElement(
                                          title: deposit.title,
                                          amount: deposit.amount,
                                          date: deposit.date,
                                          onTap: () {}
                                      )
                                  ],
                                );
                              }
                          )
                        ],
                      ),
                      Text('coming soon')
                    ][_tabIndex],
                  ),
                  SizedBox(height: 40,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}