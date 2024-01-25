import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/shipments/active_shipment_list_bloc.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/views/screens/merchant/shipment_task_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timelines/timelines.dart';

class ShipmentTaskScreen extends StatefulWidget {
  ShipmentTaskScreen({Key? key}) : super(key: key);

  @override
  State<ShipmentTaskScreen> createState() => _ShipmentTaskScreenState();
}

class _ShipmentTaskScreenState extends State<ShipmentTaskScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 10.0,
                    ),
                    child: BlocBuilder<ActiveShipmentListBloc,
                        ActiveShipmentListState>(
                      builder: (context, state) {
                        if (state is ActiveShipmentListLoadedSuccess) {
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
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ShipmentTaskDetailsScreen(
                                                    shipment:
                                                        state.shipments[index]),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${AppLocalizations.of(context)!.translate('shipment_number')}: SA-${state.shipments[index].id!}',
                                                      style: TextStyle(
                                                          // color: AppColor.lightBlue,
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 7.h,
                                                    ),

                                                    SizedBox(
                                                      height: 70.h,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          TimelineTile(
                                                            direction:
                                                                Axis.horizontal,
                                                            oppositeContents:
                                                                Text(
                                                              '${state.shipments[index].pickupDate!.year.toString()}-${state.shipments[index].pickupDate!.month.toString()}-${state.shipments[index].pickupDate!.day.toString()}',
                                                            ),
                                                            contents: Text(
                                                              state
                                                                  .shipments[
                                                                      index]
                                                                  .pickupCityLocation!,
                                                            ),
                                                            node: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .25,
                                                              child:
                                                                  TimelineNode(
                                                                indicator: DotIndicator(
                                                                    color: AppColor
                                                                        .deepYellow),
                                                                // startConnector: SolidLineConnector(),
                                                                endConnector:
                                                                    DashedLineConnector(
                                                                        color: AppColor
                                                                            .deepYellow),
                                                              ),
                                                            ),
                                                          ),
                                                          TimelineTile(
                                                            direction:
                                                                Axis.horizontal,
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
                                                                  .25,
                                                              child: DashedLineConnector(
                                                                  color: AppColor
                                                                      .deepYellow),
                                                            ),
                                                          ),
                                                          TimelineTile(
                                                            direction:
                                                                Axis.horizontal,
                                                            oppositeContents:
                                                                Text(
                                                              '${state.shipments[index].pickupDate!.year.toString()}-${state.shipments[index].pickupDate!.month.toString()}-${state.shipments[index].pickupDate!.day.toString()}',
                                                            ),
                                                            contents: Text(
                                                              state
                                                                  .shipments[
                                                                      index]
                                                                  .deliveryCityLocation!,
                                                            ),
                                                            node: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .2,
                                                              child:
                                                                  TimelineNode(
                                                                indicator: DotIndicator(
                                                                    color: AppColor
                                                                        .deepYellow),
                                                                startConnector:
                                                                    DashedLineConnector(
                                                                        color: AppColor
                                                                            .deepYellow),
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
                                                      '${AppLocalizations.of(context)!.translate('commodity_weight')}: ${state.shipments[index].shipmentItems![0].commodityWeight!}',
                                                      style: TextStyle(
                                                        // color: AppColor.lightBlue,
                                                        fontSize: 17.sp,
                                                      ),
                                                    ),

                                                    // // Text(
                                                    //     'نوع البضاعة: ${state.offers[index].product!.label!}'),
                                                  ],
                                                ),
                                                Container(
                                                  height: 55.h,
                                                  width: 55.w,
                                                  decoration: BoxDecoration(
                                                      // color: AppColor.lightGoldenYellow,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Center(
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .notifications_none_outlined,
                                                          color: AppColor
                                                              .deepYellow,
                                                          size: 45,
                                                        ),
                                                        getunfinishedTasks(state
                                                                        .shipments[
                                                                    index]) >
                                                                0
                                                            ? Positioned(
                                                                child:
                                                                    Container(
                                                                  height: 25,
                                                                  width: 25,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            45),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                        getunfinishedTasks(state.shipments[index])
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox
                                                                .shrink(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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

  int getunfinishedTasks(Shipment shipment) {
    var count = 0;
    if (shipment.shipmentinstruction == null) {
      count++;
    }
    if (shipment.shipmentpayment == null) {
      count++;
    }
    return count;
  }
}
