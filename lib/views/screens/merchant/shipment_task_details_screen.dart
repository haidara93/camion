import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/truck/truck_details_bloc.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/views/screens/merchant/shipment_instruction_screen.dart';
import 'package:camion/views/screens/merchant/shipment_payment_screen.dart';
import 'package:camion/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ShipmentTaskDetailsScreen extends StatelessWidget {
  final Shipment shipment;
  ShipmentTaskDetailsScreen({
    Key? key,
    required this.shipment,
  }) : super(key: key);

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
                title: "shipment tasks",
              ),
              backgroundColor: Colors.grey[200],
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ShipmentInstructionScreen(shipment: shipment),
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
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            height: 25.h,
                                            width: 25.w,
                                            child: SvgPicture.asset(
                                                "assets/icons/instruction.svg")),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'shipment instruction',
                                          style: TextStyle(
                                              // color: AppColor.lightBlue,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    shipment.shipmentinstruction == null
                                        ? const Text(
                                            "shipment instruction is not completed.")
                                        : const Text(
                                            "shipment instruction is completed."),
                                  ],
                                ),
                                shipment.shipmentinstruction == null
                                    ? const Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons.check_circle,
                                        color: AppColor.deepYellow,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<TruckDetailsBloc>(context).add(
                              TruckDetailsLoadEvent(shipment.driver!.truck!));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShipmentPaymentScreen(),
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
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            height: 25.h,
                                            width: 32.w,
                                            child: SvgPicture.asset(
                                                "assets/icons/payment.svg")),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'payment instruction',
                                          style: TextStyle(
                                              // color: AppColor.lightBlue,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    shipment.shipmentpayment == null
                                        ? const Text(
                                            "shipment payment is not completed.")
                                        : const Text(
                                            "shipment payment is completed."),
                                  ],
                                ),
                                shipment.shipmentpayment == null
                                    ? const Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons.check_circle,
                                        color: AppColor.deepYellow,
                                      ),
                              ],
                            ),
                          ),
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
  }
}
