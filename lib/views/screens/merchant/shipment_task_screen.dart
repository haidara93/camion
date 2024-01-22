import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/shipments/shipment_list_bloc.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/views/screens/merchant/shipment_instruction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class ShipmentTaskScreen extends StatefulWidget {
  ShipmentTaskScreen({Key? key}) : super(key: key);

  @override
  State<ShipmentTaskScreen> createState() => _ShipmentTaskScreenState();
}

class _ShipmentTaskScreenState extends State<ShipmentTaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  String getOfferStatus(String offer) {
    switch (offer) {
      case "P":
        return "معلقة";
      case "R":
        return "جارية";
      case "C":
        return "مكتملة";
      case "F":
        return "مرفوضة";
      default:
        return "خطأ";
    }
  }

  String diffText(Duration diff) {
    if (diff.inSeconds < 60) {
      return "منذ ${diff.inSeconds.toString()} ثانية";
    } else if (diff.inMinutes < 60) {
      return "منذ ${diff.inMinutes.toString()} دقيقة";
    } else if (diff.inHours < 24) {
      return "منذ ${diff.inHours.toString()} ساعة";
    } else {
      return "منذ ${diff.inDays.toString()} يوم";
    }
  }

  String diffEnText(Duration diff) {
    if (diff.inSeconds < 60) {
      return "since ${diff.inSeconds.toString()} seconds";
    } else if (diff.inMinutes < 60) {
      return "since ${diff.inMinutes.toString()} minutes";
    } else if (diff.inHours < 24) {
      return "since ${diff.inHours.toString()} hours";
    } else {
      return "since ${diff.inDays.toString()} days";
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                    child: TabBar(
                      controller: _tabController,
                      // give the indicator a decoration (color and border radius)

                      // indicator: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(
                      //     25.0,
                      //   ),

                      //   // color: AppColor.activeGreen,
                      // ),

                      // labelColor: AppColor.deepBlack,
                      // unselectedLabelColor: Colors.black,
                      // splashBorderRadius: BorderRadius.circular(25),
                      onTap: (value) {
                        switch (value) {
                          case 0:
                            BlocProvider.of<ShipmentListBloc>(context)
                                .add(ShipmentListLoadEvent("P"));
                            break;
                          case 1:
                            BlocProvider.of<ShipmentListBloc>(context)
                                .add(ShipmentListLoadEvent("C"));
                            break;
                          // case 2:
                          //   BlocProvider.of<ShipmentListBloc>(context)
                          //       .add(ShipmentListLoadEvent("C"));
                          //   break;
                          default:
                        }
                        setState(() {
                          tabIndex = value;
                        });
                      },
                      tabs: [
                        // first tab [you can add an icon using the icon property]
                        Tab(
                          child: Container(
                            // decoration: BoxDecoration(
                            //     color: tabIndex == 0
                            //         ? AppColor.goldenYellow
                            //         : null,
                            //     borderRadius: BorderRadius.circular(
                            //       25.0,
                            //     ),
                            //     border: tabIndex != 0
                            //         ? Border.all(
                            //             color: AppColor.goldenYellow,
                            //             width: 2,
                            //           )
                            //         : null
                            //     // color: AppColor.activeGreen,
                            //     ),
                            child: Center(
                                child: Text(AppLocalizations.of(context)!
                                    .translate('pending'))),
                          ),
                        ),

                        // second tab [you can add an icon using the icon property]
                        // Tab(
                        //   child: Container(
                        //     child: Center(
                        //         child: Text(AppLocalizations.of(context)!
                        //             .translate('running'))),
                        //   ),
                        // ),
                        Tab(
                          child: Container(
                            child: Center(
                                child: Text(AppLocalizations.of(context)!
                                    .translate('completed'))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<ShipmentListBloc, ShipmentListState>(
                      builder: (context, state) {
                        if (state is ShipmentListLoadedSuccess) {
                          return state.shipments.isEmpty
                              ? Center(
                                  child: Text(AppLocalizations.of(context)!
                                      .translate('no_shipments')),
                                )
                              : ListView.builder(
                                  itemCount: state.shipments.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    // DateTime now = DateTime.now();
                                    // Duration diff = now
                                    //     .difference(state.offers[index].createdDate!);
                                    return Card(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5.h),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShipmentInstructionScreen(
                                                              shipment: state
                                                                      .shipments[
                                                                  index]),
                                                    ));
                                              },
                                              leading: Container(
                                                height: 75.h,
                                                width: 75.w,
                                                decoration: BoxDecoration(
                                                    // color: AppColor.lightGoldenYellow,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/icons/naval_shipping.svg",
                                                    height: 55.h,
                                                    width: 55.w,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${AppLocalizations.of(context)!.translate('shipment_number')}: SA-${state.shipments[index].id!}',
                                                        style: TextStyle(
                                                            // color: AppColor.lightBlue,
                                                            fontSize: 18.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 7.h,
                                                      ),
                                                      Text(
                                                        '${AppLocalizations.of(context)!.translate('commodity_type')}: ${state.shipments[index].shipmentItems![0].commodityName!}',
                                                        style: TextStyle(
                                                          // color: AppColor.lightBlue,
                                                          fontSize: 17.sp,
                                                        ),
                                                      ),
                                                      Text.rich(
                                                        TextSpan(
                                                            text: state
                                                                .shipments[
                                                                    index]
                                                                .pickupCityLocation,
                                                            style: TextStyle(
                                                              color: AppColor
                                                                  .deepBlack,
                                                              fontSize: 17.sp,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "  --->  ",
                                                                style:
                                                                    TextStyle(
                                                                  color: AppColor
                                                                      .deepYellow,
                                                                  fontSize:
                                                                      17.sp,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${state.shipments[index].deliveryCityLocation}",
                                                                style:
                                                                    TextStyle(
                                                                  color: AppColor
                                                                      .deepBlack,
                                                                  fontSize:
                                                                      17.sp,
                                                                ),
                                                              ),
                                                            ]),
                                                      ),
                                                      // // Text(
                                                      //     'نوع البضاعة: ${state.offers[index].product!.label!}'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              dense: false,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    // BlocProvider.of<
                                                    //             OfferDetailsBloc>(
                                                    //         context)
                                                    //     .add(
                                                    //         OfferDetailsLoadEvent(
                                                    //             state
                                                    //                 .offers[
                                                    //                     index]
                                                    //                 .id!));
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //       builder: (context) =>
                                                    //           OrderTrackingScreen(
                                                    //               type:
                                                    //                   "trader",
                                                    //               offer: state
                                                    //                       .offers[
                                                    //                   index]),
                                                    //     ));
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 3.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        // Text(
                                                        //   AppLocalizations.of(
                                                        //           context)!
                                                        //       .translate(
                                                        //           'operation_tracking'),
                                                        //   style: TextStyle(
                                                        //     color: AppColor
                                                        //         .lightBlue,
                                                        //     fontWeight:
                                                        //         FontWeight.bold,
                                                        //     fontSize: 17.sp,
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                        } else {
                          return Shimmer.fromColors(
                            baseColor: (Colors.grey[300])!,
                            highlightColor: (Colors.grey[100])!,
                            enabled: true,
                            direction: ShimmerDirection.ttb,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (_, __) => Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 30.h,
                                      width: 100.w,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      height: 30.h,
                                      width: 150.w,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      height: 30.h,
                                      width: 150.w,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              itemCount: 6,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
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
