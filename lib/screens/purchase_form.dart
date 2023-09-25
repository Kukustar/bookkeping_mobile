import 'package:bookkeping_mobile/balance/bloc.dart';
import 'package:bookkeping_mobile/balance/event.dart';
import 'package:bookkeping_mobile/constants.dart';
import 'package:bookkeping_mobile/purchase/entity.dart';
import 'package:bookkeping_mobile/purchase/purchase_bloc.dart';
import 'package:bookkeping_mobile/purchase/purchase_event.dart';
import 'package:bookkeping_mobile/purchase/purchase_state.dart';
import 'package:bookkeping_mobile/ui/widgets/calendar_builder.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<PurchaseBloc, PurchaseState>(
      listener: (context, state) {
        if (state.successSaved) {
          BlocProvider.of<PurchaseBloc>(context).add(ClearPurchaseForm());
          BlocProvider.of<PurchaseBloc>(context).add(LoadPurchases(state.page));
          BlocProvider.of<BalanceBloc>(context).add(BalanceLoad());
          Navigator.pop(
              context
          );
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
                List<DropdownMenuItem<String>> options = state.purchaseTypeList.map((e) => DropdownMenuItem(child: Text(e.title), value: e.title)).toList();
                List<PurchaseType> res = state.purchaseTypeList.where((element) => element.id == state.formStatePurchaseTypeId).toList();

                String selectedOption = 'default';
                if (res.isNotEmpty) {
                  selectedOption = res.first.title;
                }

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
                      DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(color: paleGreenColor, width:1), //border of dropdown button
                            borderRadius: BorderRadius.circular(5), //border raiud  §s of dropdown button

                        ),
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  hint: Text('Категория', style: TextStyle(color: Colors.grey),),
                                  isExpanded: true,
                                  items: options,
                                  value: selectedOption,
                                  onChanged: (e) {
                                    int id = state.purchaseTypeList.where((element) => element.title == e).first.id;
                                    BlocProvider.of<PurchaseBloc>(context).add(PurchaseTypeChanged(id));

                                    if (state.formStateTitle == '') {
                                      BlocProvider.of<PurchaseBloc>(context).add(PurchaseTitleChanged(e.toString()));
                                      titleEditing.text = e.toString();
                                    }
                                  }
                              ),
                            )
                        ),
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
                              builder: (context, child) {
                                return CalendarBuilder(child: child as Widget);
                              }
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
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  state.isFormUpdate
                                      ? BlocProvider.of<PurchaseBloc>(context).add(PurchaseUpdate())
                                      : BlocProvider.of<PurchaseBloc>(context).add(AddPurchase());
                                },
                                child: state.isFormUpdate ? Text('Обновить') : Text('Добавить')
                            ),
                          ),
                          if (state.purchaseId != 0)
                          SizedBox(width: 10,),
                          if (state.purchaseId != 0)
                          ElevatedButton(
                              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                                  backgroundColor: MaterialStateProperty.all(coralColor)
                              ),
                              onPressed: () {
                                BlocProvider.of<PurchaseBloc>(context).add(PurchaseDelete());
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
