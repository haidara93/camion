import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final FocusNode _orderTypenode = FocusNode();
  var key1 = GlobalKey();
  String selectedRadioTile = "";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
            textDirection: localeState.value.languageCode == 'en'
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    EnsureVisibleWhenFocused(
                      focusNode: _orderTypenode,
                      child: Card(
                        key: key1,
                        margin: const EdgeInsets.symmetric(vertical: 7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("select ",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.darkGrey,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .3,
                                    child: RadioListTile(
                                      contentPadding: EdgeInsets.zero,
                                      value: "T",
                                      groupValue: selectedRadioTile,
                                      title: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "merchant",
                                          overflow: TextOverflow.fade,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      // subtitle: Text("Radio 1 Subtitle"),
                                      onChanged: (val) {
                                        // print("Radio Tile pressed $val");
                                        setState(() {
                                          selectedRadioTile = val!;
                                        });
                                      },
                                      activeColor: AppColor.deepYellow,
                                      selected: selectedRadioTile == "T",
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .3,
                                    child: RadioListTile(
                                      contentPadding: EdgeInsets.zero,
                                      value: "M",
                                      groupValue: selectedRadioTile,
                                      title: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "mediator",
                                          overflow: TextOverflow.fade,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      // subtitle: Text("Radio 1 Subtitle"),
                                      onChanged: (val) {
                                        // print("Radio Tile pressed $val");
                                        setState(() {
                                          selectedRadioTile = val!;
                                        });
                                      },
                                      activeColor: AppColor.deepYellow,
                                      selected: selectedRadioTile == "M",
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .3,
                                    child: RadioListTile(
                                      contentPadding: EdgeInsets.zero,

                                      value: "R",
                                      groupValue: selectedRadioTile,
                                      title: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "reciever",
                                          overflow: TextOverflow.fade,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      // subtitle: Text("Radio 2 Subtitle"),
                                      onChanged: (val) {
                                        // print("Radio Tile pressed $val");
                                        setState(() {
                                          selectedRadioTile = val!;
                                        });
                                      },
                                      activeColor: AppColor.deepYellow,

                                      selected: selectedRadioTile == "R",
                                    ),
                                  ),
                                ],
                              ),
                              // Visibility(
                              //   visible: showtypeError,
                              //   child: Text(
                              //     AppLocalizations.of(context)!
                              //         .translate('select_operation_type_error'),
                              //     style: const TextStyle(color: Colors.red),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
