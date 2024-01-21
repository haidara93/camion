import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/shipments/shipment_list_bloc.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/providers/active_shipment_provider.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/views/screens/merchant/active_shipment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:timelines/timelines.dart';

class ActiveShipmentScreen extends StatefulWidget {
  ActiveShipmentScreen({Key? key}) : super(key: key);

  @override
  State<ActiveShipmentScreen> createState() => _ActiveShipmentScreenState();
}

class _ActiveShipmentScreenState extends State<ActiveShipmentScreen> {
  List<GoogleMapController> _maps = [];
  bool _loading = true;
  String _mapStyle = "";

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/style/map_style.json').then((string) {
      _mapStyle = string;
    });
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
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<ActiveShippmentProvider>(
                          builder: (context, activeShipmentProvider, child) {
                        activeShipmentProvider.init();
                        return BlocConsumer<ShipmentListBloc,
                            ShipmentListState>(
                          listener: (context, state) {
                            if (state is ShipmentListLoadedSuccess) {
                              // for (var element in state.shipments) {
                              //   _maps.add(value)
                              // }
                              activeShipmentProvider
                                  .getpolylineCoordinates(state.shipments);
                            }
                          },
                          builder: (context, state) {
                            if (state is ShipmentListLoadedSuccess) {
                              return state.shipments.isEmpty
                                  ? Center(
                                      child: Text(AppLocalizations.of(context)!
                                          .translate('no_shipments')),
                                    )
                                  : ListView.builder(
                                      itemCount: state.shipments.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.h),
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ActiveShipmentDetailsScreen(
                                                            user_id:
                                                                'driver${state.shipments[index].driver!.id!}',
                                                            shipment:
                                                                state.shipments[
                                                                    index],
                                                            index: index,
                                                          ),
                                                        ));
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
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              45),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          3),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          1),
                                                                  decoration: BoxDecoration(
                                                                      color: AppColor
                                                                          .deepYellow,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              45)),
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius:
                                                                        30.h,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "as",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              28.sp,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                "commodity name: ${state.shipments[index].shipmentItems![0].commodityName!}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      19.sp,
                                                                ),
                                                              ),
                                                              Text(
                                                                "#${state.shipments[index].id!}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      19.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                            height: 200.h,
                                                            child:
                                                                AbsorbPointer(
                                                              absorbing: true,
                                                              child: GoogleMap(
                                                                onMapCreated:
                                                                    (controller) {
                                                                  activeShipmentProvider
                                                                      .onMapCreated(
                                                                          controller,
                                                                          _mapStyle,
                                                                          index);
                                                                  // _maps.add(
                                                                  //     controller);
                                                                  // _maps[index]
                                                                  //     .setMapStyle(
                                                                  //         _mapStyle);
                                                                },
                                                                zoomControlsEnabled:
                                                                    false,
                                                                initialCameraPosition:
                                                                    const CameraPosition(
                                                                  target: LatLng(
                                                                      35.363149,
                                                                      35.932120),
                                                                  zoom: 13,
                                                                ),
                                                                markers: {
                                                                  Marker(
                                                                    markerId:
                                                                        const MarkerId(
                                                                            "pickup"),
                                                                    position: LatLng(
                                                                        state
                                                                            .shipments[
                                                                                index]
                                                                            .pickupCityLat!,
                                                                        state
                                                                            .shipments[index]
                                                                            .pickupCityLang!),
                                                                  ),
                                                                  Marker(
                                                                    markerId:
                                                                        const MarkerId(
                                                                            "delivery"),
                                                                    position: LatLng(
                                                                        state
                                                                            .shipments[
                                                                                index]
                                                                            .deliveryCityLat!,
                                                                        state
                                                                            .shipments[index]
                                                                            .deliveryCityLang!),
                                                                  ),
                                                                },
                                                                polylines: {
                                                                  Polyline(
                                                                    polylineId:
                                                                        const PolylineId(
                                                                            "route"),
                                                                    points: activeShipmentProvider.polylineCoordinates.length >
                                                                            index
                                                                        ? activeShipmentProvider
                                                                            .polylineCoordinates[index]
                                                                        : [],
                                                                    color: AppColor
                                                                        .deepYellow,
                                                                    width: 5,
                                                                  ),
                                                                },
                                                                mapType: MapType
                                                                    .normal,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 70.h,
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
                                                                      .3,
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
                                                                      .3,
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
                                                        // Row(
                                                        //   children: [
                                                        //     SizedBox(
                                                        //       height: 40,
                                                        //       width: MediaQuery.of(
                                                        //                   context)
                                                        //               .size
                                                        //               .width *
                                                        //           .4,
                                                        //       child:
                                                        //           TimelineTile(
                                                        //         isLast: false,
                                                        //         isFirst: true,
                                                        //         beforeLineStyle:
                                                        //             LineStyle(
                                                        //           color: AppColor
                                                        //               .deepYellow,
                                                        //         ),
                                                        //         indicatorStyle: IndicatorStyle(
                                                        //             color: AppColor
                                                        //                 .deepYellow,
                                                        //             iconStyle: IconStyle(
                                                        //                 iconData:
                                                        //                     Icons
                                                        //                         .done,
                                                        //                 color: Colors
                                                        //                     .white,
                                                        //                 fontSize:
                                                        //                     15)),
                                                        //         axis: TimelineAxis
                                                        //             .horizontal,
                                                        //         endChild: Text(state
                                                        //             .shipments[
                                                        //                 index]
                                                        //             .pickupCityLocation!),
                                                        //       ),
                                                        //     ),
                                                        //     SizedBox(
                                                        //       height: 40,
                                                        //       width: MediaQuery.of(
                                                        //                   context)
                                                        //               .size
                                                        //               .width *
                                                        //           .4,
                                                        //       child:
                                                        //           TimelineTile(
                                                        //         isLast: true,
                                                        //         isFirst: false,
                                                        //         beforeLineStyle:
                                                        //             LineStyle(
                                                        //           color: AppColor
                                                        //               .deepYellow,
                                                        //         ),
                                                        //         indicatorStyle:
                                                        //             IndicatorStyle(
                                                        //           color: AppColor
                                                        //               .deepYellow,
                                                        //           iconStyle: IconStyle(
                                                        //               iconData:
                                                        //                   Icons
                                                        //                       .done,
                                                        //               color: Colors
                                                        //                   .white,
                                                        //               fontSize:
                                                        //                   15),
                                                        //         ),
                                                        //         axis: TimelineAxis
                                                        //             .horizontal,
                                                        //         endChild: Text(state
                                                        //             .shipments[
                                                        //                 index]
                                                        //             .deliveryCityLocation!),
                                                        //       ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 30.h,
                                          width: 100.w,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  List<LatLng> getpolylineCoordinates(double d, double e, double f, double g) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> _polylineCoordinates = [];

    polylinePoints
        .getRouteBetweenCoordinates(
      "AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w",
      PointLatLng(d, e),
      PointLatLng(f, g),
    )
        .then((result) {
      if (result.points.isNotEmpty) {
        result.points.forEach((element) {
          _polylineCoordinates.add(
            LatLng(
              element.latitude,
              element.longitude,
            ),
          );
        });
      }
    });
    return _polylineCoordinates;
  }
}