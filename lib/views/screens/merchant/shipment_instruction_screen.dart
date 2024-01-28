import 'dart:convert';

import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/instructions/instruction_create_bloc.dart';
import 'package:camion/business_logic/bloc/package_type_bloc.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/models/instruction_model.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/data/providers/task_num_provider.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/helpers/formatter.dart';
import 'package:camion/views/screens/control_view.dart';
import 'package:camion/views/widgets/custom_app_bar.dart';
import 'package:camion/views/widgets/custom_botton.dart';
import 'package:camion/views/widgets/loading_indicator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class ShipmentInstructionScreen extends StatefulWidget {
  final Shipment shipment;
  final bool hasinstruction;
  ShipmentInstructionScreen({
    Key? key,
    required this.shipment,
    required this.hasinstruction,
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
  List<TextEditingController> readpackageType_controller = [];
  List<PackageType?> packageType_controller = [];
  final GlobalKey<FormState> _addShipmentformKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.shipment.shipmentinstruction != null) {
      charger_name_controller.text =
          widget.shipment.shipmentinstruction!.chargerName!;
      charger_address_controller.text =
          widget.shipment.shipmentinstruction!.chargerAddress!;
      charger_phone_controller.text =
          widget.shipment.shipmentinstruction!.chargerPhone!;

      reciever_name_controller.text =
          widget.shipment.shipmentinstruction!.recieverName!;
      reciever_address_controller.text =
          widget.shipment.shipmentinstruction!.recieverAddress!;
      reciever_phone_controller.text =
          widget.shipment.shipmentinstruction!.recieverPhone!;

      total_weight_controller.text =
          widget.shipment.shipmentinstruction!.totalWeight!.toString();
      net_weight_controller.text =
          widget.shipment.shipmentinstruction!.netWeight!.toString();
      truck_weight_controller.text =
          widget.shipment.shipmentinstruction!.truckWeight!.toString();
      final_weight_controller.text =
          widget.shipment.shipmentinstruction!.finalWeight!.toString();
    }
    for (var i = 0; i < widget.shipment.shipmentItems!.length; i++) {
      commodityName_controller.add(TextEditingController(
          text: widget.shipment.shipmentItems![i].commodityName));
      commodityWeight_controller.add(TextEditingController(
          text: widget.shipment.shipmentItems![i].commodityWeight.toString()));
      commodityQuantity_controller.add(TextEditingController(
          text: widget.shipment.shipmentinstruction != null
              ? widget.shipment.shipmentinstruction!.commodityItems![i]
                  .commodityQuantity!
                  .toString()
              : ""));
      if (widget.shipment.shipmentinstruction != null) {
        readpackageType_controller.add(TextEditingController(
            text: widget
                .shipment.shipmentinstruction!.commodityItems![i].packageType
                .toString()));
      } else {
        packageType_controller.add(null);
      }
    }

    if (widget.shipment.shipmentinstruction != null) {
      setState(() {
        selectedRadioTile = "K";
      });
    }
    setState(() {});
    loading_info_controller.text = widget.shipment.pickupCityLocation!;
    unloading_info_controller.text = widget.shipment.deliveryCityLocation!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _addShipmentformKey,
            child: Column(
              children: [
                Card(
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
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('shipment_path_info'),
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
                        SizedBox(
                          height: 70.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TimelineTile(
                                direction: Axis.horizontal,
                                oppositeContents: Text(
                                  '${widget.shipment.pickupDate!.year.toString()}-${widget.shipment.pickupDate!.month.toString()}-${widget.shipment.pickupDate!.day.toString()}',
                                ),
                                contents: Text(
                                  widget.shipment.pickupCityLocation!,
                                ),
                                node: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .25,
                                  child: TimelineNode(
                                    indicator: DotIndicator(
                                        color: AppColor.deepYellow),
                                    // startConnector: SolidLineConnector(),
                                    endConnector: DashedLineConnector(
                                        color: AppColor.deepYellow),
                                  ),
                                ),
                              ),
                              TimelineTile(
                                direction: Axis.horizontal,
                                oppositeContents: const SizedBox.shrink(),
                                contents: const SizedBox.shrink(),
                                node: SizedBox(
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: DashedLineConnector(
                                      color: AppColor.deepYellow),
                                ),
                              ),
                              TimelineTile(
                                direction: Axis.horizontal,
                                oppositeContents: Text(
                                  '${widget.shipment.pickupDate!.year.toString()}-${widget.shipment.pickupDate!.month.toString()}-${widget.shipment.pickupDate!.day.toString()}',
                                ),
                                contents: Text(
                                  widget.shipment.deliveryCityLocation!,
                                ),
                                node: SizedBox(
                                  width: MediaQuery.of(context).size.width * .2,
                                  child: TimelineNode(
                                    indicator: DotIndicator(
                                        color: AppColor.deepYellow),
                                    startConnector: DashedLineConnector(
                                        color: AppColor.deepYellow),
                                    // endConnector: SolidLineConnector(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.shipment.shipmentinstruction == null,
                  child: EnsureVisibleWhenFocused(
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
                                Text(
                                    AppLocalizations.of(context)!
                                        .translate('select_your_identity'),
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
                                    value: "C",
                                    groupValue: selectedRadioTile,
                                    title: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('charger'),
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
                                    selected: selectedRadioTile == "C",
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    value: "M",
                                    groupValue: selectedRadioTile,
                                    title: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('mediator'),
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
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.zero,

                                    value: "R",
                                    groupValue: selectedRadioTile,
                                    title: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('reciever'),
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
                ),
                Visibility(
                  visible: (selectedRadioTile.isEmpty ||
                          selectedRadioTile == "M" ||
                          selectedRadioTile == "R") ||
                      (widget.hasinstruction
                          ? (widget.shipment.shipmentinstruction!.userType ==
                                  "M") ||
                              (widget.shipment.shipmentinstruction!.userType ==
                                  "R")
                          : false),
                  child: Column(
                    children: [
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
                                      AppLocalizations.of(context)!
                                          .translate('charger_info'),
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
                                          extentOffset: charger_name_controller
                                              .value.text.length);
                                },
                                scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                enabled:
                                    widget.shipment.shipmentinstruction == null,
                                textInputAction: TextInputAction.done,
                                style: const TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .translate('charger_name'),
                                  contentPadding: const EdgeInsets.symmetric(
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
                                          extentOffset:
                                              charger_address_controller
                                                  .value.text.length);
                                },
                                enabled:
                                    widget.shipment.shipmentinstruction == null,
                                scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                textInputAction: TextInputAction.done,
                                style: const TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .translate('charger_address'),
                                  contentPadding: const EdgeInsets.symmetric(
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
                                enabled:
                                    widget.shipment.shipmentinstruction == null,
                                scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .translate('charger_phone'),
                                  contentPadding: const EdgeInsets.symmetric(
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
                    ],
                  ),
                ),
                Visibility(
                    visible: (selectedRadioTile.isEmpty ||
                            selectedRadioTile == "M" ||
                            selectedRadioTile == "C") ||
                        (widget.hasinstruction
                            ? (widget.shipment.shipmentinstruction!.userType ==
                                    "M") ||
                                (widget.shipment.shipmentinstruction!
                                        .userType ==
                                    "C")
                            : false),
                    child: Column(
                      children: [
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
                                        AppLocalizations.of(context)!
                                            .translate('reciever_info'),
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
                                  enabled:
                                      widget.shipment.shipmentinstruction ==
                                          null,
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!
                                        .translate('reciever_name'),
                                    contentPadding: const EdgeInsets.symmetric(
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
                                            extentOffset:
                                                reciever_address_controller
                                                    .value.text.length);
                                  },
                                  enabled:
                                      widget.shipment.shipmentinstruction ==
                                          null,
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!
                                        .translate('reciever_address'),
                                    contentPadding: const EdgeInsets.symmetric(
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
                                            extentOffset:
                                                reciever_phone_controller
                                                    .value.text.length);
                                  },
                                  enabled:
                                      widget.shipment.shipmentinstruction ==
                                          null,
                                  scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!
                                        .translate('reciever_phone'),
                                    contentPadding: const EdgeInsets.symmetric(
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
                      ],
                    )),
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
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .88,
                            child: ExpansionTile(
                              initiallyExpanded: false,
                              tilePadding: EdgeInsets.zero,

                              // controlAffinity: ListTileControlAffinity.leading,
                              childrenPadding: EdgeInsets.zero,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .6,
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('commodity_info'),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.darkGrey,
                                        )),
                                  )
                                ],
                              ),
                              onExpansionChanged: (value) {},
                              children: [
                                ListView.builder(
                                  itemCount:
                                      widget.shipment.shipmentItems!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      // margin: const EdgeInsets.all(5),
                                      elevation: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: AppColor.deepYellow,
                                            width: 2,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 7.5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller:
                                                    commodityName_controller[
                                                        index],
                                                onTap: () {
                                                  commodityName_controller[
                                                              index]
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
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                enabled: false,
                                                textInputAction:
                                                    TextInputAction.done,
                                                style: const TextStyle(
                                                    fontSize: 18),
                                                decoration: InputDecoration(
                                                  labelText:
                                                      AppLocalizations.of(
                                                              context)!
                                                          .translate(
                                                              'commodity_name'),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 11.0,
                                                          horizontal: 9.0),
                                                ),
                                                onTapOutside: (event) {},
                                                onEditingComplete: () {
                                                  // evaluatePrice();
                                                },
                                                onChanged: (value) {},
                                                autovalidateMode:
                                                    AutovalidateMode
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
                                                  commodityName_controller[
                                                          index]
                                                      .text = newValue!;
                                                },
                                                onFieldSubmitted: (value) {},
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              TextFormField(
                                                controller:
                                                    commodityWeight_controller[
                                                        index],
                                                onTap: () {
                                                  commodityWeight_controller[
                                                              index]
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
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                enabled: false,
                                                textInputAction:
                                                    TextInputAction.done,
                                                style: const TextStyle(
                                                    fontSize: 18),
                                                decoration: InputDecoration(
                                                  labelText: AppLocalizations
                                                          .of(context)!
                                                      .translate(
                                                          'commodity_weight'),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
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
                                                autovalidateMode:
                                                    AutovalidateMode
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
                                                controller:
                                                    commodityQuantity_controller[
                                                        index],
                                                onTap: () {
                                                  commodityQuantity_controller[
                                                              index]
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
                                                enabled: widget.shipment
                                                        .shipmentinstruction ==
                                                    null,
                                                scrollPadding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                textInputAction:
                                                    TextInputAction.done,
                                                keyboardType:
                                                    TextInputType.number,
                                                style: const TextStyle(
                                                    fontSize: 18),
                                                decoration: InputDecoration(
                                                  labelText: AppLocalizations
                                                          .of(context)!
                                                      .translate(
                                                          'commodity_quantity'),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
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
                                                autovalidateMode:
                                                    AutovalidateMode
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
                                              widget.shipment
                                                          .shipmentinstruction !=
                                                      null
                                                  ? TextFormField(
                                                      controller:
                                                          commodityQuantity_controller[
                                                              index],
                                                      onTap: () {
                                                        readpackageType_controller[
                                                                    index]
                                                                .selection =
                                                            TextSelection(
                                                                baseOffset: 0,
                                                                extentOffset:
                                                                    readpackageType_controller[
                                                                            index]
                                                                        .value
                                                                        .text
                                                                        .length);
                                                      },
                                                      enabled: widget.shipment
                                                              .shipmentinstruction ==
                                                          null,
                                                      scrollPadding:
                                                          EdgeInsets.only(
                                                              bottom: MediaQuery
                                                                      .of(context)
                                                                  .viewInsets
                                                                  .bottom),
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: AppLocalizations
                                                                .of(context)!
                                                            .translate(
                                                                'package_type'),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 11.0,
                                                                horizontal:
                                                                    9.0),
                                                      ),
                                                    )
                                                  : BlocBuilder<PackageTypeBloc,
                                                      PackageTypeState>(
                                                      builder:
                                                          (context, state2) {
                                                        if (state2
                                                            is PackageTypeLoadedSuccess) {
                                                          return DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton2<
                                                                    PackageType>(
                                                              isExpanded: true,
                                                              hint: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .translate(
                                                                        'package_type'),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor,
                                                                ),
                                                              ),
                                                              items: state2
                                                                  .packageTypes
                                                                  .map((PackageType
                                                                          item) =>
                                                                      DropdownMenuItem<
                                                                          PackageType>(
                                                                        value:
                                                                            item,
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              200,
                                                                          child:
                                                                              Text(
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
                                                                  packageType_controller[
                                                                      index],
                                                              onChanged:
                                                                  (PackageType?
                                                                      value) {
                                                                setState(() {
                                                                  packageType_controller[
                                                                          index] =
                                                                      value!;
                                                                });
                                                              },
                                                              buttonStyleData:
                                                                  ButtonStyleData(
                                                                height: 50,
                                                                width: double
                                                                    .infinity,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      9.0,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black26,
                                                                  ),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                // elevation: 2,
                                                              ),
                                                              iconStyleData:
                                                                  IconStyleData(
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .keyboard_arrow_down_sharp,
                                                                ),
                                                                iconSize: 20,
                                                                iconEnabledColor:
                                                                    AppColor
                                                                        .deepYellow,
                                                                iconDisabledColor:
                                                                    Colors.grey,
                                                              ),
                                                              dropdownStyleData:
                                                                  DropdownStyleData(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                scrollbarTheme:
                                                                    ScrollbarThemeData(
                                                                  radius: const Radius
                                                                      .circular(
                                                                      40),
                                                                  thickness:
                                                                      MaterialStateProperty
                                                                          .all(
                                                                              6),
                                                                  thumbVisibility:
                                                                      MaterialStateProperty
                                                                          .all(
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
                                                            child:
                                                                LinearProgressIndicator(),
                                                          );
                                                        } else if (state2
                                                            is PackageTypeLoadedFailed) {
                                                          return Center(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                            PackageTypeBloc>(
                                                                        context)
                                                                    .add(
                                                                        PackageTypeLoadEvent());
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .translate(
                                                                            'list_error'),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                  const Icon(
                                                                    Icons
                                                                        .refresh,
                                                                    color: Colors
                                                                        .grey,
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
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('other_info'),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .43,
                              child: TextFormField(
                                controller: total_weight_controller,
                                onTap: () {
                                  total_weight_controller.selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset: total_weight_controller
                                              .value.text.length);
                                },
                                enabled:
                                    widget.shipment.shipmentinstruction == null,
                                scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .translate('total_weight'),
                                  contentPadding: const EdgeInsets.symmetric(
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
                              width: MediaQuery.of(context).size.width * .43,
                              child: TextFormField(
                                controller: net_weight_controller,
                                onTap: () {
                                  net_weight_controller.selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset: net_weight_controller
                                              .value.text.length);
                                },
                                enabled:
                                    widget.shipment.shipmentinstruction == null,
                                scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .translate('net_weight'),
                                  contentPadding: const EdgeInsets.symmetric(
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
                              width: MediaQuery.of(context).size.width * .43,
                              child: TextFormField(
                                controller: truck_weight_controller,
                                onTap: () {
                                  truck_weight_controller.selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset: truck_weight_controller
                                              .value.text.length);
                                },
                                enabled:
                                    widget.shipment.shipmentinstruction == null,
                                scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .translate('truck_weight'),
                                  contentPadding: const EdgeInsets.symmetric(
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
                              width: MediaQuery.of(context).size.width * .43,
                              child: TextFormField(
                                controller: final_weight_controller,
                                onTap: () {
                                  final_weight_controller.selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset: final_weight_controller
                                              .value.text.length);
                                },
                                enabled:
                                    widget.shipment.shipmentinstruction == null,
                                scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .translate('final_weight'),
                                  contentPadding: const EdgeInsets.symmetric(
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
                Visibility(
                  visible: widget.shipment.shipmentinstruction == null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<TaskNumProvider>(
                        builder: (context, taskProvider, child) {
                      return BlocConsumer<InstructionCreateBloc,
                          InstructionCreateState>(
                        listener: (context, state) {
                          taskProvider.decreaseTaskNum();

                          if (state is InstructionCreateSuccessState) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: localeState.value.languageCode == 'en'
                                  ? const Text(
                                      'shipment instruction has been created successfully.')
                                  : const Text(
                                      'تم اضافة تعليمات الشحن بنجاح..'),
                              duration: const Duration(seconds: 3),
                            ));
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ControlView(),
                              ),
                              (route) => false,
                            );
                          }
                          if (state is InstructionCreateFailureState) {
                            print(state.errorMessage);
                          }
                        },
                        builder: (context, state) {
                          if (state is InstructionLoadingProgressState) {
                            return CustomButton(
                              title: const LoadingIndicator(),
                              onTap: () {},
                            );
                          } else {
                            return CustomButton(
                              title: Text(
                                AppLocalizations.of(context)!
                                    .translate('add_instruction'),
                                style: TextStyle(
                                  fontSize: 20.sp,
                                ),
                              ),
                              onTap: () {
                                _addShipmentformKey.currentState?.save();
                                if (_addShipmentformKey.currentState!
                                    .validate()) {
                                  Shipmentinstruction shipmentInstruction =
                                      Shipmentinstruction();
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
                                      int.parse(total_weight_controller.text);
                                  shipmentInstruction.netWeight =
                                      int.parse(net_weight_controller.text);
                                  shipmentInstruction.truckWeight =
                                      int.parse(truck_number_controller.text);
                                  shipmentInstruction.finalWeight =
                                      int.parse(final_weight_controller.text);
                                  List<CommodityItems> items = [];
                                  for (var i = 0;
                                      i < commodityQuantity_controller.length;
                                      i++) {
                                    CommodityItems item = CommodityItems(
                                        commodityName:
                                            commodityName_controller[i].text,
                                        commodityWeight: double.parse(
                                                commodityWeight_controller[i]
                                                    .text
                                                    .replaceAll(",", ""))
                                            .toInt(),
                                        commodityQuantity: int.parse(
                                            commodityQuantity_controller[i]
                                                .text),
                                        packageType:
                                            packageType_controller[i]!.id!);
                                    print(commodityQuantity_controller[i].text);
                                    print(packageType_controller[i]!.id!);
                                    items.add(item);
                                  }
                                  shipmentInstruction.commodityItems = items;
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

                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            );
                          }
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
