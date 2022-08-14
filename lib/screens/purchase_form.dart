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
                return state.isFormUpdate ? Text(state.formStateTitle) : Text('Добавить покупку');
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
                    SizedBox(height: 100,),
                    TextField(
                      controller: amountEditing,
                      decoration: InputDecoration(
                        labelText: 'Сумма',
                        errorText: state.formStateAmountError == '' ? null : state.formStateAmountError
                      ),
                      keyboardType: TextInputType.number,
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
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 20))
                              ),
                              onPressed: () {
                                state.isFormUpdate
                                    ? BlocProvider.of<PurchaseBloc>(context).add(PurchaseUpdate())
                                    : BlocProvider.of<PurchaseBloc>(context).add(AddPurchase());
                              },
                              child: Text('Добавить')
                          ),
                        ),
                      ],
                    )
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
