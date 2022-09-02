import 'package:bookkeping_mobile/constants.dart';
import 'package:bookkeping_mobile/deposit/bloc.dart';
import 'package:bookkeping_mobile/deposit/entity.dart';
import 'package:bookkeping_mobile/deposit/event.dart';
import 'package:bookkeping_mobile/deposit/state.dart';
import 'package:bookkeping_mobile/screens/deposit_form.dart';
import 'package:bookkeping_mobile/screens/home/transaction_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepositListScreen extends StatelessWidget {
  const DepositListScreen({Key? key}) : super(key: key);

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
          BlocProvider.of<DepositBloc>(context).add(DepositDateChanged(DateTime.now()));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DepositFormScreen()
              )
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<DepositBloc>(context).add(LoadDeposits(1));
        },
        child: ListView(
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<DepositBloc, DepositState>(
                    builder: (context, state) {
                      return IconButton(
                          onPressed: state.page > 1 ? () {
                            BlocProvider.of<DepositBloc>(context).add(LoadDeposits(state.page - 1));
                          } : null,
                          icon: Icon(Icons.chevron_left)
                      );
                    }
                ),
                BlocBuilder<DepositBloc, DepositState>(
                    builder: (context, state) {
                      return Text('${state.page.toString()} страница');
                    }
                ),
                BlocBuilder<DepositBloc, DepositState>(
                    builder: (context, state) {
                      return IconButton(
                          onPressed: state.canTapPrevButton ? () {
                            BlocProvider.of<DepositBloc>(context).add(LoadDeposits(state.page + 1));
                          } : null,
                          icon: Icon(Icons.chevron_right)
                      );
                    }
                )
              ],
            ),
            BlocBuilder<DepositBloc, DepositState>(
                builder: (context, state) {
                  return state.isLoading ? Center(child: CircularProgressIndicator()) : Column(
                    children: [
                      for (Deposit deposit in state.depositList)
                        TransactionElement(
                          onTap: () {
                            BlocProvider.of<DepositBloc>(context).add(DepositAmountChanged(deposit.amount.toString()));
                            BlocProvider.of<DepositBloc>(context).add(DepositTitleChanged(deposit.title));
                            BlocProvider.of<DepositBloc>(context).add(DepositDateChanged(deposit.date));
                            BlocProvider.of<DepositBloc>(context).add(DepositIdChanged(deposit.id));
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => DepositFormScreen())
                            );
                          },
                          date: deposit.date,
                          amount: deposit.amount,
                          title: deposit.title,
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
