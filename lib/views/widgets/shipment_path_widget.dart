import 'package:camion/helpers/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dash/flutter_dash.dart';

class ShipmentPathWidget extends StatelessWidget {
  final String? loadDate;
  final String pickupName;
  final String deliveryName;
  final double width;
  final double pathwidth;
  const ShipmentPathWidget({
    Key? key,
    this.loadDate,
    required this.pickupName,
    required this.deliveryName,
    required this.width,
    required this.pathwidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          loadDate != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loadDate!,
                    ),
                    Text(
                      loadDate!,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          SizedBox(
            height: 7.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/icons/location1.png",
                height: 25.h,
                width: 17.w,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Dash(
                      direction: Axis.horizontal,
                      length: pathwidth,
                      dashLength: 12,
                      dashColor: AppColor.deepYellow),
                ],
              ),
              Image.asset(
                "assets/icons/location2.png",
                height: 25.h,
                width: 17.w,
              ),
            ],
          ),
          SizedBox(
            height: 7.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .33,
                child: Text(
                  pickupName,
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .33,
                child: Text(
                  deliveryName,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
