// import 'dart:async';

// import 'package:camion/Localization/app_localizations.dart';
// import 'package:camion/business_logic/bloc/package_type_bloc.dart';
// import 'package:camion/business_logic/bloc/truck_type_bloc.dart';
// import 'package:camion/business_logic/cubit/bottom_nav_bar_cubit.dart';
// import 'package:camion/business_logic/cubit/locale_cubit.dart';
// import 'package:camion/data/models/shipment_model.dart';
// import 'package:camion/data/models/truck_type_model.dart';
// import 'package:camion/data/providers/add_shippment_provider.dart';
// import 'package:camion/helpers/color_constants.dart';
// import 'package:camion/helpers/formatter.dart';
// import 'package:camion/views/screens/choose_shipment_path_screen.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';

// class AddShippmentScreen extends StatefulWidget {
//   AddShippmentScreen({Key? key}) : super(key: key);

//   @override
//   State<AddShippmentScreen> createState() => _AddShippmentScreenState();
// }

// class _AddShippmentScreenState extends State<AddShippmentScreen> {
//   List<Widget> _children = [];

//   final LatLng _center = const LatLng(45.521563, -122.677433);
//   late GoogleMapController mapController;

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   List<TextEditingController> commodityName_controllers = [];
//   List<TextEditingController> commodityWeight_controllers = [];
//   List<TextEditingController> commodityQuantity_controllers = [];
//   List<PackageType?> commodityPackageTypes = [];
//   List<TruckType?> truckTypes = [];
//   List<int> trucknum = [];
//   List<TextEditingController> truckNumControllers = [];
//   //the controllers list
//   int _count = 0;

//   int truckType = 0;
//   int previousIndex = 0;
//   final ScrollController _scrollController = ScrollController();

//   final GlobalKey<FormState> _addShipmentformKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     TextEditingController commodityName_controller = TextEditingController();
//     TextEditingController commodityWeight_controller = TextEditingController();
//     TextEditingController commodityQuantity_controller =
//         TextEditingController();

//     commodityName_controllers.add(commodityName_controller);
//     commodityWeight_controllers.add(commodityWeight_controller);
//     commodityQuantity_controllers.add(commodityQuantity_controller);
//     commodityPackageTypes.add(null);
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _children = List.from(_children)
//         ..add(
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4.0),
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: commodityName_controller,
//                   onTap: () {
//                     BlocProvider.of<BottomNavBarCubit>(context).emitHide();
//                     commodityName_controller.selection = TextSelection(
//                         baseOffset: 0,
//                         extentOffset:
//                             commodityName_controller.value.text.length);
//                   },
//                   scrollPadding: EdgeInsets.only(
//                       bottom: MediaQuery.of(context).viewInsets.bottom + 50),
//                   textInputAction: TextInputAction.done,
//                   style: const TextStyle(fontSize: 18),
//                   decoration: InputDecoration(
//                     labelText: AppLocalizations.of(context)!
//                         .translate('commodity_name'),
//                     contentPadding: const EdgeInsets.symmetric(
//                         vertical: 11.0, horizontal: 9.0),
//                   ),
//                   onTapOutside: (event) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                     BlocProvider.of<BottomNavBarCubit>(context).emitShow();
//                   },
//                   onEditingComplete: () {
//                     // evaluatePrice();
//                   },
//                   onChanged: (value) {},
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return AppLocalizations.of(context)!
//                           .translate('insert_value_validate');
//                     }
//                     return null;
//                   },
//                   onSaved: (newValue) {
//                     commodityName_controller.text = newValue!;
//                   },
//                   onFieldSubmitted: (value) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                     BlocProvider.of<BottomNavBarCubit>(context).emitShow();
//                   },
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 TextFormField(
//                   controller: commodityWeight_controller,
//                   onTap: () {
//                     BlocProvider.of<BottomNavBarCubit>(context).emitHide();
//                     commodityWeight_controller.selection = TextSelection(
//                         baseOffset: 0,
//                         extentOffset:
//                             commodityWeight_controller.value.text.length);
//                   },
//                   scrollPadding: EdgeInsets.only(
//                       bottom: MediaQuery.of(context).viewInsets.bottom + 50),
//                   textInputAction: TextInputAction.done,
//                   keyboardType: const TextInputType.numberWithOptions(
//                       decimal: true, signed: true),
//                   inputFormatters: [
//                     DecimalFormatter(),
//                   ],
//                   style: const TextStyle(fontSize: 18),
//                   decoration: InputDecoration(
//                     labelText: AppLocalizations.of(context)!
//                         .translate('commodity_weight'),
//                     contentPadding: const EdgeInsets.symmetric(
//                         vertical: 11.0, horizontal: 9.0),
//                   ),
//                   onTapOutside: (event) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                     BlocProvider.of<BottomNavBarCubit>(context).emitShow();
//                   },
//                   onEditingComplete: () {
//                     // evaluatePrice();
//                   },
//                   onChanged: (value) {},
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return AppLocalizations.of(context)!
//                           .translate('insert_value_validate');
//                     }
//                     return null;
//                   },
//                   onSaved: (newValue) {
//                     commodityWeight_controller.text = newValue!;
//                   },
//                   onFieldSubmitted: (value) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                     BlocProvider.of<BottomNavBarCubit>(context).emitShow();
//                   },
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 TextFormField(
//                   controller: commodityQuantity_controller,
//                   onTap: () {
//                     BlocProvider.of<BottomNavBarCubit>(context).emitHide();
//                     commodityQuantity_controller.selection = TextSelection(
//                         baseOffset: 0,
//                         extentOffset:
//                             commodityQuantity_controller.value.text.length);
//                   },
//                   scrollPadding: EdgeInsets.only(
//                       bottom: MediaQuery.of(context).viewInsets.bottom + 50),
//                   textInputAction: TextInputAction.done,
//                   keyboardType: const TextInputType.numberWithOptions(
//                       decimal: true, signed: true),
//                   inputFormatters: [
//                     DecimalFormatter(),
//                   ],
//                   style: const TextStyle(fontSize: 18),
//                   decoration: InputDecoration(
//                     labelText: AppLocalizations.of(context)!
//                         .translate('commodity_quantity'),
//                     contentPadding: const EdgeInsets.symmetric(
//                         vertical: 11.0, horizontal: 9.0),
//                   ),
//                   onTapOutside: (event) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                     BlocProvider.of<BottomNavBarCubit>(context).emitShow();
//                   },
//                   onEditingComplete: () {
//                     // evaluatePrice();
//                   },
//                   onChanged: (value) {},
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return AppLocalizations.of(context)!
//                           .translate('insert_value_validate');
//                     }
//                     return null;
//                   },
//                   onSaved: (newValue) {
//                     commodityQuantity_controller.text = newValue!;
//                   },
//                   onFieldSubmitted: (value) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                     BlocProvider.of<BottomNavBarCubit>(context).emitShow();
//                   },
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 BlocBuilder<PackageTypeBloc, PackageTypeState>(
//                   builder: (context, state2) {
//                     if (state2 is PackageTypeLoadedSuccess) {
//                       return StatefulBuilder(builder: (context, setState2) {
//                         return DropdownButtonHideUnderline(
//                           child: DropdownButton2<PackageType>(
//                             isExpanded: true,
//                             hint: Text(
//                               AppLocalizations.of(context)!
//                                   .translate('package_type'),
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Theme.of(context).hintColor,
//                               ),
//                             ),
//                             items: state2.packageTypes
//                                 .map((PackageType item) =>
//                                     DropdownMenuItem<PackageType>(
//                                       value: item,
//                                       child: SizedBox(
//                                         width: 200,
//                                         child: Text(
//                                           item.name!,
//                                           style: const TextStyle(
//                                             fontSize: 17,
//                                           ),
//                                         ),
//                                       ),
//                                     ))
//                                 .toList(),
//                             value: commodityPackageTypes[0],
//                             onChanged: (PackageType? value) {
//                               setState2(() {
//                                 commodityPackageTypes[0] = value!;
//                                 print(commodityPackageTypes[0]!.name);
//                               });
//                             },
//                             buttonStyleData: ButtonStyleData(
//                               height: 50,
//                               width: double.infinity,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 9.0,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: Colors.black26,
//                                 ),
//                                 color: Colors.white,
//                               ),
//                               // elevation: 2,
//                             ),
//                             iconStyleData: IconStyleData(
//                               icon: const Icon(
//                                 Icons.keyboard_arrow_down_sharp,
//                               ),
//                               iconSize: 20,
//                               iconEnabledColor: AppColor.deepYellow,
//                               iconDisabledColor: Colors.grey,
//                             ),
//                             dropdownStyleData: DropdownStyleData(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(14),
//                                 color: Colors.white,
//                               ),
//                               scrollbarTheme: ScrollbarThemeData(
//                                 radius: const Radius.circular(40),
//                                 thickness: MaterialStateProperty.all(6),
//                                 thumbVisibility:
//                                     MaterialStateProperty.all(true),
//                               ),
//                             ),
//                             menuItemStyleData: const MenuItemStyleData(
//                               height: 40,
//                             ),
//                           ),
//                         );
//                       });
//                     } else if (state2 is PackageTypeLoadingProgress) {
//                       return const Center(
//                         child: LinearProgressIndicator(),
//                       );
//                     } else if (state2 is PackageTypeLoadedFailed) {
//                       return Center(
//                         child: GestureDetector(
//                           onTap: () {
//                             BlocProvider.of<PackageTypeBloc>(context)
//                                 .add(PackageTypeLoadEvent());
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 AppLocalizations.of(context)!
//                                     .translate('list_error'),
//                                 style: const TextStyle(color: Colors.red),
//                               ),
//                               const Icon(
//                                 Icons.refresh,
//                                 color: Colors.grey,
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                     } else {
//                       return Container();
//                     }
//                   },
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//               ],
//             ),
//           ),
//         );
//       setState(() => ++_count);
//     });
//   }

//   void _add() {
//     TextEditingController commodityName_controller = TextEditingController();
//     TextEditingController commodityWeight_controller = TextEditingController();
//     TextEditingController commodityQuantity_controller =
//         TextEditingController();

//     commodityName_controllers.add(commodityName_controller);
//     commodityWeight_controllers.add(commodityWeight_controller);
//     commodityQuantity_controllers.add(commodityQuantity_controller);
//     commodityPackageTypes.add(null);

//     _children = List.from(_children)
//       ..add(
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 4.0),
//           child: Column(
//             children: [
//               Divider(
//                 color: AppColor.deepBlack,
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//               TextFormField(
//                 controller: commodityName_controller,
//                 onTap: () {
//                   BlocProvider.of<BottomNavBarCubit>(context).emitHide();
//                   commodityName_controller.selection = TextSelection(
//                       baseOffset: 0,
//                       extentOffset: commodityName_controller.value.text.length);
//                 },
//                 // focusNode: _nodeWeight,
//                 // enabled: !valueEnabled,
//                 scrollPadding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom + 50),
//                 textInputAction: TextInputAction.done,
//                 // keyboardType:
//                 //     const TextInputType.numberWithOptions(
//                 //         decimal: true, signed: true),
//                 // inputFormatters: [
//                 //   DecimalFormatter(),
//                 // ],
//                 style: const TextStyle(fontSize: 18),
//                 decoration: InputDecoration(
//                   labelText:
//                       AppLocalizations.of(context)!.translate('commodity_name'),
//                   contentPadding: const EdgeInsets.symmetric(
//                       vertical: 11.0, horizontal: 9.0),
//                 ),
//                 onTapOutside: (event) {},
//                 onEditingComplete: () {
//                   // evaluatePrice();
//                 },
//                 onChanged: (value) {},
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return AppLocalizations.of(context)!
//                         .translate('insert_value_validate');
//                   }
//                   return null;
//                 },
//                 onSaved: (newValue) {
//                   commodityName_controller.text = newValue!;
//                 },
//                 onFieldSubmitted: (value) {
//                   FocusManager.instance.primaryFocus?.unfocus();
//                   BlocProvider.of<BottomNavBarCubit>(context).emitShow();
//                 },
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//               TextFormField(
//                 controller: commodityWeight_controller,
//                 onTap: () {
//                   BlocProvider.of<BottomNavBarCubit>(context).emitHide();
//                   commodityWeight_controller.selection = TextSelection(
//                       baseOffset: 0,
//                       extentOffset:
//                           commodityWeight_controller.value.text.length);
//                 },
//                 // focusNode: _nodeWeight,
//                 // enabled: !valueEnabled,
//                 scrollPadding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom + 50),
//                 textInputAction: TextInputAction.done,
//                 // keyboardType:
//                 //     const TextInputType.numberWithOptions(
//                 //         decimal: true, signed: true),
//                 // inputFormatters: [
//                 //   DecimalFormatter(),
//                 // ],
//                 style: const TextStyle(fontSize: 18),
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!
//                       .translate('commodity_weight'),
//                   contentPadding: const EdgeInsets.symmetric(
//                       vertical: 11.0, horizontal: 9.0),
//                 ),
//                 onTapOutside: (event) {},
//                 onEditingComplete: () {
//                   // evaluatePrice();
//                 },
//                 onChanged: (value) {},
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return AppLocalizations.of(context)!
//                         .translate('insert_value_validate');
//                   }
//                   return null;
//                 },
//                 onSaved: (newValue) {
//                   commodityWeight_controller.text = newValue!;
//                 },
//                 onFieldSubmitted: (value) {
//                   FocusManager.instance.primaryFocus?.unfocus();
//                   BlocProvider.of<BottomNavBarCubit>(context).emitShow();
//                 },
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//               TextFormField(
//                 controller: commodityQuantity_controller,
//                 onTap: () {
//                   BlocProvider.of<BottomNavBarCubit>(context).emitHide();
//                   commodityQuantity_controller.selection = TextSelection(
//                       baseOffset: 0,
//                       extentOffset:
//                           commodityQuantity_controller.value.text.length);
//                 },
//                 // focusNode: _nodeWeight,
//                 // enabled: !valueEnabled,
//                 scrollPadding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom + 50),
//                 textInputAction: TextInputAction.done,
//                 // keyboardType:
//                 //     const TextInputType.numberWithOptions(
//                 //         decimal: true, signed: true),
//                 // inputFormatters: [
//                 //   DecimalFormatter(),
//                 // ],
//                 style: const TextStyle(fontSize: 18),
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!
//                       .translate('commodity_quantity'),
//                   contentPadding: const EdgeInsets.symmetric(
//                       vertical: 11.0, horizontal: 9.0),
//                 ),
//                 onTapOutside: (event) {},
//                 onEditingComplete: () {
//                   // evaluatePrice();
//                 },
//                 onChanged: (value) {},
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return AppLocalizations.of(context)!
//                         .translate('insert_value_validate');
//                   }
//                   return null;
//                 },
//                 onSaved: (newValue) {
//                   commodityQuantity_controller.text = newValue!;
//                 },
//                 onFieldSubmitted: (value) {
//                   FocusManager.instance.primaryFocus?.unfocus();
//                   BlocProvider.of<BottomNavBarCubit>(context).emitShow();
//                 },
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//               BlocBuilder<PackageTypeBloc, PackageTypeState>(
//                 builder: (context, state2) {
//                   if (state2 is PackageTypeLoadedSuccess) {
//                     return StatefulBuilder(builder: (context, setState2) {
//                       return DropdownButtonHideUnderline(
//                         child: DropdownButton2<PackageType>(
//                           isExpanded: true,
//                           hint: Text(
//                             AppLocalizations.of(context)!
//                                 .translate('package_type'),
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Theme.of(context).hintColor,
//                             ),
//                           ),
//                           items: state2.packageTypes
//                               .map((PackageType item) =>
//                                   DropdownMenuItem<PackageType>(
//                                     value: item,
//                                     child: SizedBox(
//                                       width: 200,
//                                       child: Text(
//                                         item.name!,
//                                         style: const TextStyle(
//                                           fontSize: 17,
//                                         ),
//                                       ),
//                                     ),
//                                   ))
//                               .toList(),
//                           value: commodityPackageTypes[_count - 1],
//                           onChanged: (PackageType? value) {
//                             print(_count - 1);
//                             setState2(() {
//                               commodityPackageTypes[_count - 1] = value!;
//                             });
//                             print(commodityPackageTypes[_count - 1]!.name);
//                           },
//                           buttonStyleData: ButtonStyleData(
//                             height: 50,
//                             width: double.infinity,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 9.0,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: Colors.black26,
//                               ),
//                               color: Colors.white,
//                             ),
//                             // elevation: 2,
//                           ),
//                           iconStyleData: IconStyleData(
//                             icon: const Icon(
//                               Icons.keyboard_arrow_down_sharp,
//                             ),
//                             iconSize: 20,
//                             iconEnabledColor: AppColor.deepYellow,
//                             iconDisabledColor: Colors.grey,
//                           ),
//                           dropdownStyleData: DropdownStyleData(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(14),
//                               color: Colors.white,
//                             ),
//                             scrollbarTheme: ScrollbarThemeData(
//                               radius: const Radius.circular(40),
//                               thickness: MaterialStateProperty.all(6),
//                               thumbVisibility: MaterialStateProperty.all(true),
//                             ),
//                           ),
//                           menuItemStyleData: const MenuItemStyleData(
//                             height: 40,
//                           ),
//                         ),
//                       );
//                     });
//                   } else if (state2 is PackageTypeLoadingProgress) {
//                     return const Center(
//                       child: LinearProgressIndicator(),
//                     );
//                   } else if (state2 is PackageTypeLoadedFailed) {
//                     return Center(
//                       child: GestureDetector(
//                         onTap: () {
//                           BlocProvider.of<PackageTypeBloc>(context)
//                               .add(PackageTypeLoadEvent());
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               AppLocalizations.of(context)!
//                                   .translate('list_error'),
//                               style: const TextStyle(color: Colors.red),
//                             ),
//                             const Icon(
//                               Icons.refresh,
//                               color: Colors.grey,
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   } else {
//                     return Container();
//                   }
//                 },
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//             ],
//           ),
//         ),
//       );
//     setState(() => ++_count);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LocaleCubit, LocaleState>(
//       builder: (context, localeState) {
//         return Directionality(
//           textDirection: localeState.value.languageCode == 'en'
//               ? TextDirection.ltr
//               : TextDirection.rtl,
//           child: Scaffold(
//             backgroundColor: AppColor.lightGrey200,
//             body: SingleChildScrollView(
//               child: Consumer<AddShippmentProvider>(
//                   builder: (context, shippmentProvider, child) {
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Card(
//                       color: Colors.white,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 15.0, vertical: 7.5),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               AppLocalizations.of(context)!
//                                   .translate('shippment_load'),
//                               style: TextStyle(
//                                 // color: AppColor.lightBlue,
//                                 fontSize: 19.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 12,
//                             ),
//                             Form(
//                               key: _addShipmentformKey,
//                               child: ListView(
//                                 shrinkWrap: true,
//                                 children: _children,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: _add,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Icon(
//                                   Icons.add_circle_outline,
//                                   color: AppColor.deepYellow,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Card(
//                       color: Colors.white,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 1.0, vertical: 7.5),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               AppLocalizations.of(context)!
//                                   .translate('select_truck_type'),
//                               style: TextStyle(
//                                 // color: AppColor.lightBlue,
//                                 fontSize: 19.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 5.h,
//                             ),
//                             SizedBox(
//                               height: 185.h,
//                               child: BlocBuilder<TruckTypeBloc, TruckTypeState>(
//                                 builder: (context, state) {
//                                   if (state is TruckTypeLoadedSuccess) {
//                                     truckTypes = [];
//                                     truckTypes = state.truckTypes;
//                                     for (var element in truckTypes) {
//                                       trucknum.add(0);
//                                       truckNumControllers
//                                           .add(TextEditingController());
//                                     }
//                                     return Scrollbar(
//                                       controller: _scrollController,
//                                       thumbVisibility: true,
//                                       thickness: 2.0,
//                                       child: Padding(
//                                         padding: EdgeInsets.all(2.h),
//                                         child: ListView.builder(
//                                           controller: _scrollController,
//                                           itemCount: state.truckTypes.length,
//                                           scrollDirection: Axis.horizontal,
//                                           shrinkWrap: true,
//                                           itemBuilder: (context, index) {
//                                             return Padding(
//                                               padding: EdgeInsets.symmetric(
//                                                   horizontal: 5.w,
//                                                   vertical: 15.h),
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     truckNumControllers[
//                                                             previousIndex]
//                                                         .text = "";
//                                                     trucknum[previousIndex] = 0;
//                                                     truckNumControllers[index]
//                                                         .text = "1";
//                                                     trucknum[index] = 1;
//                                                     truckType = state
//                                                         .truckTypes[index].id!;
//                                                     previousIndex = index;
//                                                   });
//                                                   // setSelectedPanel(3);
//                                                   // orderBrokerProvider
//                                                   //     .setPackageError(
//                                                   //         false);
//                                                   // orderBrokerProvider
//                                                   //     .setpackageTypeId(
//                                                   //         state
//                                                   //             .packageTypes[
//                                                   //                 index]
//                                                   //             .id!);
//                                                 },
//                                                 child: Stack(
//                                                   clipBehavior: Clip.none,
//                                                   children: [
//                                                     Container(
//                                                       width: 175.w,
//                                                       decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(7),
//                                                         border: Border.all(
//                                                           color: truckType ==
//                                                                   state
//                                                                       .truckTypes[
//                                                                           index]
//                                                                       .id!
//                                                               ? AppColor
//                                                                   .deepYellow
//                                                               : AppColor
//                                                                   .deepBlack,
//                                                           width: 2.w,
//                                                         ),
//                                                       ),
//                                                       child: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           Image.network(
//                                                             state
//                                                                 .truckTypes[
//                                                                     index]
//                                                                 .image!,
//                                                             height: 50.h,
//                                                             errorBuilder:
//                                                                 (context, error,
//                                                                     stackTrace) {
//                                                               return Container(
//                                                                 height: 50.h,
//                                                                 width: 175.w,
//                                                                 color: Colors
//                                                                     .grey[300],
//                                                                 child:
//                                                                     const Center(
//                                                                   child: Text(
//                                                                       "error on loading "),
//                                                                 ),
//                                                               );
//                                                             },
//                                                             loadingBuilder:
//                                                                 (context, child,
//                                                                     loadingProgress) {
//                                                               if (loadingProgress ==
//                                                                   null) {
//                                                                 return child;
//                                                               }

//                                                               return SizedBox(
//                                                                 height: 50.h,
//                                                                 child: Center(
//                                                                   child:
//                                                                       CircularProgressIndicator(
//                                                                     value: loadingProgress.expectedTotalBytes !=
//                                                                             null
//                                                                         ? loadingProgress.cumulativeBytesLoaded /
//                                                                             loadingProgress.expectedTotalBytes!
//                                                                         : null,
//                                                                   ),
//                                                                 ),
//                                                               );
//                                                             },
//                                                             // placeholder:
//                                                             //     Container(
//                                                             //   color: Colors
//                                                             //       .white,
//                                                             //   height:
//                                                             //       50.h,
//                                                             //   width: 50.h,
//                                                             // ),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 7.h,
//                                                           ),
//                                                           Text(
//                                                             state
//                                                                 .truckTypes[
//                                                                     index]
//                                                                 .name!,
//                                                             style: TextStyle(
//                                                               fontSize: 17.sp,
//                                                               color: AppColor
//                                                                   .deepBlack,
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 7.h,
//                                                           ),
//                                                           Padding(
//                                                             padding: EdgeInsets
//                                                                 .symmetric(
//                                                                     horizontal:
//                                                                         5.w),
//                                                             child: Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .spaceBetween,
//                                                               children: [
//                                                                 GestureDetector(
//                                                                   onTap: () {
//                                                                     if (truckType ==
//                                                                         state
//                                                                             .truckTypes[index]
//                                                                             .id!) {
//                                                                       setState(
//                                                                           () {
//                                                                         trucknum[
//                                                                             index]++;
//                                                                         truckNumControllers[index]
//                                                                             .text = trucknum[
//                                                                                 index]
//                                                                             .toString();
//                                                                       });
//                                                                     }
//                                                                   },
//                                                                   child:
//                                                                       Container(
//                                                                     padding:
//                                                                         const EdgeInsets
//                                                                             .all(
//                                                                             3),
//                                                                     decoration:
//                                                                         BoxDecoration(
//                                                                       border:
//                                                                           Border
//                                                                               .all(
//                                                                         color: Colors
//                                                                             .grey[600]!,
//                                                                         width:
//                                                                             1,
//                                                                       ),
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               45),
//                                                                     ),
//                                                                     child: Icon(
//                                                                         Icons
//                                                                             .add,
//                                                                         size: 25
//                                                                             .w,
//                                                                         color: Colors
//                                                                             .blue[200]!),
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(
//                                                                   width: 50.w,
//                                                                   height: 55.h,
//                                                                   child:
//                                                                       TextField(
//                                                                     controller:
//                                                                         truckNumControllers[
//                                                                             index],
//                                                                     // focusNode:
//                                                                     //     _nodeTabaleh,
//                                                                     enabled:
//                                                                         false,
//                                                                     textAlign:
//                                                                         TextAlign
//                                                                             .center,
//                                                                     style: const TextStyle(
//                                                                         fontSize:
//                                                                             18),
//                                                                     textInputAction:
//                                                                         TextInputAction
//                                                                             .done,
//                                                                     keyboardType: const TextInputType
//                                                                         .numberWithOptions(
//                                                                         decimal:
//                                                                             true,
//                                                                         signed:
//                                                                             true),
//                                                                     inputFormatters: [
//                                                                       DecimalFormatter(),
//                                                                     ],
//                                                                     decoration:
//                                                                         InputDecoration(
//                                                                       labelText:
//                                                                           "",
//                                                                       alignLabelWithHint:
//                                                                           true,
//                                                                     ),
//                                                                     scrollPadding:
//                                                                         EdgeInsets
//                                                                             .only(
//                                                                       bottom: MediaQuery.of(context)
//                                                                               .viewInsets
//                                                                               .bottom +
//                                                                           50,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 // Text(
//                                                                 //   tabalehNum.toString(),
//                                                                 //   style: const TextStyle(fontSize: 30),
//                                                                 // ),
//                                                                 GestureDetector(
//                                                                   onTap: () {
//                                                                     if (truckType ==
//                                                                         state
//                                                                             .truckTypes[index]
//                                                                             .id!) {
//                                                                       setState(
//                                                                           () {
//                                                                         if (trucknum[index] >
//                                                                             0) {
//                                                                           trucknum[
//                                                                               index]--;
//                                                                           truckNumControllers[index].text =
//                                                                               trucknum[index].toString();
//                                                                         }
//                                                                       });
//                                                                     }
//                                                                   },
//                                                                   child:
//                                                                       Container(
//                                                                     padding:
//                                                                         const EdgeInsets
//                                                                             .all(
//                                                                             3),
//                                                                     decoration:
//                                                                         BoxDecoration(
//                                                                       border:
//                                                                           Border
//                                                                               .all(
//                                                                         color: Colors
//                                                                             .grey[600]!,
//                                                                         width:
//                                                                             1,
//                                                                       ),
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               45),
//                                                                     ),
//                                                                     child: trucknum[index] >
//                                                                             1
//                                                                         ? Icon(
//                                                                             Icons.remove,
//                                                                             size:
//                                                                                 25.w,
//                                                                             color:
//                                                                                 Colors.blue[200]!,
//                                                                           )
//                                                                         : Icon(
//                                                                             Icons.remove,
//                                                                             size:
//                                                                                 25.w,
//                                                                             color:
//                                                                                 Colors.grey[600]!,
//                                                                           ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     truckType ==
//                                                             state
//                                                                 .truckTypes[
//                                                                     index]
//                                                                 .id!
//                                                         ? Positioned(
//                                                             right: -7.w,
//                                                             top: -10.h,
//                                                             child: Container(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .all(2),
//                                                               decoration:
//                                                                   BoxDecoration(
//                                                                 color: AppColor
//                                                                     .deepYellow,
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             45),
//                                                               ),
//                                                               child: Icon(
//                                                                   Icons.check,
//                                                                   size: 16.w,
//                                                                   color: Colors
//                                                                       .white),
//                                                             ),
//                                                           )
//                                                         : const SizedBox
//                                                             .shrink()
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     return Shimmer.fromColors(
//                                       baseColor: (Colors.grey[300])!,
//                                       highlightColor: (Colors.grey[100])!,
//                                       enabled: true,
//                                       direction: ShimmerDirection.rtl,
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemBuilder: (_, __) => Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 5.w, vertical: 15.h),
//                                           child: Container(
//                                             clipBehavior: Clip.antiAlias,
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             child: SizedBox(
//                                               width: 175.w,
//                                               height: 70.h,
//                                             ),
//                                           ),
//                                         ),
//                                         itemCount: 6,
//                                       ),
//                                     );
//                                   }
//                                 },
//                               ),
//                             ),
//                             Visibility(
//                               visible: false,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(
//                                     height: 4.h,
//                                   ),
//                                   // Text(
//                                   //   AppLocalizations.of(context)!
//                                   //       .translate(
//                                   //           'select_package_type_error'),
//                                   //   style: TextStyle(
//                                   //     color: Colors.red,
//                                   //   ),
//                                   // ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 7.h,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Card(
//                       color: Colors.white,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10.0, vertical: 7.5),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               AppLocalizations.of(context)!
//                                   .translate('choose_shippment_path'),
//                               style: TextStyle(
//                                 // color: AppColor.lightBlue,
//                                 fontSize: 19.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         ChooseShippmentPathScreen(),
//                                   ),
//                                 );
//                               },
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     color: AppColor.deepYellow,
//                                   ),
//                                   SizedBox(
//                                     width: 7.w,
//                                   ),
//                                   Text(
//                                     AppLocalizations.of(context)!
//                                         .translate('choose_shippment_path'),
//                                     style: TextStyle(
//                                       // color: AppColor.lightBlue,
//                                       fontSize: 18.sp,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 7.w,
//                                   ),
//                                   Icon(
//                                     localeState.value.languageCode == 'en'
//                                         ? Icons.arrow_forward_ios
//                                         : Icons.arrow_back_ios,
//                                     color: AppColor.deepYellow,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             SizedBox(
//                               height: 250.h,
//                               child: GoogleMap(
//                                 onMapCreated: _onMapCreated,
//                                 initialCameraPosition: CameraPosition(
//                                   target: _center,
//                                   zoom: 11.0,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
