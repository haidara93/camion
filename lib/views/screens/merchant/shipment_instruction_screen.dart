import 'dart:convert';

import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/instructions/instruction_create_bloc.dart';
import 'package:camion/business_logic/bloc/package_type_bloc.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/models/instruction_model.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/helpers/formatter.dart';
import 'package:camion/views/screens/control_view.dart';
import 'package:camion/views/widgets/custom_app_bar.dart';
import 'package:camion/views/widgets/custom_botton.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  List<PackageType?> packageType_controller = [];
  final GlobalKey<FormState> _addShipmentformKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    for (var element in widget.shipment.shipmentItems!) {
      commodityName_controller
          .add(TextEditingController(text: element.commodityName));
      commodityWeight_controller
          .add(TextEditingController(text: element.commodityWeight.toString()));
      commodityQuantity_controller.add(TextEditingController());
      packageType_controller.add(null);
    }

    loading_info_controller.text = widget.shipment.pickupCityLocation!;
    unloading_info_controller.text = widget.shipment.deliveryCityLocation!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
          textDirection: localeState.value.languageCode == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                title: "shipment instruction",
              ),
              backgroundColor: Colors.grey[200],
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _addShipmentformKey,
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
                                      Text("select your identity",
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
                                            MediaQuery.of(context).size.width *
                                                .3,
                                        child: RadioListTile(
                                          contentPadding: EdgeInsets.zero,
                                          value: "C",
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
                                          selected: selectedRadioTile == "C",
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .3,
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .3,
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
                        Visibility(
                          visible: selectedRadioTile.isEmpty ||
                              selectedRadioTile == "M" ||
                              selectedRadioTile == "R",
                          child: Column(
                            children: [
                              Card(
                                color: Colors.white,
                                margin: const EdgeInsets.all(5),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 7.5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Charger Info",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.darkGrey,
                                              )),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: charger_name_controller,
                                        onTap: () {
                                          charger_name_controller.selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset:
                                                      charger_name_controller
                                                          .value.text.length);
                                        },
                                        scrollPadding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
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
                                                .translate(
                                                    'insert_value_validate');
                                          }
                                          return null;
                                        },
                                        onSaved: (newValue) {
                                          charger_name_controller.text =
                                              newValue!;
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
                                                  extentOffset:
                                                      charger_address_controller
                                                          .value.text.length);
                                        },
                                        scrollPadding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
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
                                                .translate(
                                                    'insert_value_validate');
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
                                                  extentOffset:
                                                      charger_phone_controller
                                                          .value.text.length);
                                        },
                                        scrollPadding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.phone,
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
                                                .translate(
                                                    'insert_value_validate');
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
                            ],
                          ),
                        ),
                        Visibility(
                            visible: selectedRadioTile.isEmpty ||
                                selectedRadioTile == "M" ||
                                selectedRadioTile == "C",
                            child: Column(
                              children: [
                                Card(
                                  color: Colors.white,
                                  margin: const EdgeInsets.all(5),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 7.5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("Reciever Info",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.darkGrey,
                                                )),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: reciever_name_controller,
                                          onTap: () {
                                            reciever_name_controller.selection =
                                                TextSelection(
                                                    baseOffset: 0,
                                                    extentOffset:
                                                        reciever_name_controller
                                                            .value.text.length);
                                          },
                                          scrollPadding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          textInputAction: TextInputAction.done,
                                          style: const TextStyle(fontSize: 18),
                                          decoration: const InputDecoration(
                                            labelText: "reciever name",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 11.0,
                                                    horizontal: 9.0),
                                          ),
                                          onTapOutside: (event) {},
                                          onEditingComplete: () {
                                            // evaluatePrice();
                                          },
                                          onChanged: (value) {},
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return AppLocalizations.of(
                                                      context)!
                                                  .translate(
                                                      'insert_value_validate');
                                            }
                                            return null;
                                          },
                                          onSaved: (newValue) {
                                            reciever_name_controller.text =
                                                newValue!;
                                          },
                                          onFieldSubmitted: (value) {},
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        TextFormField(
                                          controller:
                                              reciever_address_controller,
                                          onTap: () {
                                            reciever_address_controller
                                                    .selection =
                                                TextSelection(
                                                    baseOffset: 0,
                                                    extentOffset:
                                                        reciever_address_controller
                                                            .value.text.length);
                                          },
                                          scrollPadding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          textInputAction: TextInputAction.done,
                                          style: const TextStyle(fontSize: 18),
                                          decoration: const InputDecoration(
                                            labelText: "reciever address",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 11.0,
                                                    horizontal: 9.0),
                                          ),
                                          onTapOutside: (event) {
                                            // FocusManager.instance.primaryFocus?.unfocus();
                                            // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                                          },
                                          onEditingComplete: () {
                                            // evaluatePrice();
                                          },
                                          onChanged: (value) {},
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return AppLocalizations.of(
                                                      context)!
                                                  .translate(
                                                      'insert_value_validate');
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
                                            reciever_phone_controller
                                                    .selection =
                                                TextSelection(
                                                    baseOffset: 0,
                                                    extentOffset:
                                                        reciever_phone_controller
                                                            .value.text.length);
                                          },
                                          scrollPadding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.phone,
                                          style: const TextStyle(fontSize: 18),
                                          decoration: const InputDecoration(
                                            labelText: "reciever phone",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 11.0,
                                                    horizontal: 9.0),
                                          ),
                                          onTapOutside: (event) {
                                            // FocusManager.instance.primaryFocus?.unfocus();
                                            // BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                                          },
                                          onEditingComplete: () {
                                            // evaluatePrice();
                                          },
                                          onChanged: (value) {},
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return AppLocalizations.of(
                                                      context)!
                                                  .translate(
                                                      'insert_value_validate');
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
                              ],
                            )),
                        Card(
                          color: Colors.white,
                          margin: const EdgeInsets.all(5),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 7.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Shipment loading?unloading Location Info",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.darkGrey,
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: loading_info_controller,
                                  onTap: () {
                                    loading_info_controller.selection =
                                        TextSelection(
                                            baseOffset: 0,
                                            extentOffset:
                                                loading_info_controller
                                                    .value.text.length);
                                  },
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  enabled: false,
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
                                            extentOffset:
                                                unloading_info_controller
                                                    .value.text.length);
                                  },
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  enabled: false,
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
                        Card(
                          color: Colors.white,
                          margin: const EdgeInsets.all(5),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 7.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Commodity Info",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.darkGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3,
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
                                      controller:
                                          commodityName_controller[index],
                                      onTap: () {
                                        commodityName_controller[index]
                                                .selection =
                                            TextSelection(
                                                baseOffset: 0,
                                                extentOffset:
                                                    commodityName_controller[
                                                            index]
                                                        .value
                                                        .text
                                                        .length);
                                      },
                                      scrollPadding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      enabled: false,
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
                                              .translate(
                                                  'insert_value_validate');
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
                                      controller:
                                          commodityWeight_controller[index],
                                      onTap: () {
                                        commodityWeight_controller[index]
                                                .selection =
                                            TextSelection(
                                                baseOffset: 0,
                                                extentOffset:
                                                    commodityWeight_controller[
                                                            index]
                                                        .value
                                                        .text
                                                        .length);
                                      },
                                      scrollPadding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      enabled: false,
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
                                              .translate(
                                                  'insert_value_validate');
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
                                      controller:
                                          commodityQuantity_controller[index],
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
                                              .bottom),
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.number,
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
                                              .translate(
                                                  'insert_value_validate');
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
                                    BlocBuilder<PackageTypeBloc,
                                        PackageTypeState>(
                                      builder: (context, state2) {
                                        if (state2
                                            is PackageTypeLoadedSuccess) {
                                          return DropdownButtonHideUnderline(
                                            child: DropdownButton2<PackageType>(
                                              isExpanded: true,
                                              hint: Text(
                                                AppLocalizations.of(context)!
                                                    .translate('package_type'),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                              items: state2.packageTypes
                                                  .map((PackageType item) =>
                                                      DropdownMenuItem<
                                                          PackageType>(
                                                        value: item,
                                                        child: SizedBox(
                                                          width: 200,
                                                          child: Text(
                                                            item.name!,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                              value:
                                                  packageType_controller[index],
                                              onChanged: (PackageType? value) {
                                                setState(() {
                                                  packageType_controller[
                                                      index] = value!;
                                                });
                                              },
                                              buttonStyleData: ButtonStyleData(
                                                height: 50,
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 9.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                // elevation: 2,
                                              ),
                                              iconStyleData: IconStyleData(
                                                icon: Icon(
                                                  Icons
                                                      .keyboard_arrow_down_sharp,
                                                ),
                                                iconSize: 20,
                                                iconEnabledColor:
                                                    AppColor.deepYellow,
                                                iconDisabledColor: Colors.grey,
                                              ),
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  color: Colors.white,
                                                ),
                                                scrollbarTheme:
                                                    ScrollbarThemeData(
                                                  radius:
                                                      const Radius.circular(40),
                                                  thickness:
                                                      MaterialStateProperty.all(
                                                          6),
                                                  thumbVisibility:
                                                      MaterialStateProperty.all(
                                                          true),
                                                ),
                                              ),
                                              menuItemStyleData:
                                                  const MenuItemStyleData(
                                                height: 40,
                                              ),
                                            ),
                                          );
                                        } else if (state2
                                            is PackageTypeLoadingProgress) {
                                          return const Center(
                                            child: LinearProgressIndicator(),
                                          );
                                        } else if (state2
                                            is PackageTypeLoadedFailed) {
                                          return Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                BlocProvider.of<
                                                            PackageTypeBloc>(
                                                        context)
                                                    .add(
                                                        PackageTypeLoadEvent());
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .translate(
                                                            'list_error'),
                                                    style: const TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  const Icon(
                                                    Icons.refresh,
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Other Info",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.darkGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .43,
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
                                                .bottom),
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
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
                                                .translate(
                                                    'insert_value_validate');
                                          }
                                          return null;
                                        },
                                        onSaved: (newValue) {
                                          truck_number_controller.text =
                                              newValue!;
                                        },
                                        onFieldSubmitted: (value) {},
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                      child: TextFormField(
                                        controller: truck_type_controller,
                                        onTap: () {
                                          truck_type_controller.selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset:
                                                      truck_type_controller
                                                          .value.text.length);
                                        },
                                        scrollPadding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
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
                                                .translate(
                                                    'insert_value_validate');
                                          }
                                          return null;
                                        },
                                        onSaved: (newValue) {
                                          truck_type_controller.text =
                                              newValue!;
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .43,
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
                                                .bottom),
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
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
                                                .translate(
                                                    'insert_value_validate');
                                          }
                                          return null;
                                        },
                                        onSaved: (newValue) {
                                          total_weight_controller.text =
                                              newValue!;
                                        },
                                        onFieldSubmitted: (value) {},
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                      child: TextFormField(
                                        controller: net_weight_controller,
                                        onTap: () {
                                          net_weight_controller.selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset:
                                                      net_weight_controller
                                                          .value.text.length);
                                        },
                                        scrollPadding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
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
                                                .translate(
                                                    'insert_value_validate');
                                          }
                                          return null;
                                        },
                                        onSaved: (newValue) {
                                          net_weight_controller.text =
                                              newValue!;
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .43,
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
                                                .bottom),
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
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
                                                .translate(
                                                    'insert_value_validate');
                                          }
                                          return null;
                                        },
                                        onSaved: (newValue) {
                                          truck_weight_controller.text =
                                              newValue!;
                                        },
                                        onFieldSubmitted: (value) {},
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .43,
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
                                                .bottom),
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
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
                                                .translate(
                                                    'insert_value_validate');
                                          }
                                          return null;
                                        },
                                        onSaved: (newValue) {
                                          final_weight_controller.text =
                                              newValue!;
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocConsumer<InstructionCreateBloc,
                              InstructionCreateState>(
                            listener: (context, state) {
                              print(state);
                              if (state is InstructionCreateSuccessState) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'shipment instruction has been created successfully.'),
                                  duration: Duration(seconds: 3),
                                ));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ControlView(),
                                    ));
                              }
                              if (state is InstructionCreateFailureState) {
                                print(state.errorMessage);
                              }
                            },
                            builder: (context, state) {
                              if (state is InstructionLoadingProgressState) {
                                return CustomButton(
                                  title: const CircularProgressIndicator(),
                                  onTap: () {},
                                );
                              } else {
                                return CustomButton(
                                  title: Text(
                                    AppLocalizations.of(context)!
                                        .translate('search_truck'),
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                  onTap: () {
                                    _addShipmentformKey.currentState?.save();
                                    if (_addShipmentformKey.currentState!
                                        .validate()) {
                                      ShipmentInstruction shipmentInstruction =
                                          ShipmentInstruction();
                                      shipmentInstruction.shipment =
                                          widget.shipment.id!;
                                      shipmentInstruction.userType =
                                          selectedRadioTile;
                                      shipmentInstruction.chargerName =
                                          charger_name_controller.text;
                                      shipmentInstruction.chargerAddress =
                                          charger_address_controller.text;
                                      shipmentInstruction.chargerPhone =
                                          charger_phone_controller.text;
                                      shipmentInstruction.recieverName =
                                          reciever_name_controller.text;
                                      shipmentInstruction.recieverAddress =
                                          reciever_address_controller.text;
                                      shipmentInstruction.recieverPhone =
                                          reciever_phone_controller.text;
                                      shipmentInstruction.totalWeight =
                                          int.parse(
                                              total_weight_controller.text);
                                      shipmentInstruction.netWeight =
                                          int.parse(net_weight_controller.text);
                                      shipmentInstruction.truckWeight =
                                          int.parse(
                                              truck_number_controller.text);
                                      shipmentInstruction.finalWeight =
                                          int.parse(
                                              final_weight_controller.text);
                                      List<CommodityItems> items = [];
                                      for (var i = 0;
                                          i <
                                              commodityQuantity_controller
                                                  .length;
                                          i++) {
                                        CommodityItems item = CommodityItems(
                                            commodityName:
                                                commodityName_controller[i]
                                                    .text,
                                            commodityWeight: double.parse(
                                                    commodityWeight_controller[
                                                            i]
                                                        .text
                                                        .replaceAll(",", ""))
                                                .toInt(),
                                            commodityQuantity: int.parse(
                                                commodityQuantity_controller[i]
                                                    .text),
                                            packageType:
                                                packageType_controller[i]!.id!);
                                        print(commodityQuantity_controller[i]
                                            .text);
                                        print(packageType_controller[i]!.id!);
                                        items.add(item);
                                      }
                                      shipmentInstruction.commodityItems =
                                          items;
                                      print(jsonEncode(items));
                                      BlocProvider.of<InstructionCreateBloc>(
                                              context)
                                          .add(InstructionCreateButtonPressed(
                                              shipmentInstruction));
                                    } else {
                                      Scrollable.ensureVisible(
                                        key1.currentContext!,
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                      );
                                    }

                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
