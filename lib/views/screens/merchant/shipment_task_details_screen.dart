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

class ShipmentTaskDetailsScreen extends StatefulWidget {
  final Shipment shipment;
  ShipmentTaskDetailsScreen({
    Key? key,
    required this.shipment,
  }) : super(key: key);

  @override
  State<ShipmentTaskDetailsScreen> createState() =>
      _ShipmentTaskDetailsScreenState();
}

class _ShipmentTaskDetailsScreenState extends State<ShipmentTaskDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;

  bool instructionSelect = true;

  final FocusNode _orderTypenode = FocusNode();
  var key1 = GlobalKey();
  String selectedRadioTile = "";

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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                instructionSelect = true;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .47,
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.white,
                                border: Border.all(
                                  color: instructionSelect
                                      ? AppColor.deepYellow
                                      : Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          widget.shipment.shipmentinstruction ==
                                                  null
                                              ? const Icon(
                                                  Icons.warning_amber_rounded,
                                                  color: Colors.red,
                                                )
                                              : Icon(
                                                  Icons.check_circle,
                                                  color: AppColor.deepYellow,
                                                )
                                        ]),
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
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .35,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'shipment instruction',
                                              style: TextStyle(
                                                  // color: AppColor.lightBlue,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .4,
                                      child:
                                          widget.shipment.shipmentinstruction ==
                                                  null
                                              ? const Text(
                                                  "shipment instruction is not completed.",
                                                  maxLines: 2,
                                                )
                                              : const Text(
                                                  "shipment instruction is completed.",
                                                  maxLines: 2,
                                                ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<TruckDetailsBloc>(context).add(
                                  TruckDetailsLoadEvent(
                                      widget.shipment.driver!.truck!));
                              setState(() {
                                instructionSelect = false;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .47,
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.white,
                                border: Border.all(
                                  color: !instructionSelect
                                      ? AppColor.deepYellow
                                      : Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          widget.shipment.shipmentpayment ==
                                                  null
                                              ? const Icon(
                                                  Icons.warning_amber_rounded,
                                                  color: Colors.red,
                                                )
                                              : Icon(
                                                  Icons.check_circle,
                                                  color: AppColor.deepYellow,
                                                )
                                        ]),
                                    Row(
                                      children: [
                                        SizedBox(
                                            height: 25.h,
                                            width: 25.w,
                                            child: SvgPicture.asset(
                                                "assets/icons/payment.svg")),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .35,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'shipment payment',
                                              style: TextStyle(
                                                  // color: AppColor.lightBlue,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .4,
                                      child: widget.shipment.shipmentpayment ==
                                              null
                                          ? const Text(
                                              "shipment payment is not completed.",
                                              maxLines: 2,
                                            )
                                          : const Text(
                                              "shipment payment is completed.",
                                              maxLines: 2,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    instructionSelect
                        ? ShipmentInstructionScreen(shipment: widget.shipment)
                        : ShipmentPaymentScreen(shipment: widget.shipment),
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
