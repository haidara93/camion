import 'package:camion/constants/enums.dart';
import 'package:camion/data/models/co2_report.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/data/providers/active_shipment_provider.dart';
import 'package:camion/data/services/co2_service.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/views/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class ActiveShipmentDetailsScreen extends StatefulWidget {
  final String user_id;
  final Shipment shipment;
  final int index;
  ActiveShipmentDetailsScreen(
      {Key? key,
      required this.user_id,
      required this.shipment,
      required this.index})
      : super(key: key);

  @override
  State<ActiveShipmentDetailsScreen> createState() =>
      _ActiveShipmentDetailsScreenState();
}

class _ActiveShipmentDetailsScreenState
    extends State<ActiveShipmentDetailsScreen> with TickerProviderStateMixin {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  String _mapStyle = "";
  PanelState panelState = PanelState.hidden;
  final panelTransation = const Duration(milliseconds: 500);
  Co2Report _report = Co2Report();

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
// _heartbeatAnimation = Tween(begin: 180.0, end: 160.0).animate(
//   CurvedAnimation(
//     curve: Curves.easeOutBack,
//     parent: _animationController,
//   ),
// );

  void calculateCo2Report() {
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

    leg.origin!.latitude = widget.shipment!.pickupCityLat;
    leg.origin!.longitude = widget.shipment!.pickupCityLang;
    leg.destination!.latitude = widget.shipment!.deliveryCityLat;
    leg.destination!.longitude = widget.shipment!.deliveryCityLang;

    detail.legs!.add(leg);

    for (var i = 0; i < widget.shipment!.shipmentItems!.length; i++) {
      Load load = Load();
      load.unitWeightKg =
          widget.shipment!.shipmentItems![i].commodityWeight!.toDouble();
      load.unitType = "pallets";
      detail.load!.add(load);
    }

    Co2Service.getCo2Calculate(
            detail,
            LatLng(widget.shipment!.pickupCityLat!,
                widget.shipment!.pickupCityLang!),
            LatLng(widget.shipment!.deliveryCityLat!,
                widget.shipment!.deliveryCityLang!))
        .then((value) {
      setState(() {
        _report = value!;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/style/map_style.json').then((string) {
      _mapStyle = string;
    });
    calculateCo2Report();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onVerticalGesture(DragUpdateDetails details) {
    if (details.primaryDelta! < -7 && panelState == PanelState.hidden) {
      changeToOpen();
    } else if (details.primaryDelta! > 7 && panelState == PanelState.open) {
      changeToHidden();
    }
  }

  void changeToOpen() {
    setState(() {
      panelState = PanelState.open;
    });
  }

  void changeToHidden() {
    setState(() {
      panelState = PanelState.hidden;
    });
  }

  double? _getTopForPanel(PanelState state, Size size) {
    if (state == PanelState.open) {
      return size.height - 90.h;
    } else if (state == PanelState.hidden) {
      return (size.height - 200.h);
    }
  }

  double? _getSizeForPanel(PanelState state, Size size) {
    if (state == PanelState.open) {
      return size.height;
    } else if (state == PanelState.hidden) {
      return (size.height * 0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "shipment details",
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('location').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print("snapshot.hasData");
            print(snapshot.hasData);

            print(snapshot);
            if (_added) {
              mymap(snapshot);
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            print(snapshot.data!.docs.singleWhere(
                (element) => element.id == widget.user_id)['latitude']);
            return Consumer<ActiveShippmentProvider>(
              builder: (context, shipmentProvider, child) {
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        GoogleMap(
                          mapType: MapType.normal,
                          zoomControlsEnabled: false,
                          markers: {
                            Marker(
                              position: LatLng(
                                snapshot.data!.docs.singleWhere((element) =>
                                    element.id == widget.user_id)['latitude'],
                                snapshot.data!.docs.singleWhere((element) =>
                                    element.id == widget.user_id)['longitude'],
                              ),
                              markerId: const MarkerId('id'),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueMagenta),
                            ),
                            Marker(
                              markerId: const MarkerId("pickup"),
                              position: LatLng(widget.shipment.pickupCityLat!,
                                  widget.shipment.pickupCityLang!),
                            ),
                            Marker(
                              markerId: const MarkerId("delivery"),
                              position: LatLng(widget.shipment.deliveryCityLat!,
                                  widget.shipment.deliveryCityLang!),
                            ),
                          },
                          initialCameraPosition: CameraPosition(
                              target: LatLng(
                                snapshot.data!.docs.singleWhere((element) =>
                                    element.id == widget.user_id)['latitude'],
                                snapshot.data!.docs.singleWhere((element) =>
                                    element.id == widget.user_id)['longitude'],
                              ),
                              zoom: 14.47),
                          onMapCreated: (GoogleMapController controller) async {
                            setState(() {
                              _controller = controller;
                              _controller.setMapStyle(_mapStyle);
                              _added = true;
                            });
                          },
                          polylines: {
                            Polyline(
                              polylineId: const PolylineId("route"),
                              points:
                                  shipmentProvider.polylineCoordinates.length >
                                          widget.index
                                      ? shipmentProvider
                                          .polylineCoordinates[widget.index]
                                      : [],
                              color: AppColor.deepYellow,
                              width: 7,
                            ),
                          },
                        ),
                        AnimatedPositioned(
                          duration: panelTransation,
                          curve: Curves.decelerate,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onVerticalDragUpdate: _onVerticalGesture,
                            child: AnimatedSwitcher(
                              duration: panelTransation,
                              child: _buildPanelOption(context),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPanelOption(BuildContext context) {
    if (panelState == PanelState.hidden) {
      return _buildPanelWidget(context);
    } else if (panelState == PanelState.open) {
      return _buildExpandedPanelWidget(context);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildExpandedPanelWidget(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 420.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColor.darkGrey,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(13),
              topRight: Radius.circular(13),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 50,
                      height: 50,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "truck type: ${widget.shipment.truckType!.name!}",
                          style: TextStyle(
                            fontSize: 19.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   "commodity name: ${widget.shipment.shipmentItems![0].commodityName!}",
                        //   style: TextStyle(
                        //     fontSize: 19.sp,
                        //   ),
                        // ),
                      ],
                    ),
                    Text(
                      "#${widget.shipment.id!}",
                      style: TextStyle(
                        fontSize: 19.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              SizedBox(
                height: 100.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TimelineTile(
                      direction: Axis.horizontal,
                      oppositeContents: Text(
                        '${widget.shipment.pickupDate!.year.toString()}-${widget.shipment.pickupDate!.month.toString()}-${widget.shipment.pickupDate!.day.toString()}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      contents: Text(
                        widget.shipment.pickupCityLocation!,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      node: SizedBox(
                        width: MediaQuery.of(context).size.width * .3,
                        child: TimelineNode(
                          indicator: DotIndicator(color: AppColor.deepYellow),
                          // startConnector: SolidLineConnector(),
                          endConnector:
                              DashedLineConnector(color: AppColor.deepYellow),
                        ),
                      ),
                    ),
                    TimelineTile(
                      direction: Axis.horizontal,
                      oppositeContents: const SizedBox.shrink(),
                      contents: const SizedBox.shrink(),
                      node: SizedBox(
                        width: MediaQuery.of(context).size.width * .35,
                        child: DashedLineConnector(color: AppColor.deepYellow),
                      ),
                    ),
                    TimelineTile(
                      direction: Axis.horizontal,
                      oppositeContents: Text(
                        '${widget.shipment.pickupDate!.year.toString()}-${widget.shipment.pickupDate!.month.toString()}-${widget.shipment.pickupDate!.day.toString()}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      contents: Text(
                        widget.shipment.deliveryCityLocation!,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      node: SizedBox(
                        width: MediaQuery.of(context).size.width * .3,
                        child: TimelineNode(
                          indicator: DotIndicator(color: AppColor.deepYellow),
                          startConnector:
                              DashedLineConnector(color: AppColor.deepYellow),
                          // endConnector: SolidLineConnector(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCommodityWidget(widget.shipment.shipmentItems),
                  SizedBox(
                    height: 180.h,
                    child: VerticalDivider(
                      color: Colors.grey[300],
                    ),
                  ),
                  _buildCo2Report(),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: -30,
          child: Column(
            children: [
              Card(
                color: AppColor.darkGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: AppColor.deepYellow,
                      borderRadius: BorderRadius.circular(45)),
                  child: CircleAvatar(
                    radius: 30.h,
                    backgroundColor: AppColor.darkGrey,
                    child: Center(
                      child: Text(
                        "AY",
                        style: TextStyle(
                          fontSize: 28.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "${widget.shipment.driver!.user!.firstName!} ${widget.shipment.driver!.user!.lastName!}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.deepYellow,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPanelWidget(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 90.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: AppColor.darkGrey,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              )),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 50,
                  height: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "truck type: ${widget.shipment.truckType!.name!}",
                      style: TextStyle(
                        fontSize: 19.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "commodity name: ${widget.shipment.shipmentItems![0].commodityName!}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  "#${widget.shipment.id!}",
                  style: TextStyle(
                    fontSize: 23.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: -30,
          child: Column(
            children: [
              Card(
                color: AppColor.darkGrey,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: AppColor.deepYellow,
                      borderRadius: BorderRadius.circular(45)),
                  child: CircleAvatar(
                    radius: 30.h,
                    backgroundColor: AppColor.darkGrey,
                    child: Center(
                      child: Text(
                        "AY",
                        style: TextStyle(
                          fontSize: 28.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "${widget.shipment.driver!.user!.firstName!} ${widget.shipment.driver!.user!.lastName!}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.deepYellow,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
            ),
            zoom: 14.47)));
  }

  final ScrollController _scrollController = ScrollController();

  _buildCommodityWidget(List<ShipmentItems>? shipmentItems) {
    return SizedBox(
      height: 200.h,
      width: MediaQuery.of(context).size.width * .45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 25.h,
                width: 25.w,
                child: SvgPicture.asset("assets/icons/commodity_icon.svg"),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "items info",
                style: TextStyle(
                  fontSize: 17.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 160.h,
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              thickness: 3.0,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: widget.shipment.shipmentItems!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "name: ${widget.shipment.shipmentItems![index].commodityName!}",
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "weight: ${widget.shipment.shipmentItems![index].commodityWeight!}",
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "package type: pallete",
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.white,
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildCo2Report() {
    return SizedBox(
      height: 140.h,
      width: MediaQuery.of(context).size.width * .45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 25.h,
                width: 25.w,
                child: SvgPicture.asset("assets/icons/co2fingerprint.svg"),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "CO2 fingerprint",
                style: TextStyle(
                  fontSize: 17.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Ew: ${_report.ew!.toString()}',
            style: TextStyle(
              fontSize: 17.sp,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Gw: ${_report.gw!.toString()}',
            style: TextStyle(
              fontSize: 17.sp,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Et: ${_report.et!.toString()}',
            style: TextStyle(
              fontSize: 17.sp,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Gt: ${_report.gt!.toString()}',
            style: TextStyle(
              fontSize: 17.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
