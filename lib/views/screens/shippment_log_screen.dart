import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/shipments/shipment_list_bloc.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart' as intel;

class ShippmentLogScreen extends StatefulWidget {
  ShippmentLogScreen({Key? key}) : super(key: key);

  @override
  State<ShippmentLogScreen> createState() => _ShippmentLogScreenState();
}

class _ShippmentLogScreenState extends State<ShippmentLogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;

  var f = intel.NumberFormat("#,###", "en_US");

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

  String setLoadDate(DateTime date) {
    List months = [
      'jan',
      'feb',
      'mar',
      'april',
      'may',
      'jun',
      'july',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec'
    ];
    var mon = date.month;
    var month = months[mon - 1];

    var result = '${date.day}-$month-${date.year}';
    return result;
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
                          default:
                        }
                        setState(() {
                          tabIndex = value;
                        });
                      },
                      tabs: [
                        // first tab [you can add an icon using the icon property]
                        Tab(
                          child: Center(
                              child: Text(AppLocalizations.of(context)!
                                  .translate('pending'))),
                        ),

                        Tab(
                          child: Center(
                              child: Text(AppLocalizations.of(context)!
                                  .translate('completed'))),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 11),
                                              child: Text(
                                                '${AppLocalizations.of(context)!.translate('shipment_number')}: SA-${state.shipments[index].id!}',
                                                style: TextStyle(
                                                    // color: AppColor.lightBlue,
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              onTap: () async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
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
                                                    "assets/icons/commodity_icon.svg",
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
                                                      SizedBox(
                                                        height: (state
                                                                        .shipments[
                                                                            index]
                                                                        .pickupCityLocation!
                                                                        .length >
                                                                    11 ||
                                                                state
                                                                        .shipments[
                                                                            index]
                                                                        .deliveryCityLocation!
                                                                        .length >
                                                                    11)
                                                            ? 100
                                                            : 70.h,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            TimelineTile(
                                                              direction: Axis
                                                                  .horizontal,
                                                              oppositeContents:
                                                                  Text(
                                                                setLoadDate(state
                                                                    .shipments[
                                                                        index]
                                                                    .pickupDate!),
                                                              ),
                                                              contents:
                                                                  SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .18,
                                                                child: Text(
                                                                  state
                                                                      .shipments[
                                                                          index]
                                                                      .pickupCityLocation!,
                                                                  maxLines: 2,
                                                                ),
                                                              ),
                                                              node: SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .18,
                                                                child:
                                                                    TimelineNode(
                                                                  indicator: DotIndicator(
                                                                      color: AppColor
                                                                          .deepYellow),
                                                                  // startConnector: SolidLineConnector(),
                                                                  endConnector:
                                                                      DashedLineConnector(
                                                                          color:
                                                                              AppColor.deepYellow),
                                                                ),
                                                              ),
                                                            ),
                                                            TimelineTile(
                                                              direction: Axis
                                                                  .horizontal,
                                                              oppositeContents:
                                                                  const SizedBox
                                                                      .shrink(),
                                                              contents:
                                                                  const SizedBox
                                                                      .shrink(),
                                                              node: SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .18,
                                                                child: DashedLineConnector(
                                                                    color: AppColor
                                                                        .deepYellow),
                                                              ),
                                                            ),
                                                            TimelineTile(
                                                              direction: Axis
                                                                  .horizontal,
                                                              oppositeContents:
                                                                  Text(
                                                                setLoadDate(state
                                                                    .shipments[
                                                                        index]
                                                                    .pickupDate!),
                                                              ),
                                                              contents:
                                                                  SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .18,
                                                                child: Text(
                                                                  state
                                                                      .shipments[
                                                                          index]
                                                                      .deliveryCityLocation!,
                                                                  maxLines: 2,
                                                                ),
                                                              ),
                                                              node: SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .3,
                                                                child:
                                                                    TimelineNode(
                                                                  indicator: DotIndicator(
                                                                      color: AppColor
                                                                          .deepYellow),
                                                                  startConnector:
                                                                      DashedLineConnector(
                                                                          color:
                                                                              AppColor.deepYellow),
                                                                  // endConnector: SolidLineConnector(),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
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
                                                      SizedBox(
                                                        height: 7.h,
                                                      ),
                                                      Text(
                                                        '${AppLocalizations.of(context)!.translate('commodity_weight')}: ${f.format(state.shipments[index].shipmentItems![0].commodityWeight!)} kg',
                                                        style: TextStyle(
                                                          // color: AppColor.lightBlue,
                                                          fontSize: 17.sp,
                                                        ),
                                                      ),

                                                      // // Text(
                                                      //     'نوع البضاعة: ${state.offers[index].product!.label!}'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              dense: false,
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
