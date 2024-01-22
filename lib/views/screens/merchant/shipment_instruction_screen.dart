import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/helpers/formatter.dart';
import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShipmentInstructionScreen extends StatefulWidget {
  final Shipment shipment;
  ShipmentInstructionScreen({
    Key? key,
    required this.shipment,
  }) : super(key: key);

  @override
  State<ShipmentInstructionScreen> createState() =>
      _ShipmentInstructionScreenState();
}

class _ShipmentInstructionScreenState extends State<ShipmentInstructionScreen> {
  final FocusNode _orderTypenode = FocusNode();
  var key1 = GlobalKey();
  String selectedRadioTile = "";

  TextEditingController charger_name_controller = TextEditingController();
  TextEditingController charger_address_controller = TextEditingController();
  TextEditingController charger_phone_controller = TextEditingController();

  TextEditingController reciever_name_controller = TextEditingController();
  TextEditingController reciever_address_controller = TextEditingController();
  TextEditingController reciever_phone_controller = TextEditingController();

  TextEditingController loading_info_controller = TextEditingController();
  TextEditingController unloading_info_controller = TextEditingController();

  TextEditingController truck_number_controller = TextEditingController();
  TextEditingController truck_type_controller = TextEditingController();
  TextEditingController owner_name_controller = TextEditingController();
  TextEditingController total_weight_controller = TextEditingController();
  TextEditingController net_weight_controller = TextEditingController();
  TextEditingController truck_weight_controller = TextEditingController();
  TextEditingController final_weight_controller = TextEditingController();

  List<TextEditingController> commodityName_controller = [];
  List<TextEditingController> commodityWeight_controller = [];
  List<TextEditingController> commodityQuantity_controller = [];
  List<TextEditingController> packageType_controller = [];

  @override
  void initState() {
    super.initState();
    for (var element in widget.shipment.shipmentItems!) {
      commodityName_controller
          .add(TextEditingController(text: element.commodityName));
      commodityWeight_controller
          .add(TextEditingController(text: element.commodityWeight.toString()));
      commodityQuantity_controller.add(TextEditingController());
      packageType_controller.add(TextEditingController());
    }
  }

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
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    value: "T",
                                    groupValue: selectedRadioTile,
                                    title: const FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "merchant",
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
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
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    value: "M",
                                    groupValue: selectedRadioTile,
                                    title: const FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "mediator",
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
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
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.zero,

                                    value: "R",
                                    groupValue: selectedRadioTile,
                                    title: const FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "reciever",
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
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
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 7.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: charger_name_controller,
                            onTap: () {
                              charger_name_controller.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: charger_name_controller
                                      .value.text.length);
                            },
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50),
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              labelText: "charger name",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 11.0, horizontal: 9.0),
                            ),
                            onTapOutside: (event) {},
                            onEditingComplete: () {
                              // evaluatePrice();
                            },
                            onChanged: (value) {},
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .translate('insert_value_validate');
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              charger_name_controller.text = newValue!;
                            },
                            onFieldSubmitted: (value) {},
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: charger_address_controller,
                            onTap: () {
                              charger_address_controller.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: charger_address_controller
                                          .value.text.length);
                            },
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50),
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              labelText: "charger address",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 11.0, horizontal: 9.0),
                            ),
                            onTapOutside: (event) {
                              // FocusManager.instance.primaryFocus?.unfocus();
                              // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                            },
                            onEditingComplete: () {
                              // evaluatePrice();
                            },
                            onChanged: (value) {},
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .translate('insert_value_validate');
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              // commodityWeight_controller.text = newValue!;
                            },
                            onFieldSubmitted: (value) {
                              // FocusManager.instance.primaryFocus?.unfocus();
                              // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: charger_phone_controller,
                            onTap: () {
                              charger_phone_controller.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: charger_phone_controller
                                          .value.text.length);
                            },
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50),
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              labelText: "charger phone",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 11.0, horizontal: 9.0),
                            ),
                            onTapOutside: (event) {
                              // FocusManager.instance.primaryFocus?.unfocus();
                              // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                            },
                            onEditingComplete: () {
                              // evaluatePrice();
                            },
                            onChanged: (value) {},
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .translate('insert_value_validate');
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              // commodityWeight_controller.text = newValue!;
                            },
                            onFieldSubmitted: (value) {
                              // FocusManager.instance.primaryFocus?.unfocus();
                              // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 7.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: reciever_name_controller,
                            onTap: () {
                              reciever_name_controller.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: reciever_name_controller
                                          .value.text.length);
                            },
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50),
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              labelText: "reciever name",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 11.0, horizontal: 9.0),
                            ),
                            onTapOutside: (event) {},
                            onEditingComplete: () {
                              // evaluatePrice();
                            },
                            onChanged: (value) {},
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .translate('insert_value_validate');
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              reciever_name_controller.text = newValue!;
                            },
                            onFieldSubmitted: (value) {},
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: reciever_address_controller,
                            onTap: () {
                              reciever_address_controller.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: reciever_address_controller
                                          .value.text.length);
                            },
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50),
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              labelText: "reciever address",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 11.0, horizontal: 9.0),
                            ),
                            onTapOutside: (event) {
                              // FocusManager.instance.primaryFocus?.unfocus();
                              // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                            },
                            onEditingComplete: () {
                              // evaluatePrice();
                            },
                            onChanged: (value) {},
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .translate('insert_value_validate');
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              // commodityWeight_controller.text = newValue!;
                            },
                            onFieldSubmitted: (value) {
                              // FocusManager.instance.primaryFocus?.unfocus();
                              // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: reciever_phone_controller,
                            onTap: () {
                              reciever_phone_controller.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: reciever_phone_controller
                                          .value.text.length);
                            },
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50),
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              labelText: "reciever phone",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 11.0, horizontal: 9.0),
                            ),
                            onTapOutside: (event) {
                              // FocusManager.instance.primaryFocus?.unfocus();
                              // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                            },
                            onEditingComplete: () {
                              // evaluatePrice();
                            },
                            onChanged: (value) {},
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .translate('insert_value_validate');
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              // commodityWeight_controller.text = newValue!;
                            },
                            onFieldSubmitted: (value) {
                              // FocusManager.instance.primaryFocus?.unfocus();
                              // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 7.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: loading_info_controller,
                            onTap: () {
                              loading_info_controller.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: loading_info_controller
                                      .value.text.length);
                            },
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50),
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              labelText: "loading info",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 11.0, horizontal: 9.0),
                            ),
                            onTapOutside: (event) {},
                            onEditingComplete: () {
                              // evaluatePrice();
                            },
                            onChanged: (value) {},
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .translate('insert_value_validate');
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              loading_info_controller.text = newValue!;
                            },
                            onFieldSubmitted: (value) {},
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: unloading_info_controller,
                            onTap: () {
                              unloading_info_controller.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: unloading_info_controller
                                          .value.text.length);
                            },
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50),
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              labelText: "unloading site",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 11.0, horizontal: 9.0),
                            ),
                            onTapOutside: (event) {
                              // FocusManager.instance.primaryFocus?.unfocus();
                              // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                            },
                            onEditingComplete: () {
                              // evaluatePrice();
                            },
                            onChanged: (value) {},
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .translate('insert_value_validate');
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              // commodityWeight_controller.text = newValue!;
                            },
                            onFieldSubmitted: (value) {
                              // FocusManager.instance.primaryFocus?.unfocus();
                              // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ListView.builder(
                    itemCount: widget.shipment.shipmentItems!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.all(5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 7.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: commodityName_controller[index],
                                onTap: () {
                                  commodityName_controller[index].selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset:
                                              commodityName_controller[index]
                                                  .value
                                                  .text
                                                  .length);
                                },
                                scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom +
                                        50),
                                textInputAction: TextInputAction.done,
                                style: const TextStyle(fontSize: 18),
                                decoration: const InputDecoration(
                                  labelText: "commodity name",
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 11.0, horizontal: 9.0),
                                ),
                                onTapOutside: (event) {},
                                onEditingComplete: () {
                                  // evaluatePrice();
                                },
                                onChanged: (value) {},
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate('insert_value_validate');
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  commodityName_controller[index].text =
                                      newValue!;
                                },
                                onFieldSubmitted: (value) {},
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                controller: commodityWeight_controller[index],
                                onTap: () {
                                  commodityWeight_controller[index].selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset:
                                              commodityWeight_controller[index]
                                                  .value
                                                  .text
                                                  .length);
                                },
                                scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom +
                                        50),
                                textInputAction: TextInputAction.done,
                                style: const TextStyle(fontSize: 18),
                                decoration: const InputDecoration(
                                  labelText: "commodity weight",
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 11.0, horizontal: 9.0),
                                ),
                                onTapOutside: (event) {
                                  // FocusManager.instance.primaryFocus?.unfocus();
                                  // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                                },
                                onEditingComplete: () {
                                  // evaluatePrice();
                                },
                                onChanged: (value) {},
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate('insert_value_validate');
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  // commodityWeight_controller.text = newValue!;
                                },
                                onFieldSubmitted: (value) {
                                  // FocusManager.instance.primaryFocus?.unfocus();
                                  // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                controller: commodityQuantity_controller[index],
                                onTap: () {
                                  commodityQuantity_controller[index]
                                          .selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset:
                                              commodityQuantity_controller[
                                                      index]
                                                  .value
                                                  .text
                                                  .length);
                                },
                                scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom +
                                        50),
                                textInputAction: TextInputAction.done,
                                style: const TextStyle(fontSize: 18),
                                decoration: const InputDecoration(
                                  labelText: "commodity quantity",
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 11.0, horizontal: 9.0),
                                ),
                                onTapOutside: (event) {
                                  // FocusManager.instance.primaryFocus?.unfocus();
                                  // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                                },
                                onEditingComplete: () {
                                  // evaluatePrice();
                                },
                                onChanged: (value) {},
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate('insert_value_validate');
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  // commodityWeight_controller.text = newValue!;
                                },
                                onFieldSubmitted: (value) {
                                  // FocusManager.instance.primaryFocus?.unfocus();
                                  // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 7.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .45,
                                child: TextFormField(
                                  controller: truck_number_controller,
                                  onTap: () {
                                    truck_number_controller.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset:
                                                truck_number_controller
                                                    .value.text.length);
                                  },
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          50),
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    labelText: "truck number",
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 11.0, horizontal: 9.0),
                                  ),
                                  onTapOutside: (event) {},
                                  onEditingComplete: () {
                                    // evaluatePrice();
                                  },
                                  onChanged: (value) {},
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .translate('insert_value_validate');
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    truck_number_controller.text = newValue!;
                                  },
                                  onFieldSubmitted: (value) {},
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .45,
                                child: TextFormField(
                                  controller: truck_type_controller,
                                  onTap: () {
                                    truck_type_controller.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset: truck_type_controller
                                                .value.text.length);
                                  },
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          50),
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    labelText: "truck type",
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 11.0, horizontal: 9.0),
                                  ),
                                  onTapOutside: (event) {},
                                  onEditingComplete: () {
                                    // evaluatePrice();
                                  },
                                  onChanged: (value) {},
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .translate('insert_value_validate');
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    truck_type_controller.text = newValue!;
                                  },
                                  onFieldSubmitted: (value) {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .45,
                                child: TextFormField(
                                  controller: total_weight_controller,
                                  onTap: () {
                                    total_weight_controller.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset:
                                                total_weight_controller
                                                    .value.text.length);
                                  },
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          50),
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    labelText: "total weight",
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 11.0, horizontal: 9.0),
                                  ),
                                  onTapOutside: (event) {},
                                  onEditingComplete: () {
                                    // evaluatePrice();
                                  },
                                  onChanged: (value) {},
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .translate('insert_value_validate');
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    total_weight_controller.text = newValue!;
                                  },
                                  onFieldSubmitted: (value) {},
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .45,
                                child: TextFormField(
                                  controller: net_weight_controller,
                                  onTap: () {
                                    net_weight_controller.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset: net_weight_controller
                                                .value.text.length);
                                  },
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          50),
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    labelText: "net weight",
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 11.0, horizontal: 9.0),
                                  ),
                                  onTapOutside: (event) {},
                                  onEditingComplete: () {
                                    // evaluatePrice();
                                  },
                                  onChanged: (value) {},
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .translate('insert_value_validate');
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    net_weight_controller.text = newValue!;
                                  },
                                  onFieldSubmitted: (value) {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .45,
                                child: TextFormField(
                                  controller: truck_weight_controller,
                                  onTap: () {
                                    truck_weight_controller.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset:
                                                truck_weight_controller
                                                    .value.text.length);
                                  },
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          50),
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    labelText: "truck weight",
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 11.0, horizontal: 9.0),
                                  ),
                                  onTapOutside: (event) {},
                                  onEditingComplete: () {
                                    // evaluatePrice();
                                  },
                                  onChanged: (value) {},
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .translate('insert_value_validate');
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    truck_weight_controller.text = newValue!;
                                  },
                                  onFieldSubmitted: (value) {},
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .45,
                                child: TextFormField(
                                  controller: final_weight_controller,
                                  onTap: () {
                                    final_weight_controller.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset:
                                                final_weight_controller
                                                    .value.text.length);
                                  },
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          50),
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    labelText: "final weight",
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 11.0, horizontal: 9.0),
                                  ),
                                  onTapOutside: (event) {},
                                  onEditingComplete: () {
                                    // evaluatePrice();
                                  },
                                  onChanged: (value) {},
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .translate('insert_value_validate');
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    final_weight_controller.text = newValue!;
                                  },
                                  onFieldSubmitted: (value) {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
