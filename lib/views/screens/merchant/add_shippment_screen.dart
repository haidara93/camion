// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/core/draw_route_bloc.dart';
import 'package:camion/business_logic/bloc/shipments/shippment_create_bloc.dart';
import 'package:camion/business_logic/bloc/truck/truck_type_bloc.dart';
import 'package:camion/business_logic/bloc/truck/trucks_list_bloc.dart';
import 'package:camion/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/models/co2_report.dart';
import 'package:camion/data/models/place_model.dart';
import 'package:camion/data/models/truck_type_model.dart';
import 'package:camion/data/providers/add_shippment_provider.dart';
import 'package:camion/data/services/co2_service.dart';
import 'package:camion/data/services/places_service.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/helpers/formatter.dart';
import 'package:camion/views/screens/merchant/add_shippment_pickup_map.dart';
import 'package:camion/views/screens/merchant/shipment_map_preview.dart';
import 'package:camion/views/screens/select_truck_screen.dart';
import 'package:camion/views/widgets/custom_botton.dart';
import 'package:camion/views/widgets/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart' as intel;

class AddShippmentScreen extends StatefulWidget {
  AddShippmentScreen({Key? key}) : super(key: key);

  @override
  State<AddShippmentScreen> createState() => _AddShippmentScreenState();
}

class _AddShippmentScreenState extends State<AddShippmentScreen> {
  List<Widget> _children = [];
  List<PlaceSearch> searchResults = [];

  bool pickupLoading = false;
  bool deliveryLoading = false;

  bool pickupPosition = false;
  bool deliveryPosition = false;

  List<TextEditingController> commodityName_controllers = [];
  List<TextEditingController> commodityWeight_controllers = [];
  int truckType = 0;
  // List<TextEditingController> commodityQuantity_controllers = [];
  // List<PackageType?> commodityPackageTypes = [];
  List<TruckType?> truckTypes = [];
  List<int> trucknum = [];
  List<TextEditingController> truckNumControllers = [];
  //the controllers list
  int _count = 0;

  int previousIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final FocusNode _commodity_node = FocusNode();
  final FocusNode _truck_node = FocusNode();
  bool truckError = false;
  bool pathError = false;
  bool dateError = false;
  bool co2Loading = false;
  bool co2error = false;

  var key1 = GlobalKey();
  var key2 = GlobalKey();

  DateTime loadDate = DateTime.now();
  DateTime loadTime = DateTime.now();

  final GlobalKey<FormState> _addShipmentformKey = GlobalKey<FormState>();
  AddShippmentProvider? addShippmentProvider;
  String _mapStyle = "";
  String _darkmapStyle = "";

  late BitmapDescriptor pickupicon;
  late BitmapDescriptor deliveryicon;

  createMarkerIcons() async {
    pickupicon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/icons/location1.png");
    deliveryicon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/icons/location2.png");
    setState(() {});
  }

  var f = intel.NumberFormat("#,###", "en_US");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addShippmentProvider =
          Provider.of<AddShippmentProvider>(context, listen: false);
      createMarkerIcons();
    });
    TextEditingController commodityName_controller = TextEditingController();
    TextEditingController commodityWeight_controller = TextEditingController();
    // TextEditingController commodityQuantity_controller =
    //     TextEditingController();

    commodityName_controllers.add(commodityName_controller);
    commodityWeight_controllers.add(commodityWeight_controller);
    // commodityQuantity_controllers.add(commodityQuantity_controller);
    // commodityPackageTypes.add(null);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _count++);
    });

    rootBundle.loadString('assets/style/normal_style.json').then((string) {
      _mapStyle = string;
    });
    rootBundle.loadString('assets/style/map_style.json').then((string) {
      _darkmapStyle = string;
    });
  }

  void _add() {
    TextEditingController commodityName_controller = TextEditingController();
    TextEditingController commodityWeight_controller = TextEditingController();
    // TextEditingController commodityQuantity_controller =
    //     TextEditingController();

    commodityName_controllers.add(commodityName_controller);
    commodityWeight_controllers.add(commodityWeight_controller);

    setState(() => _count++);
    print(_count);
  }

  @override
  void dispose() {
    addShippmentProvider!.dispose();
    super.dispose();
  }

  void remove(int index) {
    commodityName_controllers.removeAt(index);
    commodityWeight_controllers.removeAt(index);
    setState(() => _count--);
  }

  _showDatePicker() {
    cupertino.showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(top: BorderSide(color: AppColor.deepYellow, width: 2))),
        height: MediaQuery.of(context).size.height * .4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () {
                  addShippmentProvider!.setLoadDate(loadDate);

                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('ok'),
                  style: TextStyle(
                    color: AppColor.darkGrey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Expanded(
              child: Localizations(
                locale: const Locale('en', ''),
                delegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                child: cupertino.CupertinoDatePicker(
                  backgroundColor: Colors.white10,
                  initialDateTime: loadDate,
                  mode: cupertino.CupertinoDatePickerMode.date,
                  minimumYear: DateTime.now().year,
                  minimumDate: DateTime.now().subtract(const Duration(days: 1)),
                  maximumYear: DateTime.now().year + 1,
                  onDateTimeChanged: (value) {
                    loadDate = value;
                    addShippmentProvider!.setLoadDate(value);
                    // order_brokerProvider!.setProductDate(value);
                    // order_brokerProvider!.setDateError(false);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showTimePicker() {
    cupertino.showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(top: BorderSide(color: AppColor.deepYellow, width: 2))),
        height: MediaQuery.of(context).size.height * .4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () {
                  addShippmentProvider!.setLoadTime(loadTime);

                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('ok'),
                  style: TextStyle(
                    color: AppColor.darkGrey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Expanded(
              child: Localizations(
                locale: const Locale('en', ''),
                delegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                child: cupertino.CupertinoDatePicker(
                  backgroundColor: Colors.white10,
                  initialDateTime: loadTime,
                  mode: cupertino.CupertinoDatePickerMode.time,
                  onDateTimeChanged: (value) {
                    loadTime = value;
                    addShippmentProvider!.setLoadTime(value);

                    // order_brokerProvider!.setProductDate(value);
                    // order_brokerProvider!.setDateError(false);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool evaluateCo2() {
    // for (var element in commodityName_controllers) {
    //   if (element.text.isEmpty) {
    //     return false;
    //   }
    // }
    // for (var element in commodityWeight_controllers) {
    //   if (element.text.isEmpty) {
    //     return false;
    //   }
    // }
    if (addShippmentProvider!.delivery_location_name.isNotEmpty &&
        addShippmentProvider!.pickup_location_name.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  final FocusNode _nodeCommodityName = FocusNode();
  final FocusNode _nodeCommodityWeight = FocusNode();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
          textDirection: localeState.value.languageCode == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Consumer<AddShippmentProvider>(
              builder: (context, shippmentProvider, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Scaffold(
                  backgroundColor: AppColor.lightGrey200,
                  body: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              EnsureVisibleWhenFocused(
                                focusNode: _commodity_node,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      key: key1,
                                      child: Form(
                                        key: _addShipmentformKey,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: _count,
                                            itemBuilder: (context, index) {
                                              return Stack(
                                                children: [
                                                  Card(
                                                    color: Colors.white,
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10.0,
                                                          vertical: 7.5),
                                                      child: Column(
                                                        children: [
                                                          index == 0
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                      _count > 1
                                                                          ? SizedBox(
                                                                              width: 35.w,
                                                                            )
                                                                          : SizedBox
                                                                              .shrink(),
                                                                      Text(
                                                                        AppLocalizations.of(context)!
                                                                            .translate('commodity_info'),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              AppColor.darkGrey,
                                                                        ),
                                                                      ),
                                                                    ])
                                                              : const SizedBox
                                                                  .shrink(),
                                                          index != 0
                                                              ? const SizedBox(
                                                                  height: 30,
                                                                )
                                                              : const SizedBox
                                                                  .shrink(),
                                                          const SizedBox(
                                                            height: 7,
                                                          ),
                                                          Focus(
                                                            focusNode:
                                                                _nodeCommodityName,
                                                            onFocusChange:
                                                                (bool focus) {
                                                              if (!focus) {
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                                BlocProvider.of<
                                                                            BottomNavBarCubit>(
                                                                        context)
                                                                    .emitShow();
                                                              } else {
                                                                BlocProvider.of<
                                                                            BottomNavBarCubit>(
                                                                        context)
                                                                    .emitHide();
                                                              }
                                                            },
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  commodityName_controllers[
                                                                      index],
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                            BottomNavBarCubit>(
                                                                        context)
                                                                    .emitHide();
                                                                commodityName_controllers[
                                                                            index]
                                                                        .selection =
                                                                    TextSelection(
                                                                        baseOffset:
                                                                            0,
                                                                        extentOffset: commodityName_controllers[index]
                                                                            .value
                                                                            .text
                                                                            .length);
                                                              },
                                                              // focusNode: _nodeWeight,
                                                              // enabled: !valueEnabled,
                                                              scrollPadding: EdgeInsets.only(
                                                                  bottom: MediaQuery.of(
                                                                              context)
                                                                          .viewInsets
                                                                          .bottom +
                                                                      50),
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              // keyboardType:
                                                              //     const TextInputType.numberWithOptions(
                                                              //         decimal: true, signed: true),
                                                              // inputFormatters: [
                                                              //   DecimalFormatter(),
                                                              // ],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          20),
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: AppLocalizations.of(
                                                                        context)!
                                                                    .translate(
                                                                        'commodity_name'),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            11.0,
                                                                        horizontal:
                                                                            9.0),
                                                              ),

                                                              onEditingComplete:
                                                                  () {
                                                                if (evaluateCo2()) {
                                                                  calculateCo2Report();
                                                                }
                                                                // evaluatePrice();
                                                              },
                                                              onChanged:
                                                                  (value) {
                                                                if (evaluateCo2()) {
                                                                  calculateCo2Report();
                                                                }
                                                              },
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return AppLocalizations.of(
                                                                          context)!
                                                                      .translate(
                                                                          'insert_value_validate');
                                                                }
                                                                return null;
                                                              },
                                                              onSaved:
                                                                  (newValue) {
                                                                commodityName_controllers[
                                                                            index]
                                                                        .text =
                                                                    newValue!;
                                                              },
                                                              onFieldSubmitted:
                                                                  (value) {
                                                                if (evaluateCo2()) {
                                                                  calculateCo2Report();
                                                                }
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                                BlocProvider.of<
                                                                            BottomNavBarCubit>(
                                                                        context)
                                                                    .emitShow();
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Focus(
                                                            focusNode:
                                                                _nodeCommodityWeight,
                                                            onFocusChange:
                                                                (bool focus) {
                                                              if (!focus) {
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                                BlocProvider.of<
                                                                            BottomNavBarCubit>(
                                                                        context)
                                                                    .emitShow();
                                                              }
                                                            },
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  commodityWeight_controllers[
                                                                      index],
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                            BottomNavBarCubit>(
                                                                        context)
                                                                    .emitHide();
                                                                commodityWeight_controllers[
                                                                            index]
                                                                        .selection =
                                                                    TextSelection(
                                                                        baseOffset:
                                                                            0,
                                                                        extentOffset: commodityWeight_controllers[index]
                                                                            .value
                                                                            .text
                                                                            .length);
                                                              },
                                                              // focusNode: _nodeWeight,
                                                              // enabled: !valueEnabled,
                                                              scrollPadding: EdgeInsets.only(
                                                                  bottom: MediaQuery.of(
                                                                              context)
                                                                          .viewInsets
                                                                          .bottom +
                                                                      50),
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              keyboardType:
                                                                  const TextInputType
                                                                      .numberWithOptions(
                                                                      decimal:
                                                                          true,
                                                                      signed:
                                                                          true),
                                                              inputFormatters: [
                                                                DecimalFormatter(),
                                                              ],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          20),
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: AppLocalizations.of(
                                                                        context)!
                                                                    .translate(
                                                                        'commodity_weight'),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            11.0,
                                                                        horizontal:
                                                                            9.0),
                                                              ),
                                                              onTapOutside:
                                                                  (event) {},
                                                              onEditingComplete:
                                                                  () {
                                                                if (evaluateCo2()) {
                                                                  calculateCo2Report();
                                                                }
                                                              },
                                                              onChanged:
                                                                  (value) {
                                                                if (evaluateCo2()) {
                                                                  calculateCo2Report();
                                                                }
                                                              },
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return AppLocalizations.of(
                                                                          context)!
                                                                      .translate(
                                                                          'insert_value_validate');
                                                                }
                                                                return null;
                                                              },
                                                              onSaved:
                                                                  (newValue) {
                                                                commodityWeight_controllers[
                                                                            index]
                                                                        .text =
                                                                    newValue!;
                                                              },
                                                              onFieldSubmitted:
                                                                  (value) {
                                                                if (evaluateCo2()) {
                                                                  calculateCo2Report();
                                                                }
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                                BlocProvider.of<
                                                                            BottomNavBarCubit>(
                                                                        context)
                                                                    .emitShow();
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  (_count > 1)
                                                      ? Positioned(
                                                          left: localeState
                                                                      .value
                                                                      .languageCode ==
                                                                  'en'
                                                              ? 5
                                                              : null,
                                                          right: localeState
                                                                      .value
                                                                      .languageCode ==
                                                                  'en'
                                                              ? null
                                                              : 5,
                                                          top: 5,
                                                          child: Container(
                                                            height: 30,
                                                            width: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColor
                                                                  .deepYellow,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: localeState
                                                                            .value
                                                                            .languageCode ==
                                                                        'en'
                                                                    ? const Radius
                                                                        .circular(
                                                                        12)
                                                                    : const Radius
                                                                        .circular(
                                                                        5),
                                                                topRight: localeState
                                                                            .value
                                                                            .languageCode ==
                                                                        'en'
                                                                    ? const Radius
                                                                        .circular(
                                                                        5)
                                                                    : const Radius
                                                                        .circular(
                                                                        15),
                                                                bottomLeft:
                                                                    const Radius
                                                                        .circular(
                                                                        5),
                                                                bottomRight:
                                                                    const Radius
                                                                        .circular(
                                                                        5),
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                (index + 1)
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                  (_count > 1) && (index != 0)
                                                      ? Positioned(
                                                          right: localeState
                                                                      .value
                                                                      .languageCode ==
                                                                  'en'
                                                              ? 0
                                                              : null,
                                                          left: localeState
                                                                      .value
                                                                      .languageCode ==
                                                                  'en'
                                                              ? null
                                                              : 0,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              remove(index);
                                                              // _showAlertDialog(index);
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              width: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            45),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                ],
                                              );
                                            }),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -18,
                                      child: GestureDetector(
                                        onTap: _add,
                                        child: AbsorbPointer(
                                          absorbing: true,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 32.h,
                                              width: 32.w,
                                              child: SvgPicture.asset(
                                                  "assets/icons/add.svg"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.5),
                          child: EnsureVisibleWhenFocused(
                            focusNode: _truck_node,
                            child: Card(
                              key: key2,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 1.0, vertical: 7.5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate('select_truck_type'),
                                        style: TextStyle(
                                          // color: AppColor.lightBlue,
                                          fontSize: 19.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    SizedBox(
                                      height: 185.h,
                                      child: BlocBuilder<TruckTypeBloc,
                                          TruckTypeState>(
                                        builder: (context, state) {
                                          if (state is TruckTypeLoadedSuccess) {
                                            truckTypes = [];
                                            truckTypes = state.truckTypes;
                                            for (var element in truckTypes) {
                                              trucknum.add(0);
                                              truckNumControllers
                                                  .add(TextEditingController());
                                            }
                                            return Scrollbar(
                                              controller: _scrollController,
                                              thumbVisibility: true,
                                              thickness: 2.0,
                                              child: Padding(
                                                padding: EdgeInsets.all(2.h),
                                                child: ListView.builder(
                                                  controller: _scrollController,
                                                  itemCount:
                                                      state.truckTypes.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.w,
                                                              vertical: 15.h),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                          setState(() {
                                                            truckError = false;
                                                            truckNumControllers[
                                                                    previousIndex]
                                                                .text = "";
                                                            trucknum[
                                                                previousIndex] = 0;
                                                            truckNumControllers[
                                                                    index]
                                                                .text = "1";
                                                            trucknum[index] = 1;
                                                            truckType = state
                                                                .truckTypes[
                                                                    index]
                                                                .id!;
                                                            previousIndex =
                                                                index;
                                                          });
                                                        },
                                                        child: Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: [
                                                            Container(
                                                              width: 175.w,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                                border:
                                                                    Border.all(
                                                                  color: truckType ==
                                                                          state
                                                                              .truckTypes[
                                                                                  index]
                                                                              .id!
                                                                      ? AppColor
                                                                          .deepYellow
                                                                      : AppColor
                                                                          .darkGrey,
                                                                  width: 2.w,
                                                                ),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.network(
                                                                    state
                                                                        .truckTypes[
                                                                            index]
                                                                        .image!,
                                                                    height:
                                                                        50.h,
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return Container(
                                                                        height:
                                                                            50.h,
                                                                        width:
                                                                            175.w,
                                                                        color: Colors
                                                                            .grey[300],
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(AppLocalizations.of(context)!.translate('image_load_error')),
                                                                        ),
                                                                      );
                                                                    },
                                                                    loadingBuilder:
                                                                        (context,
                                                                            child,
                                                                            loadingProgress) {
                                                                      if (loadingProgress ==
                                                                          null) {
                                                                        return child;
                                                                      }

                                                                      return Shimmer
                                                                          .fromColors(
                                                                        baseColor:
                                                                            (Colors.grey[300])!,
                                                                        highlightColor:
                                                                            (Colors.grey[100])!,
                                                                        enabled:
                                                                            true,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              50.h,
                                                                          width:
                                                                              175.w,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      );
                                                                    },
                                                                    // placeholder:
                                                                    //     Container(
                                                                    //   color: Colors
                                                                    //       .white,
                                                                    //   height:
                                                                    //       50.h,
                                                                    //   width: 50.h,
                                                                    // ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 7.h,
                                                                  ),
                                                                  Text(
                                                                    localeState.value.languageCode ==
                                                                            'en'
                                                                        ? state
                                                                            .truckTypes[
                                                                                index]
                                                                            .name!
                                                                        : state
                                                                            .truckTypes[index]
                                                                            .nameAr!,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          17.sp,
                                                                      color: AppColor
                                                                          .deepBlack,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 7.h,
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            5.w),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            if (truckType ==
                                                                                state.truckTypes[index].id!) {
                                                                              setState(() {
                                                                                trucknum[index]++;
                                                                                truckNumControllers[index].text = trucknum[index].toString();
                                                                              });
                                                                            } else {
                                                                              setState(() {
                                                                                truckError = false;
                                                                                truckNumControllers[previousIndex].text = "";
                                                                                trucknum[previousIndex] = 0;
                                                                                truckNumControllers[index].text = "1";
                                                                                trucknum[index] = 1;
                                                                                truckType = state.truckTypes[index].id!;
                                                                                previousIndex = index;
                                                                              });
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.all(3),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Colors.grey[600]!,
                                                                                width: 1,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(45),
                                                                            ),
                                                                            child: Icon(Icons.add,
                                                                                size: 25.w,
                                                                                color: Colors.blue[200]!),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              70.w,
                                                                          height:
                                                                              38.h,
                                                                          child:
                                                                              TextField(
                                                                            controller:
                                                                                truckNumControllers[index],
                                                                            // focusNode:
                                                                            //     _nodeTabaleh,
                                                                            enabled:
                                                                                false,

                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                const TextStyle(fontSize: 18),
                                                                            textInputAction:
                                                                                TextInputAction.done,
                                                                            keyboardType:
                                                                                const TextInputType.numberWithOptions(decimal: true, signed: true),
                                                                            inputFormatters: [
                                                                              DecimalFormatter(),
                                                                            ],

                                                                            decoration:
                                                                                const InputDecoration(
                                                                              labelText: "",
                                                                              alignLabelWithHint: true,
                                                                              contentPadding: EdgeInsets.zero,
                                                                            ),
                                                                            scrollPadding:
                                                                                EdgeInsets.only(
                                                                              bottom: MediaQuery.of(context).viewInsets.bottom + 50,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        // Text(
                                                                        //   tabalehNum.toString(),
                                                                        //   style: const TextStyle(fontSize: 30),
                                                                        // ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            if (truckType ==
                                                                                state.truckTypes[index].id!) {
                                                                              setState(() {
                                                                                if (trucknum[index] > 0) {
                                                                                  trucknum[index]--;
                                                                                  truckNumControllers[index].text = trucknum[index].toString();
                                                                                }
                                                                              });
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.all(3),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Colors.grey[600]!,
                                                                                width: 1,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(45),
                                                                            ),
                                                                            child: trucknum[index] > 1
                                                                                ? Icon(
                                                                                    Icons.remove,
                                                                                    size: 25.w,
                                                                                    color: Colors.blue[200]!,
                                                                                  )
                                                                                : Icon(
                                                                                    Icons.remove,
                                                                                    size: 25.w,
                                                                                    color: Colors.grey[600]!,
                                                                                  ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            truckType ==
                                                                    state
                                                                        .truckTypes[
                                                                            index]
                                                                        .id!
                                                                ? Positioned(
                                                                    right: -7.w,
                                                                    top: -10.h,
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              2),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppColor
                                                                            .deepYellow,
                                                                        borderRadius:
                                                                            BorderRadius.circular(45),
                                                                      ),
                                                                      child: Icon(
                                                                          Icons
                                                                              .check,
                                                                          size: 16
                                                                              .w,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  )
                                                                : const SizedBox
                                                                    .shrink()
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Shimmer.fromColors(
                                              baseColor: (Colors.grey[300])!,
                                              highlightColor:
                                                  (Colors.grey[100])!,
                                              enabled: true,
                                              direction: ShimmerDirection.rtl,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (_, __) => Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w,
                                                      vertical: 15.h),
                                                  child: Container(
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: SizedBox(
                                                      width: 175.w,
                                                      height: 70.h,
                                                    ),
                                                  ),
                                                ),
                                                itemCount: 6,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible: truckError,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate(
                                                      'select_truck_type_error'),
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.5),
                          child: Card(
                            color: Colors.white,
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
                                            .translate('choose_shippment_path'),
                                        style: TextStyle(
                                          // color: AppColor.lightBlue,
                                          fontSize: 19.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  TypeAheadField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      // autofocus: true,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      controller:
                                          shippmentProvider!.pickup_controller,
                                      scrollPadding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom +
                                              150),
                                      onTap: () {
                                        shippmentProvider!
                                                .pickup_controller!.selection =
                                            TextSelection(
                                                baseOffset: 0,
                                                extentOffset: shippmentProvider!
                                                    .pickup_controller!
                                                    .value
                                                    .text
                                                    .length);
                                      },

                                      style: const TextStyle(fontSize: 18),
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!
                                            .translate('enter_pickup_address'),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 9.0,
                                          vertical: 11.0,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ShippmentPickUpMapScreen(
                                                        type: 0,
                                                        location: shippmentProvider
                                                                .pickup_latlng ??
                                                            null),
                                              ),
                                            ).then((value) => FocusManager
                                                .instance.primaryFocus
                                                ?.unfocus());
                                            Future.delayed(const Duration(
                                                    milliseconds: 1500))
                                                .then((value) {
                                              if (evaluateCo2()) {
                                                calculateCo2Report();
                                              }
                                            });
                                            // Get.to(SearchFilterView());
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(7),
                                            width: 55.0,
                                            height: 15.0,
                                            child: Icon(
                                              Icons.map,
                                              color: AppColor.deepYellow,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onSubmitted: (value) {
                                        // BlocProvider.of<StopScrollCubit>(context)
                                        //     .emitEnable();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                    ),
                                    loadingBuilder: (context) {
                                      return Container(
                                        color: Colors.white,
                                        child: const Center(
                                          child: LoadingIndicator(),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error) {
                                      return Container(
                                        color: Colors.white,
                                      );
                                    },
                                    noItemsFoundBuilder: (value) {
                                      var localizedMessage =
                                          AppLocalizations.of(context)!
                                              .translate('no_result_found');
                                      return Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            localizedMessage,
                                            style: TextStyle(fontSize: 18.sp),
                                          ),
                                        ),
                                      );
                                    },
                                    suggestionsCallback: (pattern) async {
                                      // if (pattern.isNotEmpty) {
                                      //   BlocProvider.of<StopScrollCubit>(context)
                                      //       .emitDisable();
                                      // }
                                      return pattern.isEmpty
                                          ? []
                                          : await PlaceService.getAutocomplete(
                                              pattern);
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              // leading: Icon(Icons.shopping_cart),
                                              tileColor: Colors.white,
                                              title:
                                                  Text(suggestion.description!),
                                              // subtitle: Text('\$${suggestion['price']}'),
                                            ),
                                            Divider(
                                              color: Colors.grey[300],
                                              height: 3,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) async {
                                      var sLocation =
                                          await PlaceService.getPlace(
                                              suggestion.placeId);
                                      setState(() {
                                        shippmentProvider
                                            .setPickUpPlace(sLocation);
                                        shippmentProvider.setPickupLatLang(
                                            sLocation.geometry.location.lat,
                                            sLocation.geometry.location.lng);
                                        shippmentProvider.setPickupName(
                                            suggestion.description);
                                        shippmentProvider!.pickup_controller!
                                            .text = suggestion.description;
                                      });
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      if (evaluateCo2()) {
                                        calculateCo2Report();
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Visibility(
                                    visible: !deliveryPosition,
                                    child: !pickupLoading
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                pickupLoading = true;
                                                pickupPosition = true;
                                              });
                                              _getCurrentPositionForPickup();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: AppColor.deepYellow,
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .translate(
                                                          'pick_my_location'),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: LoadingIndicator(),
                                              ),
                                            ],
                                          ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Visibility(
                                    visible: shippmentProvider
                                        .pickup_controller!.text.isNotEmpty,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TypeAheadField(
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            // autofocus: true,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            controller: shippmentProvider!
                                                .delivery_controller,
                                            scrollPadding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom +
                                                    150),
                                            onTap: () {
                                              shippmentProvider!
                                                  .delivery_controller!
                                                  .selection = TextSelection(
                                                baseOffset: 0,
                                                extentOffset: shippmentProvider!
                                                    .delivery_controller!
                                                    .value
                                                    .text
                                                    .length,
                                              );
                                            },

                                            style:
                                                const TextStyle(fontSize: 18),
                                            decoration: InputDecoration(
                                              hintText: AppLocalizations.of(
                                                      context)!
                                                  .translate(
                                                      'enter_delivery_address'),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 9.0,
                                                vertical: 11.0,
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShippmentPickUpMapScreen(
                                                              type: 1,
                                                              location:
                                                                  shippmentProvider
                                                                          .delivery_latlng ??
                                                                      null),
                                                    ),
                                                  ).then((value) => FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus());

                                                  print(
                                                      "delivry address co2 evaluation");
                                                  // Get.to(SearchFilterView());
                                                  Future.delayed(const Duration(
                                                          milliseconds: 1500))
                                                      .then((value) {
                                                    if (evaluateCo2()) {
                                                      calculateCo2Report();
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(7),
                                                  width: 55.0,
                                                  height: 15.0,
                                                  // decoration: new BoxDecoration(
                                                  //   borderRadius: BorderRadius.circular(10),
                                                  //   border: Border.all(
                                                  //       color: Colors.black87, width: 1),
                                                  // ),
                                                  child: Icon(
                                                    Icons.map,
                                                    color: AppColor.deepYellow,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onSubmitted: (value) {
                                              // BlocProvider.of<StopScrollCubit>(context)
                                              //     .emitEnable();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                          ),
                                          loadingBuilder: (context) {
                                            return Container(
                                              color: Colors.white,
                                              child: const Center(
                                                child: LoadingIndicator(),
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, error) {
                                            return Container(
                                              color: Colors.white,
                                            );
                                          },
                                          noItemsFoundBuilder: (value) {
                                            var localizedMessage =
                                                AppLocalizations.of(context)!
                                                    .translate(
                                                        'no_result_found');
                                            return Container(
                                              width: double.infinity,
                                              color: Colors.white,
                                              child: Center(
                                                child: Text(
                                                  localizedMessage,
                                                  style: TextStyle(
                                                      fontSize: 18.sp),
                                                ),
                                              ),
                                            );
                                          },
                                          suggestionsCallback: (pattern) async {
                                            // if (pattern.isNotEmpty) {
                                            //   BlocProvider.of<StopScrollCubit>(context)
                                            //       .emitDisable();
                                            // }
                                            return pattern.isEmpty
                                                ? []
                                                : await PlaceService
                                                    .getAutocomplete(pattern);
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return Container(
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    // leading: Icon(Icons.shopping_cart),
                                                    tileColor: Colors.white,
                                                    title: Text(suggestion
                                                        .description!),
                                                    // subtitle: Text('\$${suggestion['price']}'),
                                                  ),
                                                  Divider(
                                                    color: Colors.grey[300],
                                                    height: 3,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          onSuggestionSelected:
                                              (suggestion) async {
                                            var sLocation =
                                                await PlaceService.getPlace(
                                                    suggestion.placeId);
                                            setState(() {
                                              shippmentProvider
                                                  .setDeliveryPlace(sLocation);
                                              shippmentProvider
                                                  .setDeliveryLatLang(
                                                      sLocation.geometry
                                                          .location.lat,
                                                      sLocation.geometry
                                                          .location.lng);
                                              shippmentProvider.setDeliveryName(
                                                  suggestion.description);
                                              shippmentProvider!
                                                      .delivery_controller!
                                                      .text =
                                                  suggestion.description;
                                            });

                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            if (evaluateCo2()) {
                                              calculateCo2Report();
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Visibility(
                                          visible: !pickupPosition,
                                          child: !deliveryLoading
                                              ? GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      deliveryLoading = true;
                                                      deliveryPosition = true;
                                                    });
                                                    _getCurrentPositionForDelivery();
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color:
                                                            AppColor.deepYellow,
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .translate(
                                                                'pick_my_location'),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 25,
                                                      width: 25,
                                                      child: LoadingIndicator(),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        // const SizedBox(
                                        //   height: 12,
                                        // ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Visibility(
                                    visible: pathError,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate('choose_path_error'),
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: AppColor.darkGrey,
                          height: 50,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("normal");
                                  shippmentProvider.setMapMode(MapType.normal);
                                  shippmentProvider.setMapStyle(_mapStyle);
                                },
                                child: SizedBox(
                                  height: 50,
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('normal'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  print("dark");
                                  shippmentProvider.setMapMode(MapType.normal);
                                  shippmentProvider.setMapStyle(_darkmapStyle);
                                },
                                child: SizedBox(
                                  height: 50,
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('dark'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  shippmentProvider.setMapMode(MapType.hybrid);
                                },
                                child: SizedBox(
                                  height: 50,
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('satellite'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              (shippmentProvider
                                          .pickup_location_name.isNotEmpty &&
                                      shippmentProvider
                                          .delivery_location_name.isNotEmpty)
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                ShipmentMapPreview(
                                              pickup: shippmentProvider
                                                  .pickup_latlng!,
                                              delivery: shippmentProvider
                                                  .delivery_latlng!,
                                            ),
                                            transitionDuration: const Duration(
                                                milliseconds: 1000),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              var begin =
                                                  const Offset(0.0, -1.0);
                                              var end = Offset.zero;
                                              var curve = Curves.ease;

                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));

                                              return SlideTransition(
                                                position:
                                                    animation.drive(tween),
                                                child: child,
                                              );
                                            },
                                          ),
                                        ).then((value) {
                                          if (shippmentProvider
                                              .delivery_location_name
                                              .isNotEmpty) {
                                            // getPolyPoints();
                                            shippmentProvider.initMapbounds();
                                          }
                                        });
                                        // shippmentProvider.setMapMode(MapType.satellite);
                                      },
                                      child: const SizedBox(
                                        height: 50,
                                        width: 70,
                                        child: Center(
                                          child: Icon(
                                            Icons.zoom_out_map,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        BlocListener<DrawRouteBloc, DrawRouteState>(
                          listener: (context, state) {
                            if (state is DrawRouteSuccess) {
                              Future.delayed(const Duration(milliseconds: 400))
                                  .then((value) {
                                if (shippmentProvider
                                    .delivery_location_name.isNotEmpty) {
                                  // getPolyPoints();
                                  shippmentProvider.initMapbounds();
                                }
                              });
                            }
                          },
                          child: SizedBox(
                            height: 300.h,
                            child: AbsorbPointer(
                              absorbing: false,
                              child: GoogleMap(
                                onMapCreated: (controller) {
                                  shippmentProvider.onMapCreated(
                                      controller, _mapStyle);
                                },
                                myLocationButtonEnabled: false,
                                zoomGesturesEnabled: false,
                                scrollGesturesEnabled: false,
                                tiltGesturesEnabled: false,
                                rotateGesturesEnabled: false,
                                // zoomControlsEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: shippmentProvider.center,
                                  zoom: shippmentProvider.zoom,
                                ),
                                gestureRecognizers: {},
                                markers: (shippmentProvider.pickup_latlng !=
                                            null ||
                                        shippmentProvider.delivery_latlng !=
                                            null)
                                    ? {
                                        shippmentProvider.pickup_latlng != null
                                            ? Marker(
                                                markerId:
                                                    const MarkerId("pickup"),
                                                position: LatLng(
                                                    shippmentProvider
                                                        .pickup_lat,
                                                    shippmentProvider
                                                        .pickup_lang),
                                                icon: pickupicon,
                                              )
                                            : const Marker(
                                                markerId: MarkerId("pickup"),
                                              ),
                                        shippmentProvider.delivery_latlng !=
                                                null
                                            ? Marker(
                                                markerId:
                                                    const MarkerId("delivery"),
                                                position: LatLng(
                                                    shippmentProvider
                                                        .delivery_lat,
                                                    shippmentProvider
                                                        .delivery_lang),
                                                icon: deliveryicon,
                                              )
                                            : const Marker(
                                                markerId: MarkerId("delivery"),
                                              ),
                                      }
                                    : {},
                                polylines: shippmentProvider
                                        .polylineCoordinates.isNotEmpty
                                    ? {
                                        Polyline(
                                          polylineId: const PolylineId("route"),
                                          points: shippmentProvider
                                              .polylineCoordinates,
                                          color: AppColor.deepYellow,
                                          width: 5,
                                        ),
                                      }
                                    : {},
                                mapType: shippmentProvider.mapType,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: co2error,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(AppLocalizations.of(context)!
                                .translate('shipment_load_complete_error')),
                          ),
                        ),
                        Visibility(
                          visible: shippmentProvider
                                  .delivery_location_name.isNotEmpty &&
                              shippmentProvider.co2report != null,
                          child: co2Loading
                              ? SizedBox(
                                  height: 10,
                                  child: LinearProgressIndicator(
                                    color: AppColor.deepYellow,
                                  ),
                                )
                              : shipmentStatistics(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.5),
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 7.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate('loading_time'),
                                    style: TextStyle(
                                      // color: AppColor.lightBlue,
                                      fontSize: 19.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .43,
                                        child: GestureDetector(
                                          onTap: _showDatePicker,
                                          child: TextFormField(
                                            controller: shippmentProvider
                                                .date_controller,
                                            enabled: false,
                                            style:
                                                const TextStyle(fontSize: 18),
                                            decoration: InputDecoration(
                                              labelText:
                                                  AppLocalizations.of(context)!
                                                      .translate('date'),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 11.0,
                                                      horizontal: 9.0),
                                              suffixIcon: const Icon(
                                                  Icons.calendar_month),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .43,
                                        child: GestureDetector(
                                          onTap: _showTimePicker,
                                          child: TextFormField(
                                            controller: shippmentProvider
                                                .time_controller,
                                            enabled: false,
                                            style:
                                                const TextStyle(fontSize: 18),
                                            decoration: InputDecoration(
                                              labelText:
                                                  AppLocalizations.of(context)!
                                                      .translate('time'),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 11.0,
                                                      horizontal: 9.0),
                                              suffixIcon: const Icon(
                                                  Icons.timer_outlined),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Visibility(
                                    visible: dateError,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate('pick_date_error'),
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        shippmentProvider.isThereARouteError,
                                    child: const Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "there is no available route change destination.",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.5),
                          child: BlocConsumer<ShippmentCreateBloc,
                              ShippmentCreateState>(
                            listener: (context, state) {
                              print(state);
                              if (state is ShippmentCreateSuccessState) {
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(SnackBar(
                                //   content: Text(AppLocalizations.of(context)!
                                //       .translate('shipment_created_success')),
                                //   duration: const Duration(seconds: 3),
                                // ));
                              }
                              if (state is ShippmentCreateFailureState) {
                                print(state.errorMessage);
                              }
                            },
                            builder: (context, state) {
                              if (state is ShippmentLoadingProgressState) {
                                return CustomButton(
                                  title: const LoadingIndicator(),
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
                                    if (shippmentProvider.thereARoute) {
                                      _addShipmentformKey.currentState?.save();
                                      if (_addShipmentformKey.currentState!
                                          .validate()) {
                                        if (truckType != 0) {
                                          setState(() {
                                            truckError = false;
                                          });
                                          if (shippmentProvider
                                                  .pickup_controller
                                                  .text
                                                  .isNotEmpty &&
                                              shippmentProvider
                                                  .delivery_controller
                                                  .text
                                                  .isNotEmpty) {
                                            setState(() {
                                              pathError = false;
                                            });
                                            if (shippmentProvider
                                                    .date_controller
                                                    .text
                                                    .isNotEmpty &&
                                                shippmentProvider
                                                    .time_controller
                                                    .text
                                                    .isNotEmpty) {
                                              setState(() {
                                                dateError = false;
                                              });

                                              BlocProvider.of<TrucksListBloc>(
                                                      context)
                                                  .add(TrucksListLoadEvent(
                                                      truckType));
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectTruckScreen(
                                                    commodityName_controllers:
                                                        commodityName_controllers,
                                                    commodityWeight_controllers:
                                                        commodityWeight_controllers,
                                                    truckType: truckType,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                dateError = true;
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              pathError = true;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            truckError = true;
                                          });
                                          Scrollable.ensureVisible(
                                            key2.currentContext!,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                          );
                                        }
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
                                    } else {
                                      shippmentProvider
                                          .setIsThereRoutError(true);
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !shippmentProvider.isThereARoute,
                  child: GestureDetector(
                    onTap: () {
                      shippmentProvider.setIsThereRout(true);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black54,
                        ),
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SizedBox(
                            height: 160.h,
                            width: MediaQuery.of(context).size.width * .75,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "there is no route between these two locations.",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          shippmentProvider
                                              .setIsThereRout(true);
                                        },
                                        child: AbsorbPointer(
                                          absorbing: true,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate('ok'),
                                              style: const TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget shipmentStatistics() {
    return addShippmentProvider != null &&
            addShippmentProvider!.co2report != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              // height: 40.h,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: BlocBuilder<LocaleCubit, LocaleState>(
                builder: (context, localeState) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: SvgPicture.asset(
                                    "assets/icons/distance.svg"),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .75,
                                child: Text(
                                  localeState.value.languageCode == 'en'
                                      ? "${addShippmentProvider!.co2report!.distance}"
                                      : "${addShippmentProvider!.co2report!.distance!.replaceAll(RegExp('km'), 'كم')}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: AppColor.lightGrey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                                width: 30,
                                child:
                                    SvgPicture.asset("assets/icons/time.svg"),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .75,
                                child: Text(
                                  localeState.value.languageCode == 'en'
                                      ? "${addShippmentProvider!.co2report!.duration}"
                                      : "${addShippmentProvider!.co2report!.duration!.replaceAll(RegExp('mins'), 'دقيقة').replaceAll(RegExp('hours'), 'ساعة')}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: AppColor.lightGrey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: SvgPicture.asset(
                                    "assets/icons/co2fingerprint.svg"),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .75,
                                child: Text(
                                  "${AppLocalizations.of(context)!.translate('total_co2')}: ${f.format(addShippmentProvider!.co2report!.et!.toInt())} ${localeState.value.languageCode == 'en' ? "kg" : "كغ"}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  void calculateCo2Report() {
    setState(() {
      co2Loading = true;
    });
    ShippmentDetail detail = ShippmentDetail();
    detail.legs = [];
    detail.load = [];
    Legs leg = Legs();
    leg.mode = "LTL";
    print("report!.title!");
    Origin origin = Origin();
    leg.origin = origin;
    Origin destination = Origin();
    leg.destination = destination;

    leg.origin!.latitude = addShippmentProvider!.pickup_lat;
    leg.origin!.longitude = addShippmentProvider!.pickup_lang;
    leg.destination!.latitude = addShippmentProvider!.delivery_lat;
    leg.destination!.longitude = addShippmentProvider!.delivery_lang;

    detail.legs!.add(leg);

    // for (var i = 0; i < commodityWeight_controllers.length; i++) {
    // }
    Load load = Load();
    load.unitWeightKg = 25000;
    load.unitType = "pallets";
    detail.load!.add(load);

    // for (var i = 0; i < commodityWeight_controllers.length; i++) {
    //   Load load = Load();
    //   load.unitWeightKg =
    //       double.parse(commodityWeight_controllers[i].text.replaceAll(",", ""));
    //   load.unitType = "pallets";
    //   detail.load!.add(load);
    // }

    Co2Service.getCo2Calculate(
            detail,
            LatLng(addShippmentProvider!.pickup_lat,
                addShippmentProvider!.pickup_lang),
            LatLng(addShippmentProvider!.delivery_lat,
                addShippmentProvider!.delivery_lang))
        .then((value) => addShippmentProvider!.setCo2Report(value!));
    setState(() {
      co2Loading = false;
    });
    print("calculation end");
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 150,
              left: 10,
              right: 10),
          content: const Text(
            'Location services are disabled. Please enable the services',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
      // setState(() {
      //   pickupLoading = false;
      // });
      // return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            dismissDirection: DismissDirection.up,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 150,
                left: 10,
                right: 10),
            content: const Text(
              'Location permissions are denied',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        );
        setState(() {
          pickupLoading = false;
        });
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 150,
              left: 10,
              right: 10),
          content: const Text(
            'Location permissions are permanently denied, we cannot request permissions.',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
      setState(() {
        pickupLoading = false;
      });
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPositionForPickup() async {
    final hasPermission = await _handleLocationPermission();
    print(hasPermission);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print(position);
      addShippmentProvider!
          .setPickupLatLang(position.latitude, position.longitude);
      addShippmentProvider!.setPickUpPosition(position);
      _getAddressForPickupFromLatLng(position);
    }).catchError((e) {
      setState(() {
        pickupLoading = false;
      });
      debugPrint(e);
    });
  }

  Future<void> _getAddressForPickupFromLatLng(Position position) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      addShippmentProvider!.setPickupName(
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""},${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}');
      addShippmentProvider!.pickup_controller.text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""},${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    setState(() {
      pickupLoading = false;
    });
    if (addShippmentProvider!.delivery_location_name.isNotEmpty) {
      calculateCo2Report();
    }
  }

  Future<void> _getCurrentPositionForDelivery() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      addShippmentProvider!
          .setDeliveryLatLang(position.latitude, position.longitude);
      addShippmentProvider!.setDeliveryPosition(position);
      _getAddressForDeliveryFromLatLng(position);
    }).catchError((e) {
      setState(() {
        deliveryLoading = false;
      });
      debugPrint(e);
    });
  }

  Future<void> _getAddressForDeliveryFromLatLng(Position position) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      addShippmentProvider!.setDeliveryName(
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""},${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}');
      addShippmentProvider!.delivery_controller.text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""},${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    setState(() {
      deliveryLoading = false;
    });
    calculateCo2Report();
    if (evaluateCo2()) {
      calculateCo2Report();
    }
  }
}
