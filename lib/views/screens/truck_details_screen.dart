import 'dart:convert';

import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/order_truck_bloc.dart';
import 'package:camion/business_logic/bloc/shipments/shippment_create_bloc.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/data/models/stripe_model.dart';
import 'package:camion/data/models/truck_model.dart';
import 'package:camion/data/models/truck_type_model.dart';
import 'package:camion/data/providers/add_shippment_provider.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/helpers/http_helper.dart';
import 'package:camion/views/screens/control_view.dart';
import 'package:camion/views/widgets/custom_app_bar.dart';
import 'package:camion/views/widgets/custom_botton.dart';
import 'package:camion/views/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TruckDetailsScreen extends StatefulWidget {
  final Truck truck;
  final List<TextEditingController>? commodityName_controllers;
  final List<TextEditingController>? commodityWeight_controllers;
  final int? truckType;
  TruckDetailsScreen(
      {Key? key,
      required this.truck,
      required this.commodityName_controllers,
      this.commodityWeight_controllers,
      this.truckType})
      : super(key: key);

  @override
  State<TruckDetailsScreen> createState() => _TruckDetailsScreenState();
}

class _TruckDetailsScreenState extends State<TruckDetailsScreen> {
  bool _loading = false;
  String getTruckType(int type) {
    switch (type) {
      case 1:
        return "سطحة";
      case 2:
        return "براد";
      case 3:
        return "حاوية";
      case 4:
        return "شحن";
      case 5:
        return "قاطرة ومقطورة";
      case 6:
        return "tier";
      default:
        return "سطحة";
    }
  }

  String getEnTruckType(int type) {
    switch (type) {
      case 1:
        return "Flatbed";
      case 2:
        return "Refrigerated";
      case 3:
        return "Container";
      case 4:
        return "Semi Trailer";
      case 5:
        return "Jumbo Trailer";
      case 6:
        return "tier";
      default:
        return "FlatBed";
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
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColor.lightGrey200,
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.translate('search_result'),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 122.h,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Card(
                          elevation: 1,
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.network(
                                widget.truck.images![0].image!,
                                height: 250.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 250.h,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Text("error on loading "),
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }

                                  return SizedBox(
                                    height: 250.h,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.translate('truck_type')}: ${localeState.value.languageCode == 'en' ? getEnTruckType(widget.truck.truckType!) : getTruckType(widget.truck.truckType!)}',
                                      style: TextStyle(
                                          // color: AppColor.lightBlue,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.translate('truck_location')}: ${widget.truck.location!}',
                                      style: TextStyle(
                                        // color: AppColor.lightBlue,
                                        fontSize: 17.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.translate('empty_weight')}: ${widget.truck.emptyWeight!}',
                                      style: TextStyle(
                                        // color: AppColor.lightBlue,
                                        fontSize: 17.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.translate('number_of_axels')}: ${widget.truck.numberOfAxels!}',
                                      style: TextStyle(
                                        // color: AppColor.lightBlue,
                                        fontSize: 17.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceAround,
                                    //   children: [

                                    //   ],),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        widget.truck.rating! >= 1
                                            ? Icon(
                                                Icons.star,
                                                color: AppColor.deepYellow,
                                              )
                                            : Icon(
                                                Icons.star_border,
                                                color: AppColor.deepYellow,
                                              ),
                                        widget.truck.rating! >= 2
                                            ? Icon(
                                                Icons.star,
                                                color: AppColor.deepYellow,
                                              )
                                            : Icon(
                                                Icons.star_border,
                                                color: AppColor.deepYellow,
                                              ),
                                        widget.truck.rating! >= 3
                                            ? Icon(
                                                Icons.star,
                                                color: AppColor.deepYellow,
                                              )
                                            : Icon(
                                                Icons.star_border,
                                                color: AppColor.deepYellow,
                                              ),
                                        widget.truck.rating! >= 4
                                            ? Icon(
                                                Icons.star,
                                                color: AppColor.deepYellow,
                                              )
                                            : Icon(
                                                Icons.star_border,
                                                color: AppColor.deepYellow,
                                              ),
                                        widget.truck.rating! == 5
                                            ? Icon(
                                                Icons.star,
                                                color: AppColor.deepYellow,
                                              )
                                            : Icon(
                                                Icons.star_border,
                                                color: AppColor.deepYellow,
                                              ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .7,
                              child: BlocConsumer<ShippmentCreateBloc,
                                  ShippmentCreateState>(
                                listener: (context, state) {
                                  if (state is ShippmentCreateSuccessState) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: localeState.value.languageCode ==
                                              'en'
                                          ? const Text(
                                              'Shipment was created successfully. waiting for driver to approve')
                                          : const Text(
                                              'تم انشاء الشاحنة بنجاح بانتظار موافقة السائق.'),
                                      duration: const Duration(seconds: 3),
                                    ));
                                    // BlocProvider.of<TrucksListBloc>(context).add(
                                    //     TrucksListLoadEvent(
                                    //         state.shipment.truckType!));
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ControlView(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is ShippmentLoadingProgressState) {
                                    return CustomButton(
                                      title: const LoadingIndicator(),
                                      onTap: () {},
                                    );
                                  } else {
                                    return Consumer<AddShippmentProvider>(
                                        builder: (context, shippmentProvider,
                                            child) {
                                      return CustomButton(
                                        title: Text(
                                          AppLocalizations.of(context)!
                                              .translate('order_truck'),
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                          ),
                                        ),
                                        onTap: () {
                                          Shipment shipment = Shipment();

                                          shipment.truckType =
                                              TruckType(id: widget.truckType);
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
                                                  widget
                                                      .commodityWeight_controllers!
                                                      .length;
                                              i++) {
                                            ShipmentItems item = ShipmentItems(
                                              commodityName: widget
                                                  .commodityName_controllers![i]
                                                  .text,
                                              commodityWeight: double.parse(widget
                                                      .commodityWeight_controllers![
                                                          i]
                                                      .text
                                                      .replaceAll(",", ""))
                                                  .toInt(),
                                            );
                                            items.add(item);
                                            totalWeight += double.parse(widget
                                                    .commodityWeight_controllers![
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
                                                  shipment,
                                                  widget
                                                      .truck.truckuser!.user!));
                                          // BlocProvider.of<OrderTruckBloc>(
                                          //         context)
                                          //     .add(OrderTruckButtonPressed(
                                          //         widget.truck.truckuser!.id!));
                                        },
                                      );
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50.h,
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
