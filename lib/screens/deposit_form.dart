import 'package:bookkeping_mobile/balance/bloc.dart';
import 'package:bookkeping_mobile/balance/event.dart';
import 'package:bookkeping_mobile/constants.dart';
import 'package:bookkeping_mobile/deposit/bloc.dart';
import 'package:bookkeping_mobile/deposit/event.dart';
import 'package:bookkeping_mobile/deposit/state.dart';
import 'package:bookkeping_mobile/purchase/purchase_bloc.dart';
import 'package:bookkeping_mobile/purchase/purchase_event.dart';
import 'package:bookkeping_mobile/purchase/purchase_state.dart';
import 'package:bookkeping_mobile/service/core/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepositFormScreen extends StatefulWidget {
  const DepositFormScreen({Key? key}) : super(key: key);

  @override
  State<DepositFormScreen> createState() => _DepositFormScreenState();
}

class _DepositFormScreenState extends State<DepositFormScreen> {

  TextEditingController amountEditing = TextEditingController();
  TextEditingController titleEditing = TextEditingController();

  @override
  void initState () {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (BlocProvider.of<DepositBloc>(context).state.depositId != 0) {
        amountEditing.text = BlocProvider.of<DepositBloc>(context).state.formStateAmount;
        titleEditing.text = BlocProvider.of<DepositBloc>(context).state.formStateTitle;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DepositBloc, DepositState>(
      listener: (context, state) {
        if (state.saveResponseStatus == NetworkResponseStatus.success) {
          BlocProvider.of<DepositBloc>(context).add(ClearDepositForm());
          BlocProvider.of<DepositBloc>(context).add(LoadDeposits(state.page));
          BlocProvider.of<BalanceBloc>(context).add(BalanceLoad());
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  BlocProvider.of<DepositBloc>(context).add(ClearDepositForm());
                  Navigator.pop(context);
                },
                icon: Icon(Icons.chevron_left),
              ),
              title: BlocBuilder<DepositBloc, DepositState>(
                  builder: (context, state) {
                    return state.depositId != 0
                        ? Text(
                          state.formStateTitle,
                          style: TextStyle(
                            color: Colors.black
                          ),
                        )
                        : Text(
                          'Добавить пополение',
                          style: TextStyle(
                            color: Colors.black
                          ),
                        );
                  }
              )
          ),
          body: SingleChildScrollView(
            child: BlocBuilder<DepositBloc, DepositState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 30,),
                        TextField(
                          controller: amountEditing,
                          decoration: InputDecoration(
                              labelText: 'Сумма',
                              errorText: state.formStateAmountError == '' ? null : state.formStateAmountError
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            BlocProvider.of<DepositBloc>(context).add(DepositAmountChanged(value));
                          },
                        ),
                        SizedBox(height: 26,),
                        TextField(
                          controller: titleEditing,
                          decoration: InputDecoration(
                              labelText: 'Описание',
                              errorText: state.formStateTitleError == '' ? null : state.formStateTitleError
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            BlocProvider.of<DepositBloc>(context).add(DepositTitleChanged(value));
                          },
                        ),
                        SizedBox(height: 26,),
                        TextField(
                          controller: state.formStateDateTimeController,
                          readOnly: true,
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                              locale: Locale('ru'),
                              context: context,
                              initialDate: state.formStateDate as DateTime,
                              firstDate: DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
                              lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
                            );
                            if (date != null) {
                              BlocProvider.of<DepositBloc>(context).add(DepositDateChanged(date));
                            }
                          },
                        ),
                        SizedBox(height: 26,),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(

                                  onPressed: () {
                                    state.depositId != 0
                                        ? BlocProvider.of<DepositBloc>(context).add(UpdateDeposit())
                                        : BlocProvider.of<DepositBloc>(context).add(AddNewDeposit());
                                  },
                                  child: state.depositId != 0 ? Text('Обновить') : Text('Добавить')
                              ),
                            ),
                            if (state.depositId != 0)
                              SizedBox(width: 10,),
                            if (state.depositId != 0)
                              ElevatedButton(
                                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                                  backgroundColor: MaterialStateProperty.all(coralColor)
                                ),
                                onPressed: () {
                                  BlocProvider.of<DepositBloc>(context).add(DeleteDeposit());
                                },
                                child: Text('Удалить')
                              )
                          ],
                        ),


                      ],
                    ),
                  ) ;
                }
            ),
          ),
        ),
      ),
    );
  }
}
