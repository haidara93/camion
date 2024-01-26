import 'dart:async';
import 'dart:convert';

import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/shipments/shippment_create_bloc.dart';
import 'package:camion/business_logic/bloc/truck/truck_type_bloc.dart';
import 'package:camion/business_logic/bloc/truck/trucks_list_bloc.dart';
import 'package:camion/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/models/co2_report.dart';
import 'package:camion/data/models/place_model.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/data/models/truck_type_model.dart';
import 'package:camion/data/providers/add_shippment_provider.dart';
import 'package:camion/data/services/co2_service.dart';
import 'package:camion/data/services/places_service.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/helpers/formatter.dart';
import 'package:camion/views/screens/merchant/add_shippment_pickup_map.dart';
import 'package:camion/views/screens/merchant/choose_shipment_path_screen.dart';
import 'package:camion/views/screens/select_truck_screen.dart';
import 'package:camion/views/widgets/custom_botton.dart';
import 'package:camion/views/widgets/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
  // List<TextEditingController> commodityQuantity_controllers = [];
  // List<PackageType?> commodityPackageTypes = [];
  List<TruckType?> truckTypes = [];
  List<int> trucknum = [];
  List<TextEditingController> truckNumControllers = [];
  //the controllers list
  int _count = 0;

  int truckType = 0;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addShippmentProvider =
          Provider.of<AddShippmentProvider>(context, listen: false);
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
      _children = List.from(_children)
        ..add(
          Card(
            color: Colors.white,
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.translate('shippment_load'),
                    style: TextStyle(
                      // color: AppColor.lightBlue,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  TextFormField(
                    controller: commodityName_controller,
                    onTap: () {
                      BlocProvider.of<BottomNavBarCubit>(context).emitHide();
                      commodityName_controller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset:
                              commodityName_controller.value.text.length);
                    },
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .translate('commodity_name'),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 11.0, horizontal: 9.0),
                    ),
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                    },
                    onEditingComplete: () {
                      if (evaluateCo2()) {
                        calculateCo2Report();
                      }
                    },
                    onChanged: (value) {
                      if (evaluateCo2()) {
                        calculateCo2Report();
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!
                            .translate('insert_value_validate');
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      commodityName_controller.text = newValue!;
                    },
                    onFieldSubmitted: (value) {
                      if (evaluateCo2()) {
                        calculateCo2Report();
                      }
                      FocusManager.instance.primaryFocus?.unfocus();
                      BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: commodityWeight_controller,
                    onTap: () {
                      BlocProvider.of<BottomNavBarCubit>(context).emitHide();
                      commodityWeight_controller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset:
                              commodityWeight_controller.value.text.length);
                    },
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                    textInputAction: TextInputAction.done,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    inputFormatters: [
                      DecimalFormatter(),
                    ],
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .translate('commodity_weight'),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 11.0, horizontal: 9.0),
                    ),
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                    },
                    onEditingComplete: () {
                      if (evaluateCo2()) {
                        calculateCo2Report();
                      }
                    },
                    onChanged: (value) {
                      if (evaluateCo2()) {
                        calculateCo2Report();
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!
                            .translate('insert_value_validate');
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      commodityWeight_controller.text = newValue!;
                    },
                    onFieldSubmitted: (value) {
                      if (evaluateCo2()) {
                        calculateCo2Report();
                      }
                      FocusManager.instance.primaryFocus?.unfocus();
                      BlocProvider.of<BottomNavBarCubit>(context).emitShow();
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
      setState(() => ++_count);
    });
    rootBundle.loadString('assets/style/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  void _add() {
    TextEditingController commodityName_controller = TextEditingController();
    TextEditingController commodityWeight_controller = TextEditingController();
    // TextEditingController commodityQuantity_controller =
    //     TextEditingController();

    commodityName_controllers.add(commodityName_controller);
    commodityWeight_controllers.add(commodityWeight_controller);
    // commodityQuantity_controllers.add(commodityQuantity_controller);
    // commodityPackageTypes.add(null);

    _children = List.from(_children)
      ..add(
        Card(
          color: Colors.white,
          margin: const EdgeInsets.all(5),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.5),
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: commodityName_controller,
                  onTap: () {
                    BlocProvider.of<BottomNavBarCubit>(context).emitHide();
                    commodityName_controller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset:
                            commodityName_controller.value.text.length);
                  },
                  // focusNode: _nodeWeight,
                  // enabled: !valueEnabled,
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                  textInputAction: TextInputAction.done,
                  // keyboardType:
                  //     const TextInputType.numberWithOptions(
                  //         decimal: true, signed: true),
                  // inputFormatters: [
                  //   DecimalFormatter(),
                  // ],
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .translate('commodity_name'),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 11.0, horizontal: 9.0),
                  ),
                  onTapOutside: (event) {},
                  onEditingComplete: () {
                    if (evaluateCo2()) {
                      calculateCo2Report();
                    }
                    // evaluatePrice();
                  },
                  onChanged: (value) {
                    if (evaluateCo2()) {
                      calculateCo2Report();
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!
                          .translate('insert_value_validate');
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    commodityName_controller.text = newValue!;
                  },
                  onFieldSubmitted: (value) {
                    if (evaluateCo2()) {
                      calculateCo2Report();
                    }
                    FocusManager.instance.primaryFocus?.unfocus();
                    BlocProvider.of<BottomNavBarCubit>(context).emitShow();
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: commodityWeight_controller,
                  onTap: () {
                    BlocProvider.of<BottomNavBarCubit>(context).emitHide();
                    commodityWeight_controller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset:
                            commodityWeight_controller.value.text.length);
                  },
                  // focusNode: _nodeWeight,
                  // enabled: !valueEnabled,
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                  textInputAction: TextInputAction.done,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  inputFormatters: [
                    DecimalFormatter(),
                  ],
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .translate('commodity_weight'),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 11.0, horizontal: 9.0),
                  ),
                  onTapOutside: (event) {},
                  onEditingComplete: () {
                    if (evaluateCo2()) {
                      calculateCo2Report();
                    }
                  },
                  onChanged: (value) {
                    if (evaluateCo2()) {
                      calculateCo2Report();
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!
                          .translate('insert_value_validate');
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    commodityWeight_controller.text = newValue!;
                  },
                  onFieldSubmitted: (value) {
                    if (evaluateCo2()) {
                      calculateCo2Report();
                    }
                    FocusManager.instance.primaryFocus?.unfocus();
                    BlocProvider.of<BottomNavBarCubit>(context).emitShow();
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
    setState(() => ++_count);
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
    for (var element in commodityName_controllers) {
      if (element.text.isEmpty) {
        return false;
      }
    }
    for (var element in commodityWeight_controllers) {
      if (element.text.isEmpty) {
        return false;
      }
    }
    if (addShippmentProvider!.delivery_location_name.isNotEmpty &&
        addShippmentProvider!.pickup_location_name.isNotEmpty) {
      return true;
    } else {
      return false;
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
            backgroundColor: AppColor.lightGrey200,
            body: SingleChildScrollView(
              child: Consumer<AddShippmentProvider>(
                builder: (context, shippmentProvider, child) {
                  // shippmentProvider.initMapbounds();

                  return Column(
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
                                      child: ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children: _children,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -15,
                                    child: GestureDetector(
                                      onTap: _add,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(45),
                                          border: Border.all(
                                            color: Colors.grey[400]!,
                                            width: 2,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(1.0),
                                        child: Icon(
                                          Icons.add_circle_outline,
                                          color: AppColor.deepYellow,
                                          size: 25,
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
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.w,
                                                            vertical: 15.h),
                                                    child: GestureDetector(
                                                      onTap: () {
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
                                                              .truckTypes[index]
                                                              .id!;
                                                          previousIndex = index;
                                                        });
                                                      },
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
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
                                                                  height: 50.h,
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
                                                                              .grey[
                                                                          300],
                                                                      child:
                                                                          Center(
                                                                        child: Text(
                                                                            AppLocalizations.of(context)!.translate('image_load_error')),
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

                                                                    return SizedBox(
                                                                      height:
                                                                          50.h,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          value: loadingProgress.expectedTotalBytes != null
                                                                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                              : null,
                                                                        ),
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
                                                                  state
                                                                      .truckTypes[
                                                                          index]
                                                                      .name!,
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
                                                                  padding: EdgeInsets
                                                                      .symmetric(
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
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              3),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.grey[600]!,
                                                                              width: 1,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(45),
                                                                          ),
                                                                          child: Icon(
                                                                              Icons.add,
                                                                              size: 25.w,
                                                                              color: Colors.blue[200]!),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            70.w,
                                                                        height:
                                                                            55.h,
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
                                                                          keyboardType: const TextInputType
                                                                              .numberWithOptions(
                                                                              decimal: true,
                                                                              signed: true),
                                                                          inputFormatters: [
                                                                            DecimalFormatter(),
                                                                          ],
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            labelText:
                                                                                "",
                                                                            alignLabelWithHint:
                                                                                true,
                                                                            contentPadding:
                                                                                EdgeInsets.zero,
                                                                          ),
                                                                          scrollPadding:
                                                                              EdgeInsets.only(
                                                                            bottom:
                                                                                MediaQuery.of(context).viewInsets.bottom + 50,
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
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              3),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.grey[600]!,
                                                                              width: 1,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(45),
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
                                                                          BorderRadius.circular(
                                                                              45),
                                                                    ),
                                                                    child: Icon(
                                                                        Icons
                                                                            .check,
                                                                        size: 16
                                                                            .w,
                                                                        color: Colors
                                                                            .white),
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
                                            highlightColor: (Colors.grey[100])!,
                                            enabled: true,
                                            direction: ShimmerDirection.rtl,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (_, __) => Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                    vertical: 15.h),
                                                child: Container(
                                                  clipBehavior: Clip.antiAlias,
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
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('choose_shippment_path'),
                                  style: TextStyle(
                                    // color: AppColor.lightBlue,
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('pickup_address'),
                                  style: TextStyle(
                                    // color: AppColor.lightBlue,
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TypeAheadField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    // autofocus: true,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    controller:
                                        shippmentProvider.pickup_controller,
                                    scrollPadding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom +
                                            150),
                                    onTapOutside: (event) {
                                      BlocProvider.of<BottomNavBarCubit>(
                                              context)
                                          .emitShow();
                                    },
                                    onTap: () {
                                      BlocProvider.of<BottomNavBarCubit>(
                                              context)
                                          .emitHide();

                                      shippmentProvider
                                              .pickup_controller!.selection =
                                          TextSelection(
                                              baseOffset: 0,
                                              extentOffset: shippmentProvider
                                                  .pickup_controller!
                                                  .value
                                                  .text
                                                  .length);
                                    },

                                    style: const TextStyle(fontSize: 18),
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
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
                                                      type: 0),
                                            ),
                                          );
                                          // Get.to(SearchFilterView());
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(7),
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
                                      BlocProvider.of<BottomNavBarCubit>(
                                              context)
                                          .emitShow();

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
                                    var sLocation = await PlaceService.getPlace(
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
                                    if (evaluateCo2()) {
                                      calculateCo2Report();
                                    }
                                    BlocProvider.of<BottomNavBarCubit>(context)
                                        .emitShow();

                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
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
                                      Text(
                                        AppLocalizations.of(context)!
                                            .translate('delivery_address'),
                                        style: TextStyle(
                                          // color: AppColor.lightBlue,
                                          fontSize: 19.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TypeAheadField(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          // autofocus: true,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          controller: shippmentProvider!
                                              .delivery_controller,
                                          scrollPadding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom +
                                                  150),
                                          onTapOutside: (event) {
                                            BlocProvider.of<BottomNavBarCubit>(
                                                    context)
                                                .emitShow();
                                          },
                                          onTap: () {
                                            BlocProvider.of<BottomNavBarCubit>(
                                                    context)
                                                .emitHide();

                                            shippmentProvider!
                                                    .delivery_controller!
                                                    .selection =
                                                TextSelection(
                                                    baseOffset: 0,
                                                    extentOffset:
                                                        shippmentProvider!
                                                            .delivery_controller!
                                                            .value
                                                            .text
                                                            .length);
                                          },

                                          style: const TextStyle(fontSize: 18),
                                          decoration: InputDecoration(
                                            labelText: AppLocalizations.of(
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
                                                            type: 1),
                                                  ),
                                                );
                                                // Get.to(SearchFilterView());
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.all(7),
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
                                            BlocProvider.of<BottomNavBarCubit>(
                                                    context)
                                                .emitShow();

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
                                                style:
                                                    TextStyle(fontSize: 18.sp),
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
                                                  title: Text(
                                                      suggestion.description!),
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
                                                    sLocation
                                                        .geometry.location.lat,
                                                    sLocation
                                                        .geometry.location.lng);
                                            shippmentProvider.setDeliveryName(
                                                suggestion.description);
                                            shippmentProvider!
                                                .delivery_controller!
                                                .text = suggestion.description;
                                          });
                                          calculateCo2Report();
                                          BlocProvider.of<BottomNavBarCubit>(
                                                  context)
                                              .emitShow();

                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
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
                                      const SizedBox(
                                        height: 12,
                                      ),
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
                                shippmentProvider.setMapMode(MapType.normal);
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
                                shippmentProvider.setMapMode(MapType.satellite);
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
                            // GestureDetector(
                            //   onTap: () {
                            //     // shippmentProvider.setMapMode(MapType.satellite);
                            //   },
                            //   child: const SizedBox(
                            //     height: 50,
                            //     width: 70,
                            //     child: Center(
                            //       child: Icon(
                            //         Icons.zoom_out_map,
                            //         color: Colors.white,
                            //         size: 35,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 300.h,
                        child: GoogleMap(
                          onMapCreated: (controller) {
                            shippmentProvider.onMapCreated(
                                controller, _mapStyle);
                          },
                          initialCameraPosition: CameraPosition(
                            target: shippmentProvider.center,
                            zoom: shippmentProvider.zoom,
                          ),
                          // gestureRecognizers:
                          //     shippmentProvider.pickup_latlng != null
                          //         ? {
                          //             Factory<OneSequenceGestureRecognizer>(
                          //               () => EagerGestureRecognizer(),
                          //             ),
                          //           }
                          //         : {},
                          markers: (shippmentProvider.pickup_latlng != null ||
                                  shippmentProvider.delivery_latlng != null)
                              ? {
                                  shippmentProvider.pickup_latlng != null
                                      ? Marker(
                                          markerId: const MarkerId("pickup"),
                                          position: LatLng(
                                              shippmentProvider.pickup_lat,
                                              shippmentProvider.pickup_lang),
                                        )
                                      : const Marker(
                                          markerId: MarkerId("pickup"),
                                        ),
                                  shippmentProvider.delivery_latlng != null
                                      ? Marker(
                                          markerId: const MarkerId("delivery"),
                                          position: LatLng(
                                              shippmentProvider.delivery_lat,
                                              shippmentProvider.delivery_lang),
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
                                    points:
                                        shippmentProvider.polylineCoordinates,
                                    color: AppColor.deepYellow,
                                    width: 5,
                                  ),
                                }
                              : {},
                          mapType: shippmentProvider.mapType,
                        ),
                      ),
                      Visibility(
                        visible: co2error,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
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
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                      child: GestureDetector(
                                        onTap: _showDatePicker,
                                        child: TextFormField(
                                          controller:
                                              shippmentProvider.date_controller,
                                          enabled: false,
                                          style: const TextStyle(fontSize: 18),
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
                                      width: MediaQuery.of(context).size.width *
                                          .43,
                                      child: GestureDetector(
                                        onTap: _showTimePicker,
                                        child: TextFormField(
                                          controller:
                                              shippmentProvider.time_controller,
                                          enabled: false,
                                          style: const TextStyle(fontSize: 18),
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .translate('shipment_created_success')),
                                duration: Duration(seconds: 3),
                              ));
                              BlocProvider.of<TrucksListBloc>(context)
                                  .add(TrucksListLoadEvent(state.shipment));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectTruckScreen(),
                                  ));
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
                                  _addShipmentformKey.currentState?.save();
                                  if (_addShipmentformKey.currentState!
                                      .validate()) {
                                    if (truckType != 0) {
                                      setState(() {
                                        truckError = false;
                                      });
                                      if (shippmentProvider.pickup_controller
                                              .text.isNotEmpty &&
                                          shippmentProvider.delivery_controller
                                              .text.isNotEmpty) {
                                        setState(() {
                                          pathError = false;
                                        });
                                        if (shippmentProvider.date_controller
                                                .text.isNotEmpty &&
                                            shippmentProvider.time_controller
                                                .text.isNotEmpty) {
                                          setState(() {
                                            dateError = false;
                                          });
                                          Shipment shipment = Shipment();
                                          shipment.truckType =
                                              TruckType(id: truckType);
                                          shipment.pickupCityLocation =
                                              shippmentProvider
                                                  .pickup_location_name;
                                          shipment.pickupCityLat =
                                              shippmentProvider.pickup_lat;
                                          shipment.pickupCityLang =
                                              shippmentProvider.pickup_lang;
                                          shipment.deliveryCityLocation =
                                              shippmentProvider
                                                  .delivery_location_name;
                                          shipment.deliveryCityLat =
                                              shippmentProvider.delivery_lat;
                                          shipment.deliveryCityLang =
                                              shippmentProvider.delivery_lang;

                                          var totalWeight = 0;
                                          List<ShipmentItems> items = [];
                                          for (var i = 0;
                                              i <
                                                  commodityWeight_controllers
                                                      .length;
                                              i++) {
                                            ShipmentItems item = ShipmentItems(
                                              commodityName:
                                                  commodityName_controllers[i]
                                                      .text,
                                              commodityWeight: double.parse(
                                                      commodityWeight_controllers[
                                                              i]
                                                          .text
                                                          .replaceAll(",", ""))
                                                  .toInt(),
                                            );
                                            items.add(item);
                                            totalWeight += double.parse(
                                                    commodityWeight_controllers[
                                                            i]
                                                        .text
                                                        .replaceAll(",", ""))
                                                .toInt();
                                          }
                                          shipment.totalWeight = totalWeight;
                                          shipment.shipmentItems = items;
                                          // shipment.pickupDate = DateTime.now();
                                          shipment.pickupDate = DateTime(
                                            shippmentProvider.loadDate!.year,
                                            shippmentProvider.loadDate!.month,
                                            shippmentProvider.loadDate!.day,
                                            shippmentProvider.loadTime!.hour,
                                            shippmentProvider.loadTime!.day,
                                          );
                                          print("sdf");
                                          BlocProvider.of<ShippmentCreateBloc>(
                                                  context)
                                              .add(ShippmentCreateButtonPressed(
                                                  shipment));
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

                                  FocusManager.instance.primaryFocus?.unfocus();
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
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget shipmentStatistics() {
    return addShippmentProvider != null &&
            addShippmentProvider!.co2report != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // height: 40.h,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColor.deepBlack,
                borderRadius: BorderRadius.circular(15),
              ),
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
                          child: SvgPicture.asset("assets/icons/time.svg"),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          // width: MediaQuery.of(context).size.width * .3,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              "${addShippmentProvider!.co2report!.duration}",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: SvgPicture.asset("assets/icons/distance.svg"),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .2,
                          child: Text(
                            "${addShippmentProvider!.co2report!.distance}",
                            style: const TextStyle(
                              color: Colors.white,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: SvgPicture.asset(
                              "assets/icons/co2fingerprint.svg"),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .35,
                          child: Text(
                            "${AppLocalizations.of(context)!.translate('total_co2')}: ${addShippmentProvider!.co2report!.et}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .35,
                          child: Text(
                            "${AppLocalizations.of(context)!.translate('energy_consumption')}: ${addShippmentProvider!.co2report!.gt}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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

    for (var i = 0; i < commodityWeight_controllers.length; i++) {
      Load load = Load();
      load.unitWeightKg =
          double.parse(commodityWeight_controllers[i].text.replaceAll(",", ""));
      load.unitType = "pallets";
      detail.load!.add(load);
    }

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
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
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
            const SnackBar(content: Text('Location permissions are denied')));
        setState(() {
          pickupLoading = false;
        });
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
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
    print(response.statusCode);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      addShippmentProvider!.setPickupName(
          result["results"][0]["address_components"][1]["long_name"]);
      addShippmentProvider!.pickup_controller.text =
          result["results"][0]["address_components"][1]["long_name"];
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
          result["results"][0]["address_components"][1]["long_name"]);
      addShippmentProvider!.delivery_controller.text =
          result["results"][0]["address_components"][1]["long_name"];
    }
    setState(() {
      deliveryLoading = false;
    });
    calculateCo2Report();
  }
}
