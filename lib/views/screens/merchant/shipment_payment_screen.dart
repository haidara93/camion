import 'dart:convert';

import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/instructions/payment_create_bloc.dart';
import 'package:camion/business_logic/bloc/truck/truck_details_bloc.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/models/instruction_model.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/data/models/stripe_model.dart';
import 'package:camion/data/providers/task_num_provider.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:timelines/timelines.dart';

class ShipmentPaymentScreen extends StatefulWidget {
  final Shipment shipment;
  ShipmentPaymentScreen({
    Key? key,
    required this.shipment,
  }) : super(key: key);

  @override
  State<ShipmentPaymentScreen> createState() => _ShipmentPaymentScreenState();
}

class _ShipmentPaymentScreenState extends State<ShipmentPaymentScreen> {
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
    var paymentDate = "";
    paymentDate = '${date.year}-$month-${date.day}';
    return paymentDate;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
          textDirection: localeState.value.languageCode == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                BlocBuilder<TruckDetailsBloc, TruckDetailsState>(
                  builder: (context, state) {
                    if (state is TruckDetailsLoadedSuccess) {
                      return Column(
                        children: [
                          Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${AppLocalizations.of(context)!.translate('shipment_number')}: SA-${widget.shipment.id!}',
                                        style: TextStyle(
                                            // color: AppColor.lightBlue,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 7.h,
                                      ),
                                      SizedBox(
                                        height: 70.h,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TimelineTile(
                                              direction: Axis.horizontal,
                                              oppositeContents: Text(
                                                '${widget.shipment.pickupDate!.year.toString()}-${widget.shipment.pickupDate!.month.toString()}-${widget.shipment.pickupDate!.day.toString()}',
                                              ),
                                              contents: Text(
                                                widget.shipment
                                                    .pickupCityLocation!,
                                              ),
                                              node: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .26,
                                                child: TimelineNode(
                                                  indicator: DotIndicator(
                                                      color:
                                                          AppColor.deepYellow),
                                                  // startConnector: SolidLineConnector(),
                                                  endConnector:
                                                      DashedLineConnector(
                                                          color: AppColor
                                                              .deepYellow),
                                                ),
                                              ),
                                            ),
                                            TimelineTile(
                                              direction: Axis.horizontal,
                                              oppositeContents:
                                                  const SizedBox.shrink(),
                                              contents: const SizedBox.shrink(),
                                              node: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .26,
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
                                                widget.shipment
                                                    .deliveryCityLocation!,
                                              ),
                                              node: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .3,
                                                child: TimelineNode(
                                                  indicator: DotIndicator(
                                                      color:
                                                          AppColor.deepYellow),
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Card(
                            elevation: 1,
                            clipBehavior: Clip.antiAlias,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: double.infinity,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate('operation_cost'),
                                    style: TextStyle(
                                        // color: AppColor.lightBlue,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  Text(
                                    '${AppLocalizations.of(context)!.translate('price')}: ${state.truck.price!}',
                                    style: TextStyle(
                                      // color: AppColor.lightBlue,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  Divider(
                                    height: 7.h,
                                  ),
                                  Text(
                                    '${AppLocalizations.of(context)!.translate('extra_fees')}: ${state.truck.fees!}',
                                    style: TextStyle(
                                      // color: AppColor.lightBlue,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  Visibility(
                                    visible:
                                        widget.shipment.shipmentpayment != null,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: double.infinity,
                                        ),
                                        Divider(
                                          height: 7.h,
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context)!.translate('total_amount')}: ${(widget.shipment.shipmentpayment!.amount! + widget.shipment.shipmentpayment!.fees! + widget.shipment.shipmentpayment!.extraFees!)}',
                                          style: TextStyle(
                                            // color: AppColor.lightBlue,
                                            fontSize: 17.sp,
                                          ),
                                        ),
                                        Divider(
                                          height: 7.h,
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context)!.translate('payment_date')}: ${setLoadDate(widget.shipment.shipmentpayment!.created_date!)}',
                                          style: TextStyle(
                                            // color: AppColor.lightBlue,
                                            fontSize: 17.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Divider(
                                          height: 7.h,
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context)!.translate('payment_method')}: VISA Card',
                                          style: TextStyle(
                                            // color: AppColor.lightBlue,
                                            fontSize: 17.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          widget.shipment.shipmentpayment == null
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: CustomButton(
                                    title: _loading
                                        ? const LoadingIndicator()
                                        : Text(AppLocalizations.of(context)!
                                            .translate('pay_now')),
                                    onTap: () async {
                                      setState(() {
                                        _loading = true;
                                      });
                                      var prefs =
                                          await SharedPreferences.getInstance();
                                      var jwt = prefs.getString("token");
                                      var amount = (state.truck.fees! +
                                              state.truck.price!) *
                                          100;

                                      final response = await HttpHelper.get(
                                          "https://matjari.app/make_payment/?amount=$amount",
                                          apiToken: jwt);
                                      print(response.body);
                                      print(response.statusCode);
                                      var jsonBody = jsonDecode(response.body);

                                      StripeModel stripeModel =
                                          StripeModel.fromJson(jsonBody);
                                      if (stripeModel.paymentIntent! != "" &&
                                          stripeModel.paymentIntent != null) {
                                        String _intent =
                                            stripeModel.paymentIntent!;
                                        await stripe.Stripe.instance
                                            .initPaymentSheet(
                                          paymentSheetParameters: stripe
                                              .SetupPaymentSheetParameters(
                                            customFlow: false,
                                            merchantDisplayName: 'Camion',
                                            paymentIntentClientSecret:
                                                stripeModel.paymentIntent,
                                            customerEphemeralKeySecret:
                                                stripeModel.ephemeralKey,
                                            customerId: stripeModel.customer,
                                            applePay: const stripe
                                                .PaymentSheetApplePay(
                                              merchantCountryCode: 'US',
                                            ),
                                            googlePay: const stripe
                                                .PaymentSheetGooglePay(
                                              merchantCountryCode: 'US',
                                              testEnv: true,
                                            ),
                                            style: ThemeMode.light,
                                          ),
                                        );
                                        setState(() {
                                          _loading = false;
                                        });
                                        stripe.Stripe.instance
                                            .presentPaymentSheet()
                                            .onError((error, stackTrace) {
                                          print(error);
                                        });
                                        stripe.Stripe.instance
                                            .confirmPaymentSheetPayment()
                                            .then((value) {
                                          var amount = (state.truck.fees! +
                                              state.truck.price!);
                                          ShipmentPayment payment =
                                              ShipmentPayment();
                                          payment.shipment =
                                              widget.shipment.id!;
                                          payment.amount = state.truck.price;
                                          payment.paymentMethod = "S";
                                          payment.fees = state.truck.fees;
                                          payment.extraFees =
                                              state.truck.extraFees;

                                          BlocProvider.of<PaymentCreateBloc>(
                                                  context)
                                              .add(PaymentCreateButtonPressed(
                                                  payment));
                                        });
                                      }
                                    },
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
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
                Consumer<TaskNumProvider>(
                    builder: (context, taskProvider, child) {
                  return BlocConsumer<PaymentCreateBloc, PaymentCreateState>(
                    listener: (context, state) {
                      if (state is PaymentCreateSuccessState) {
                        taskProvider.decreaseTaskNum();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: localeState.value.languageCode == 'en'
                              ? const Text(
                                  'Payment has been created successfully.')
                              : const Text('تم الدفع بنجاح'),
                          duration: const Duration(seconds: 3),
                        ));

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ControlView(),
                            ),
                            (route) => false);
                      }
                    },
                    builder: (context, state) {
                      if (state is PaymentLoadingProgressState) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          color: Colors.white70,
                          child: const Center(child: LoadingIndicator()),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
