import 'dart:convert';

import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/truck/truck_details_bloc.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/models/stripe_model.dart';
import 'package:camion/helpers/http_helper.dart';
import 'package:camion/views/widgets/custom_app_bar.dart';
import 'package:camion/views/widgets/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

class ShipmentPaymentScreen extends StatefulWidget {
  ShipmentPaymentScreen({Key? key}) : super(key: key);

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
              appBar: CustomAppBar(
                title: "Payment Instruction",
              ),
              backgroundColor: Colors.grey[200],
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<TruckDetailsBloc, TruckDetailsState>(
                    builder: (context, state) {
                      if (state is TruckDetailsLoadedSuccess) {
                        return Column(
                          children: [
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
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.network(
                                    state.truck.images![0].image!,
                                    height: 175.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 175.h,
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
                                        height: 175.h,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${AppLocalizations.of(context)!.translate('truck_type')}: ${localeState.value.languageCode == 'en' ? getEnTruckType(state.truck.truckType!) : getTruckType(state.truck.truckType!)}',
                                          style: TextStyle(
                                              // color: AppColor.lightBlue,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context)!.translate('truck_location')}: ${state.truck.location!}',
                                          style: TextStyle(
                                            // color: AppColor.lightBlue,
                                            fontSize: 17.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Text(
                                          'price: ${state.truck.price!}',
                                          style: TextStyle(
                                            // color: AppColor.lightBlue,
                                            fontSize: 17.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Text(
                                          'extra fees: ${state.truck.fees!}',
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
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .7,
                              child: CustomButton(
                                title: _loading
                                    ? const CircularProgressIndicator()
                                    : Text("order truck"),
                                onTap: () async {
                                  setState(() {
                                    _loading = true;
                                  });
                                  var prefs =
                                      await SharedPreferences.getInstance();
                                  var jwt = prefs.getString("token");

                                  final response = await HttpHelper.get(
                                      "https://matjari.app/make_payment/",
                                      apiToken: jwt);
                                  print(response.body);
                                  print(response.statusCode);
                                  var jsonBody = jsonDecode(response.body);

                                  StripeModel stripeModel =
                                      StripeModel.fromJson(jsonBody);
                                  if (stripeModel.paymentIntent! != "" &&
                                      stripeModel.paymentIntent != null) {
                                    String _intent = stripeModel.paymentIntent!;
                                    await stripe.Stripe.instance
                                        .initPaymentSheet(
                                      paymentSheetParameters:
                                          stripe.SetupPaymentSheetParameters(
                                        // Set to true for custom flow
                                        customFlow: false,
                                        // Main params

                                        merchantDisplayName: 'Camion',
                                        paymentIntentClientSecret:
                                            stripeModel.paymentIntent,
                                        // Customer keys
                                        customerEphemeralKeySecret:
                                            stripeModel.ephemeralKey,
                                        customerId: stripeModel.customer,
                                        // Extra options
                                        applePay:
                                            const stripe.PaymentSheetApplePay(
                                          merchantCountryCode: 'US',
                                        ),
                                        googlePay:
                                            const stripe.PaymentSheetGooglePay(
                                          merchantCountryCode: 'US',
                                          testEnv: true,
                                        ),
                                        // style: ThemeMode.dark,
                                      ),
                                    );
                                    setState(() {
                                      _loading = false;
                                    });
                                    stripe.Stripe.instance
                                        .presentPaymentSheet()
                                        .onError((error, stackTrace) {
                                      print(error);
                                      print("error");
                                      print("error");
                                      print("error");
                                    });
                                  }
                                },
                              ),
                            )
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
