import 'package:bookkeping_mobile/balance/bloc.dart';
import 'package:bookkeping_mobile/balance/state.dart';
import 'package:bookkeping_mobile/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AllAccountsCard extends StatelessWidget {
  const AllAccountsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceBloc, BalanceState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
          decoration: BoxDecoration(
            color: greenColor,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Общий баланс',
                  style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.white
                  )
              ),
              Text(
                  '${NumberFormat('#,###').format(state.balance).toString().replaceAll(',', ' ')} ₽',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.white
                  )
              )
            ],
          ),
        );
      }
    );
  }
}
