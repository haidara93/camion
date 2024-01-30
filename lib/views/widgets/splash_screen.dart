import 'package:camion/business_logic/bloc/package_type_bloc.dart';
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
    BlocProvider.of<TruckTypeBloc>(context).add(TruckTypeLoadEvent());
    BlocProvider.of<PackageTypeBloc>(context).add(PackageTypeLoadEvent());
    Future.delayed(Duration(seconds: 8))
        .then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ControlView(),
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
            "assets/images/camion_splash_background.svg",
            fit: BoxFit.fitHeight,
          ),
          SvgPicture.asset(
            "assets/images/camion_official_logo.svg",
            fit: BoxFit.fitHeight,
          ),
        ],
      ),
    );
  }
}
