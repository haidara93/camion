import 'dart:io';

import 'package:camion/Localization/app_localizations_setup.dart';
import 'package:camion/business_logic/bloc/auth_bloc.dart';
import 'package:camion/business_logic/bloc/instructions/instruction_create_bloc.dart';
import 'package:camion/business_logic/bloc/instructions/payment_create_bloc.dart';
import 'package:camion/business_logic/bloc/notification_bloc.dart';
import 'package:camion/business_logic/bloc/order_truck_bloc.dart';
import 'package:camion/business_logic/bloc/package_type_bloc.dart';
import 'package:camion/business_logic/bloc/post_bloc.dart';
import 'package:camion/business_logic/bloc/draw_route_bloc.dart';
import 'package:camion/business_logic/bloc/shipments/active_shipment_list_bloc.dart';
import 'package:camion/business_logic/bloc/shipments/shipment_complete_list_bloc.dart';
import 'package:camion/business_logic/bloc/shipments/shipment_details_bloc.dart';
import 'package:camion/business_logic/bloc/shipments/shipment_list_bloc.dart';
import 'package:camion/business_logic/bloc/shipments/shippment_create_bloc.dart';
import 'package:camion/business_logic/bloc/truck/truck_details_bloc.dart';
import 'package:camion/business_logic/bloc/truck/truck_type_bloc.dart';
import 'package:camion/business_logic/bloc/truck/trucks_list_bloc.dart';
import 'package:camion/business_logic/bloc/truck_papers/create_truck_paper_bloc.dart';
import 'package:camion/business_logic/bloc/truck_papers/truck_papers_bloc.dart';
import 'package:camion/business_logic/cubit/bottom_nav_bar_cubit.dart';
import 'package:camion/business_logic/cubit/internet_cubit.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/providers/active_shipment_provider.dart';
import 'package:camion/data/providers/add_shippment_provider.dart';
import 'package:camion/data/providers/notification_provider.dart';
import 'package:camion/data/providers/task_num_provider.dart';
import 'package:camion/data/repositories/auth_repository.dart';
import 'package:camion/data/repositories/notification_repository.dart';
import 'package:camion/data/repositories/post_repository.dart';
import 'package:camion/data/repositories/shipmment_repository.dart';
import 'package:camion/data/repositories/truck_repository.dart';
import 'package:camion/firebase_options.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/views/widgets/splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // you need to initialize firebase first
  await Firebase.initializeApp(
    name: "Camion",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Permission.notification.isDenied.then((value) {
  //   if (value) {
  //     Permission.notification.request();
  //   }
  // });
  final LocaleCubit localeCubit = LocaleCubit();
  await localeCubit.initializeFromPreferences();

  Stripe.publishableKey =
      "pk_test_51IZr3HApYMiHRCEPfSdLaWzGSzImzW2kc61cSI4mYf3JptVXsfFj2SG1xcBLBgLVdvW8EXckH50FgzKZeNp454dK00xplc6hCI";
  Stripe.merchantIdentifier = "AcrossMena";
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    name: "Camion",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  HttpOverrides.global = MyHttpOverrides();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Connectivity connectivity = Connectivity();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return ScreenUtilInit(
          designSize: orientation == Orientation.portrait
              ? const Size(428, 926)
              : const Size(926, 428),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MultiRepositoryProvider(
              providers: [
                RepositoryProvider(
                  create: (context) => AuthRepository(),
                ),
                RepositoryProvider(
                  create: (context) => PostRepository(),
                ),
                RepositoryProvider(
                  create: (context) => NotificationRepository(),
                ),
                RepositoryProvider(
                  create: (context) => ShippmentRerository(),
                ),
                RepositoryProvider(
                  create: (context) => TruckRepository(),
                ),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (context) => AuthBloc(
                          authRepository:
                              RepositoryProvider.of<AuthRepository>(context))),
                  BlocProvider(
                      create: (context) => NotificationBloc(
                          notificationRepository:
                              RepositoryProvider.of<NotificationRepository>(
                                  context))),
                  BlocProvider(
                    create: (context) => PostBloc(
                        postRepository:
                            RepositoryProvider.of<PostRepository>(context)),
                  ),
                  BlocProvider(
                    create: (context) => TrucksListBloc(
                        truckRepository:
                            RepositoryProvider.of<TruckRepository>(context)),
                  ),
                  BlocProvider(
                    create: (context) => TruckDetailsBloc(
                        truckRepository:
                            RepositoryProvider.of<TruckRepository>(context)),
                  ),
                  BlocProvider(
                    create: (context) => TruckPapersBloc(
                        truckRepository:
                            RepositoryProvider.of<TruckRepository>(context)),
                  ),
                  BlocProvider(
                    create: (context) => CreateTruckPaperBloc(
                        truckRepository:
                            RepositoryProvider.of<TruckRepository>(context)),
                  ),
                  BlocProvider(
                    create: (context) => TruckTypeBloc(
                        shippmentRerository:
                            RepositoryProvider.of<ShippmentRerository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => PackageTypeBloc(
                        shippmentRerository:
                            RepositoryProvider.of<ShippmentRerository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => ShippmentCreateBloc(
                        shippmentRerository:
                            RepositoryProvider.of<ShippmentRerository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => InstructionCreateBloc(
                        shippmentRerository:
                            RepositoryProvider.of<ShippmentRerository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => PaymentCreateBloc(
                        shippmentRerository:
                            RepositoryProvider.of<ShippmentRerository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => OrderTruckBloc(
                        shippmentRerository:
                            RepositoryProvider.of<ShippmentRerository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => ShipmentListBloc(
                        shippmentRerository:
                            RepositoryProvider.of<ShippmentRerository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => ShipmentCompleteListBloc(
                        shippmentRerository:
                            RepositoryProvider.of<ShippmentRerository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => ActiveShipmentListBloc(
                        shippmentRerository:
                            RepositoryProvider.of<ShippmentRerository>(
                                context)),
                  ),
                  BlocProvider(
                    create: (context) => ShipmentDetailsBloc(
                        shippmentRerository:
                            RepositoryProvider.of<ShippmentRerository>(
                                context)),
                  ),
                  BlocProvider(create: (context) => DrawRouteBloc()),
                  BlocProvider(create: (context) => BottomNavBarCubit()),
                  BlocProvider(
                      create: (context) =>
                          InternetCubit(connectivity: connectivity)),
                  BlocProvider(create: (context) => LocaleCubit()),
                ],
                child: MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => TaskNumProvider()),
                    ChangeNotifierProvider(
                        create: (_) => NotificationProvider()),
                    ChangeNotifierProvider(
                        create: (_) => AddShippmentProvider()),
                    ChangeNotifierProvider(
                        create: (_) => ActiveShippmentProvider()),
                  ],
                  child: BlocBuilder<LocaleCubit, LocaleState>(
                    buildWhen: (previous, current) => previous != current,
                    builder: (context, localeState) {
                      return MaterialApp(
                        title: 'Camion',
                        debugShowCheckedModeBanner: false,
                        localizationsDelegates:
                            AppLocalizationsSetup.localizationsDelegates,
                        supportedLocales:
                            AppLocalizationsSetup.supportedLocales,
                        // localeResolutionCallback: AppLocalizationsSetup.,
                        locale: localeState.value,
                        scrollBehavior:
                            ScrollConfiguration.of(context).copyWith(
                          physics: const ClampingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                        ),
                        theme: ThemeData(
                          colorScheme: ColorScheme.fromSeed(
                            seedColor: AppColor.deepYellow,
                          ),
                          useMaterial3: true,
                          cardTheme: const CardTheme(
                            surfaceTintColor: Colors.white,
                            clipBehavior: Clip.antiAlias,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            labelStyle: TextStyle(
                                fontSize: 18, color: Colors.grey[600]!),
                            suffixStyle: const TextStyle(
                              fontSize: 20,
                            ),
                            floatingLabelStyle: const TextStyle(
                              fontSize: 20,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 11.0, horizontal: 9.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.black26,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColor.deepYellow,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          textTheme: GoogleFonts.robotoTextTheme(
                            Theme.of(context).textTheme,
                          ),
                          dividerColor: Colors.grey[400],
                          scaffoldBackgroundColor: Colors.white,
                        ),
                        home: SplashScreen(),
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: child!,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
