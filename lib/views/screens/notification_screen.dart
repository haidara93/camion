import 'package:camion/business_logic/bloc/notification_bloc.dart';
import 'package:camion/business_logic/bloc/shipments/shipment_details_bloc.dart';
// import 'package:camion/business_logic/bloc/offer_details_bloc.dart';
import 'package:camion/data/providers/notification_provider.dart';
import 'package:camion/data/services/fcm_service.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/views/screens/merchant/active_shipment_details_from_notification.dart';
import 'package:camion/views/screens/merchant/shipment_task_details_from_notification.dart';
// import 'package:camion/views/screens/broker/order_details_screen.dart';
// import 'package:camion/views/screens/trader/log_screens/offer_details_screen.dart';
import 'package:camion/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String usertype = "Trader";

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

  getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usertype = prefs.getString("userType") ?? "";
  }

  @override
  void initState() {
    super.initState();
    getUserType();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: CustomAppBar(
          title: "Notifications",
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<NotificationProvider>(
                  builder: (context, notificationProvider, child) {
                    return notificationProvider.notifications.isEmpty
                        ? const Center(
                            child: Text("There are no Notifications to show."),
                          )
                        : ListView.builder(
                            itemCount:
                                notificationProvider.notifications.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              // DateTime now = DateTime.now();
                              // Duration diff = now
                              //     .difference(state.offers[index].createdDate!);
                              DateTime now = DateTime.now();
                              Duration diff = now.difference(DateTime.parse(
                                  notificationProvider
                                      .notifications[index].dateCreated!));
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      // bottom: BorderSide(
                                      //     color: AppColor.deepBlue, width: 2),
                                      ),
                                  color: notificationProvider
                                          .notifications[index].isread!
                                      ? Colors.white
                                      : Colors.blue[50],
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () {
                                    BlocProvider.of<ShipmentDetailsBloc>(
                                            context)
                                        .add(ShipmentDetailsLoadEvent(
                                            notificationProvider
                                                .notifications[index]
                                                .shipment!));
                                    print(notificationProvider
                                        .notifications[index].sender!);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ActiveShipmentDetailsFromNotificationScreen(
                                            user_id:
                                                'driver${notificationProvider.notifications[index].sender!}',
                                          ),
                                        ));
                                    if (!notificationProvider
                                        .notifications[index].isread!) {
                                      NotificationServices
                                          .markNotificationasRead(
                                              notificationProvider
                                                  .notifications[index].id!);
                                      notificationProvider
                                          .markNotificationAsRead(
                                              notificationProvider
                                                  .notifications[index].id!);
                                    }
                                  },
                                  leading: Container(
                                    height: 75.h,
                                    width: 75.w,
                                    decoration: BoxDecoration(
                                        // color: AppColor.lightGoldenYellow,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: CircleAvatar(
                                      radius: 25.h,
                                      // backgroundColor: AppColor.deepBlue,
                                      child: Center(
                                        child: (notificationProvider
                                                    .notifications[index]
                                                    .image!
                                                    .length >
                                                1)
                                            ? Image.network(
                                                'https://matjari.app/${notificationProvider.notifications[index].image!}',
                                                height: 55.h,
                                                width: 55.w,
                                                fit: BoxFit.fill,
                                              )
                                            : Text(
                                                notificationProvider
                                                    .notifications[index]
                                                    .image!,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28.sp,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  title: Text(notificationProvider
                                      .notifications[index].title!),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(notificationProvider
                                          .notifications[index].description!),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(diffText(diff)),
                                          SizedBox(
                                            width: 9.w,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  dense: false,
                                ),
                              );
                            });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
