import 'package:bookkeping_mobile/purchase/entity.dart';
import 'package:bookkeping_mobile/purchase/purchase_bloc.dart';
import 'package:bookkeping_mobile/purchase/purchase_event.dart';
import 'package:bookkeping_mobile/purchase/purchase_state.dart';
import 'package:bookkeping_mobile/screens/add_purchase.dart';
import 'package:bookkeping_mobile/screens/home/purchase_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseListScreen extends StatelessWidget {
  const PurchaseListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: EdgeInsets.all(24),
          primary: Colors.transparent,
          surfaceTintColor: Colors.blue
        ),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddPurchaseScreen()
              )
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    return Text('${state.page.toString()} страница');
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
                  return state.isPurchasePageLoading ? Center(child: CircularProgressIndicator()) : Column(
                    children: [
                      for (Purchase purchase in state.purchaseList)
                        PurchaseElement(
                          date: purchase.date,
                          amount: purchase.amount,
                          title: purchase.title,
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