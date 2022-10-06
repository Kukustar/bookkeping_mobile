import 'package:bookkeping_mobile/balance/bloc.dart';
import 'package:bookkeping_mobile/balance/event.dart';
import 'package:bookkeping_mobile/constants.dart';
import 'package:bookkeping_mobile/purchase/purchase_bloc.dart';
import 'package:bookkeping_mobile/purchase/purchase_event.dart';
import 'package:bookkeping_mobile/purchase/purchase_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseFormScreen extends StatefulWidget {
  const PurchaseFormScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseFormScreen> createState() => _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends State<PurchaseFormScreen> {

  TextEditingController amountEditing = TextEditingController();
  TextEditingController titleEditing = TextEditingController();

  @override
  void initState () {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TextEditingController controller = TextEditingController();
      BlocProvider.of<PurchaseBloc>(context).add(PurchaseDateFormControllerAdd(controller));

      if (BlocProvider.of<PurchaseBloc>(context).state.isFormUpdate) {
        amountEditing.text = BlocProvider.of<PurchaseBloc>(context).state.formStateAmount;
        titleEditing.text = BlocProvider.of<PurchaseBloc>(context).state.formStateTitle;
      }
    });
    super.initState();
  }
  void onSuccess(context) {
    BlocProvider.of<PurchaseBloc>(context).add(ClearPurchaseForm());
    BlocProvider.of<PurchaseBloc>(context).add(LoadPurchases());
    BlocProvider.of<BalanceBloc>(context).add(BalanceLoad());
    Navigator.pop(context);
  }

  void submitPressed (bool isFormUpdate, context) {
    if (isFormUpdate) {
      BlocProvider.of<PurchaseBloc>(context).add(PurchaseUpdate(() => onSuccess(context)));
    } else {
      BlocProvider.of<PurchaseBloc>(context).add(AddPurchase(() => onSuccess(context)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                BlocProvider.of<PurchaseBloc>(context).add(ClearPurchaseForm());
                Navigator.pop(context);
              },
              icon: Icon(Icons.chevron_left),
            ),
            title: BlocBuilder<PurchaseBloc, PurchaseState>(
              builder: (context, state) {
                return state.isFormUpdate ? Text(
                    state.formStateTitle,
                    style: TextStyle(
                      color: Colors.black
                    ),
                ) : Text(
                    'Добавить покупку',
                    style: TextStyle(color: Colors.black),
                );
              }
            )
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<PurchaseBloc, PurchaseState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    TextField(
                      controller: amountEditing,
                      autofocus: state.purchaseId == 0,
                      decoration: InputDecoration(
                        labelText: 'Сумма',
                        errorText: state.formStateAmountError == '' ? null : state.formStateAmountError
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        BlocProvider.of<PurchaseBloc>(context).add(PurchaseAmountChanged(value));
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
                        BlocProvider.of<PurchaseBloc>(context).add(PurchaseTitleChanged(value));
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
                          BlocProvider.of<PurchaseBloc>(context).add(PurchaseDateChanged(date));
                        }
                      },
                    ),
                    SizedBox(height: 26,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (state.purchaseId != 0)
                        ElevatedButton(
                            style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                                backgroundColor: MaterialStateProperty.all(coralColor)
                            ),
                            onPressed: () {
                              BlocProvider.of<PurchaseBloc>(context).add(PurchaseDelete(() => onSuccess(context)));
                            },
                            child: Text('Удалить')
                        ),
                        if (state.purchaseId != 0)
                          SizedBox(width: 10,),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                submitPressed(state.isFormUpdate, context);
                              },
                              child: state.isFormUpdate ? Text('Обновить') : Text('Добавить')
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ) ;
            }
          ),
        ),
      ),
    );
  }
}
