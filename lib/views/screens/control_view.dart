import 'package:camion/business_logic/bloc/auth_bloc.dart';
import 'package:camion/business_logic/bloc/package_type_bloc.dart';
import 'package:camion/business_logic/bloc/shipments/active_shipment_list_bloc.dart';
import 'package:camion/business_logic/bloc/truck/truck_type_bloc.dart';
// import 'package:camion/business_logic/bloc/notification_bloc.dart';
import 'package:camion/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:camion/business_logic/cubit/internet_cubit.dart';
import 'package:camion/views/screens/driver/driver_home_screen.dart';
import 'package:camion/views/screens/merchant/home_screen.dart';
import 'package:camion/views/screens/owner/owner_home_screen.dart';
import 'package:camion/views/screens/select_user_type.dart';
import 'package:camion/views/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControlView extends StatelessWidget {
  const ControlView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<InternetCubit, InternetState>(
        builder: (context, state) {
          if (state is InternetLoading) {
            return const Center(
              child: LoadingIndicator(),
            );
          } else if (state is InternetDisConnected) {
            return const Center(
              child: Text("no internet connection"),
            );
          } else if (state is InternetConnected) {
            BlocProvider.of<BottomNavBarCubit>(context).emitShow();
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthDriverSuccessState) {
                  BlocProvider.of<TruckTypeBloc>(context)
                      .add(TruckTypeLoadEvent());
                  BlocProvider.of<PackageTypeBloc>(context)
                      .add(PackageTypeLoadEvent());
                  return DriverHomeScreen();
                } else if (state is AuthOwnerSuccessState) {
                  BlocProvider.of<TruckTypeBloc>(context)
                      .add(TruckTypeLoadEvent());
                  BlocProvider.of<PackageTypeBloc>(context)
                      .add(PackageTypeLoadEvent());
                  return OwnerHomeScreen();
                } else if (state is AuthMerchentSuccessState) {
                  BlocProvider.of<TruckTypeBloc>(context)
                      .add(TruckTypeLoadEvent());
                  BlocProvider.of<PackageTypeBloc>(context)
                      .add(PackageTypeLoadEvent());
                  BlocProvider.of<ActiveShipmentListBloc>(context)
                      .add(ActiveShipmentListLoadEvent());
                  return HomeScreen();
                } else if (state is AuthInitial) {
                  BlocProvider.of<AuthBloc>(context).add(AuthCheckRequested());
                  return const Center(
                    child: LoadingIndicator(),
                  );
                } else {
                  return SelectUserType();
                }
              },
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
