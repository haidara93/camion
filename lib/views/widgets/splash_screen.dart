import 'package:camion/business_logic/bloc/package_type_bloc.dart';
import 'package:camion/business_logic/bloc/post_bloc.dart';
import 'package:camion/business_logic/bloc/shipments/active_shipment_list_bloc.dart';
import 'package:camion/business_logic/bloc/shipments/shipment_list_bloc.dart';
import 'package:camion/business_logic/bloc/truck/truck_type_bloc.dart';
import 'package:camion/views/screens/control_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<PostBloc>(context).add(PostLoadEvent());
    BlocProvider.of<TruckTypeBloc>(context).add(TruckTypeLoadEvent());
    BlocProvider.of<PackageTypeBloc>(context).add(PackageTypeLoadEvent());
    BlocProvider.of<ShipmentListBloc>(context).add(ShipmentListLoadEvent("P"));
    BlocProvider.of<ActiveShipmentListBloc>(context)
        .add(ActiveShipmentListLoadEvent());
    Future.delayed(const Duration(seconds: 8))
        .then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const ControlView(),
            ),
            (route) => false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/splash.svg",
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
