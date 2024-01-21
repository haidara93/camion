import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/auth_bloc.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/views/screens/driver/driver_home_screen.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/views/screens/merchant/home_screen.dart';
import 'package:camion/views/screens/owner/owner_home_screen.dart';
import 'package:camion/views/widgets/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final focusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    _postData(context);
  }

  void _postData(context) {
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text("aasdasd")));
    BlocProvider.of<AuthBloc>(context).add(SignInButtonPressed(
        _usernameController.text, _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
          textDirection: localeState.value.languageCode == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage("assets/images/camion_backgroung_image.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      child: Card(
                        elevation: 1,
                        clipBehavior: Clip.antiAlias,
                        color: AppColor.deepBlack,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(45),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 60.h, horizontal: 20.w),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 75.h,
                                    width: 150.w,
                                    child: SvgPicture.asset(
                                        "assets/images/camion_logo_sm.svg"),
                                  ),
                                  SizedBox(
                                    height: 110.h,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate('please_sign_in'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  SizedBox(
                                    width: 350.w,
                                    child: TextFormField(
                                      // focusNode: focusNode,
                                      // keyboardType: TextInputType.phone,
                                      // initialValue: widget.initialValue,
                                      controller: _usernameController,
                                      onTap: () {
                                        _usernameController.selection =
                                            TextSelection.collapsed(
                                                offset: _usernameController
                                                    .text.length);
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length < 3) {
                                          return AppLocalizations.of(context)!
                                              .translate('username_error');
                                        }
                                        return null;
                                      },
                                      onSaved: (newValue) {
                                        _usernameController.text = newValue!;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 19.sp,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 2.h),
                                        hintText: AppLocalizations.of(context)!
                                            .translate('username'),
                                        labelText: AppLocalizations.of(context)!
                                            .translate('username'),
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 19.sp,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  SizedBox(
                                    width: 350.w,
                                    child: TextFormField(
                                      // focusNode: focusNode,
                                      // keyboardType: TextInputType.phone,
                                      // initialValue: widget.initialValue,
                                      controller: _passwordController,
                                      onTap: () {
                                        _passwordController.selection =
                                            TextSelection.collapsed(
                                                offset: _passwordController
                                                    .text.length);
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length < 3) {
                                          return AppLocalizations.of(context)!
                                              .translate('password_error');
                                        }
                                        return null;
                                      },
                                      onSaved: (newValue) {
                                        _passwordController.text = newValue!;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 19.sp,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 2.h),
                                        hintText: AppLocalizations.of(context)!
                                            .translate('password'),
                                        labelText: AppLocalizations.of(context)!
                                            .translate('password'),
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 19.sp,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  BlocConsumer<AuthBloc, AuthState>(
                                    listener: (context, state) {
                                      if (state is AuthDriverSuccessState) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: localeState.value.languageCode ==
                                                  'en'
                                              ? const Text(
                                                  'sign in successfully, welcome.')
                                              : const Text(
                                                  'تم تسجيل الدخول بنجاح! أهلا بك.'),
                                          duration: const Duration(seconds: 3),
                                        ));

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DriverHomeScreen(),
                                          ),
                                        );
                                      }
                                      if (state is AuthOwnerSuccessState) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: localeState.value.languageCode ==
                                                  'en'
                                              ? const Text(
                                                  'sign in successfully, welcome.')
                                              : const Text(
                                                  'تم تسجيل الدخول بنجاح! أهلا بك.'),
                                          duration: const Duration(seconds: 3),
                                        ));

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OwnerHomeScreen(),
                                            ));
                                      }
                                      if (state is AuthMerchentSuccessState) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: localeState.value.languageCode ==
                                                  'en'
                                              ? const Text(
                                                  'sign in successfully, welcome.')
                                              : const Text(
                                                  'تم تسجيل الدخول بنجاح! أهلا بك.'),
                                          duration: const Duration(seconds: 3),
                                        ));

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen(),
                                            ));
                                      }
                                      if (state is AuthLoginErrorState) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: localeState.value.languageCode ==
                                                  'en'
                                              ? const Text(
                                                  'there is no active account for this credentials.')
                                              : const Text(
                                                  "لا يوجد حساب فعال وفقا للبيانات المدخلة."),
                                          duration: const Duration(seconds: 3),
                                        ));
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is AuthLoggingInProgressState) {
                                        return CustomButton(
                                          title:
                                              const CircularProgressIndicator(),
                                          onTap: () {},
                                        );
                                      } else {
                                        return CustomButton(
                                          title: Text(
                                            AppLocalizations.of(context)!
                                                .translate('sign_in'),
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                          onTap: () {
                                            _formKey.currentState?.save();

                                            if (_formKey.currentState!
                                                .validate()) {
                                              _login();
                                            }
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // const Spacer(),
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