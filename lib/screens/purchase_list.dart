import 'package:bookkeping_mobile/constants.dart';
import 'package:bookkeping_mobile/extensions.dart';
import 'package:bookkeping_mobile/purchase/entity.dart';
import 'package:bookkeping_mobile/purchase/purchase_bloc.dart';
import 'package:bookkeping_mobile/purchase/purchase_event.dart';
import 'package:bookkeping_mobile/purchase/purchase_state.dart';
import 'package:bookkeping_mobile/screens/purchase_form.dart';
import 'package:bookkeping_mobile/screens/home/transaction_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseListScreen extends StatelessWidget {
  const PurchaseListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left),
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(15),
          primary: greenColor.withOpacity(0.4),
        ),
        child: Icon(Icons.add),
        onPressed: () {
          BlocProvider.of<PurchaseBloc>(context).add(PurchaseDateChanged(DateTime.now()));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PurchaseFormScreen()
              )
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<PurchaseBloc>(context).add(LoadPage(1));
        },
        child: ListView(
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<PurchaseBloc, PurchaseState>(
                  builder: (context, state) {
                    return IconButton(
                        onPressed: state.page > 1 ? () {
                          BlocProvider.of<PurchaseBloc>(context).add(LoadPage(state.page - 1));
                        } : null,
                        icon: Icon(Icons.chevron_left)
                    );
                  }
                ),
                BlocBuilder<PurchaseBloc, PurchaseState>(
                  builder: (context, state) {
                    return Text(
                      state.fromToHeader,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: greenColor
                      ),
                    );
                  }
                ),
                BlocBuilder<PurchaseBloc, PurchaseState>(
                  builder: (context, state) {
                    return IconButton(
                        onPressed: state.canTapPrevButton ? () {
                          BlocProvider.of<PurchaseBloc>(context).add(LoadPage(state.page + 1));
                        } : null,
                        icon: Icon(Icons.chevron_right)
                    );
                  }
                )
              ],
            ),
            BlocBuilder<PurchaseBloc, PurchaseState>(
                builder: (context, state) {
                  DateTime now = DateTime.now();
                  return state.isPurchasePageLoading ? Center(child: CircularProgressIndicator()) : Column(
                    children: [
                      for (String date in state.purchaseListDates)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                  DateTime.parse(date).isSameDate(now) ? 'Сегодня' : DateTime.now().isYesterday(DateTime.parse(date)) ? 'Вчера' : date,
                                  style: Theme.of(context).textTheme.headline6!.copyWith(
                                    color: paleGreenColor
                                  ),
                              ),
                            ),
                            Column(
                              children: [
                                for (Purchase purchase in state.purchaseList.where((element) => element.date.isSameDate(DateTime.parse(date))))
                                  TransactionElement(
                                    onTap: () {
                                      BlocProvider.of<PurchaseBloc>(context).add(PurchaseAmountChanged(purchase.amount.toString()));
                                      BlocProvider.of<PurchaseBloc>(context).add(PurchaseTitleChanged(purchase.title));
                                      BlocProvider.of<PurchaseBloc>(context).add(PurchaseDateChanged(purchase.date));
                                      BlocProvider.of<PurchaseBloc>(context).add(IsFormUpdateChanged(true));
                                      BlocProvider.of<PurchaseBloc>(context).add(PurchaseIdChanged(purchase.id));
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => PurchaseFormScreen())
                                      );
                                    },
                                    date: purchase.date,
                                    amount: purchase.amount,
                                    title: purchase.title,
                                  )
                              ],
                            ),
                          ],
                        )
                    ],
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
