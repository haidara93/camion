import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/post_bloc.dart';
import 'package:camion/business_logic/bloc/shipments/shipment_list_bloc.dart';
import 'package:camion/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/providers/add_shippment_provider.dart';
import 'package:camion/data/services/fcm_service.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/views/screens/merchant/active_shipment_screen.dart';
import 'package:camion/views/screens/merchant/add_shippment_screen.dart';
import 'package:camion/views/screens/main_screen.dart';
import 'package:camion/views/screens/merchant/shipment_instruction_screen.dart';
import 'package:camion/views/screens/merchant/shipment_task_screen.dart';
import 'package:camion/views/screens/shippment_log_screen.dart';
import 'package:camion/views/screens/tracking_shippment_screen.dart';
import 'package:camion/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int currentIndex = 0;
  int navigationValue = 0;
  String title = "Home";
  Widget currentScreen = MainScreen();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  NotificationServices notificationServices = NotificationServices();
  late TabController _tabController;
  AddShippmentProvider? addShippmentProvider;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostBloc>(context).add(PostLoadEvent());

    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    _tabController = TabController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addShippmentProvider =
          Provider.of<AddShippmentProvider>(context, listen: false);
      setState(() {
        title = AppLocalizations.of(context)!.translate('home');
      });
    });
  }

  @override
  void dispose() {
    // Remove the WidgetsBindingObserver when the state is disposed
    // scroll.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void changeSelectedValue(
      {required int selectedValue, required BuildContext contxt}) async {
    setState(() {
      navigationValue = selectedValue;
    });
    _tabController.animateTo(selectedValue);

    switch (selectedValue) {
      case 0:
        {
          BlocProvider.of<PostBloc>(context).add(PostLoadEvent());
          print("sdfsdf");
          setState(() {
            title = AppLocalizations.of(context)!.translate('home');
            currentScreen = MainScreen();
          });
          break;
        }
      case 1:
        {
          BlocProvider.of<ShipmentListBloc>(context)
              .add(ShipmentListLoadEvent("P"));
          setState(() {
            title = AppLocalizations.of(context)!.translate('shippment_log');
            currentScreen = ShippmentLogScreen();
          });
          break;
        }
      case 2:
        {
          addShippmentProvider!.initForm();
          setState(() {
            title = AppLocalizations.of(context)!.translate('order_shippment');
            currentScreen = AddShippmentScreen();
          });
          break;
        }
      case 3:
        {
          BlocProvider.of<ShipmentListBloc>(context)
              .add(ShipmentListLoadEvent("R"));
          setState(() {
            title = AppLocalizations.of(context)!.translate('tracking');

            currentScreen = ActiveShipmentScreen();
          });
          break;
        }
      case 4:
        {
          BlocProvider.of<ShipmentListBloc>(context)
              .add(ShipmentListLoadEvent("P"));
          setState(() {
            title = AppLocalizations.of(context)!.translate('tasks');

            currentScreen = ShipmentTaskScreen();
          });
          break;
        }
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
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                BlocProvider.of<BottomNavBarCubit>(context).emitShow();
              },
              child: Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomInset: false,
                appBar: CustomAppBar(
                  title: title,
                  scaffoldKey: _scaffoldKey,
                ),
                bottomNavigationBar:
                    BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
                  builder: (context, state) {
                    if (state is BottomNavBarShown) {
                      return Container(
                        height: 88.h,
                        color: AppColor.deepBlack,
                        child: TabBar(
                          labelPadding: EdgeInsets.zero,
                          controller: _tabController,
                          indicatorColor: AppColor.deepYellow,
                          labelColor: AppColor.deepYellow,
                          unselectedLabelColor: Colors.white,
                          labelStyle: TextStyle(fontSize: 15.sp),
                          unselectedLabelStyle: TextStyle(fontSize: 14.sp),
                          padding: EdgeInsets.zero,
                          onTap: (value) {
                            changeSelectedValue(
                                selectedValue: value, contxt: context);
                          },
                          tabs: [
                            Tab(
                              // text: "طلب مخلص",
                              height: 66.h,
                              icon: navigationValue == 0
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/home_selected.svg",
                                          width: 36.w,
                                          height: 36.h,
                                        ),
                                        localeState.value.languageCode == 'en'
                                            ? const SizedBox(
                                                height: 4,
                                              )
                                            : const SizedBox.shrink(),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate('home'),
                                          style: TextStyle(
                                              color: AppColor.deepYellow,
                                              fontSize: 15.sp),
                                        )
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/home.svg",
                                          width: 30.w,
                                          height: 30.h,
                                        ),
                                        localeState.value.languageCode == 'en'
                                            ? const SizedBox(
                                                height: 4,
                                              )
                                            : const SizedBox.shrink(),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate('home'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp),
                                        )
                                      ],
                                    ),
                            ),
                            Tab(
                              // text: "الحاسبة",
                              height: 66.h,
                              icon: navigationValue == 1
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/listalt_selected.svg",
                                          width: 36.w,
                                          height: 36.h,
                                        ),
                                        localeState.value.languageCode == 'en'
                                            ? const SizedBox(
                                                height: 4,
                                              )
                                            : const SizedBox.shrink(),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate('shippment_log'),
                                          style: TextStyle(
                                              color: AppColor.deepYellow,
                                              fontSize: 15.sp),
                                        )
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/listalt.svg",
                                          width: 30.w,
                                          height: 30.h,
                                        ),
                                        localeState.value.languageCode == 'en'
                                            ? const SizedBox(
                                                height: 4,
                                              )
                                            : const SizedBox.shrink(),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate('shippment_log'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp),
                                        )
                                      ],
                                    ),
                            ),
                            Tab(
                              // text: "الرئيسية",
                              height: 66.h,
                              icon: navigationValue == 2
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/truck_order_selected.svg",
                                          width: 36.w,
                                          height: 36.h,
                                        ),
                                        localeState.value.languageCode == 'en'
                                            ? const SizedBox(
                                                height: 4,
                                              )
                                            : const SizedBox.shrink(),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate('order_shippment'),
                                            style: TextStyle(
                                                color: AppColor.deepYellow,
                                                fontSize: 15.sp),
                                          ),
                                        )
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/truck_order.svg",
                                          width: 30.w,
                                          height: 30.h,
                                        ),
                                        localeState.value.languageCode == 'en'
                                            ? const SizedBox(
                                                height: 4,
                                              )
                                            : const SizedBox.shrink(),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate('order_shippment'),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp),
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                            Tab(
                              height: 66.h,
                              icon: navigationValue == 3
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/location_selected.svg",
                                          width: 36.w,
                                          height: 36.h,
                                        ),
                                        localeState.value.languageCode == 'en'
                                            ? const SizedBox(
                                                height: 4,
                                              )
                                            : const SizedBox.shrink(),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate('tracking'),
                                          style: TextStyle(
                                              color: AppColor.deepYellow,
                                              fontSize: 15.sp),
                                        )
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/location.svg",
                                          width: 30.w,
                                          height: 30.h,
                                        ),
                                        localeState.value.languageCode == 'en'
                                            ? const SizedBox(
                                                height: 4,
                                              )
                                            : const SizedBox.shrink(),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate('tracking'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp),
                                        )
                                      ],
                                    ),
                            ),
                            Tab(
                              height: 66.h,
                              icon: navigationValue == 4
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/task_selected.svg",
                                          width: 36.w,
                                          height: 36.h,
                                        ),
                                        localeState.value.languageCode == 'en'
                                            ? const SizedBox(
                                                height: 4,
                                              )
                                            : const SizedBox.shrink(),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate('tasks'),
                                          style: TextStyle(
                                              color: AppColor.deepYellow,
                                              fontSize: 15.sp),
                                        )
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/tasks.svg",
                                          width: 30.w,
                                          height: 30.h,
                                        ),
                                        localeState.value.languageCode == 'en'
                                            ? const SizedBox(
                                                height: 4,
                                              )
                                            : const SizedBox.shrink(),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate('tasks'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp),
                                        )
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                body: currentScreen,
              ),
            ),
          ),
        );
      },
    );
  }
}
