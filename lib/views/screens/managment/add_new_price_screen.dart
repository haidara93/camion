import 'package:camion/Localization/app_localizations.dart';
import 'package:camion/business_logic/bloc/managment/create_category_bloc.dart';
import 'package:camion/business_logic/bloc/managment/simple_category_list_bloc.dart';
import 'package:camion/business_logic/cubit/locale_cubit.dart';
import 'package:camion/data/models/commodity_category_model.dart';
import 'package:camion/data/models/kshipment_model.dart';
import 'package:camion/data/models/price_request_model.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:camion/views/screens/control_view.dart';
import 'package:camion/views/widgets/custom_app_bar.dart';
import 'package:camion/views/widgets/custom_botton.dart';
import 'package:camion/views/widgets/loading_indicator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intel;

class AddNewPriceScreen extends StatefulWidget {
  final PriceRequestDetails request;
  AddNewPriceScreen({Key? key, required this.request}) : super(key: key);

  @override
  State<AddNewPriceScreen> createState() => _AddNewPriceScreenState();
}

class _AddNewPriceScreenState extends State<AddNewPriceScreen> {
  var f = intel.NumberFormat("#,###", "en_US");
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SimpleCategory? simplecategory;

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
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColor.lightGrey200,
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.translate('search_result'),
              ),
              body: SingleChildScrollView(
                // physics: const NeverScrollableScrollPhysics(),
                child: Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 1,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'مرسل الطلب: ${widget.request.merchant!.user!.firstName!} ${widget.request.merchant!.user!.lastName!}',
                          style: TextStyle(
                              // color: AppColor.lightBlue,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'رقم الهاتف: ${widget.request.merchant!.user!.phone!}',
                          style: TextStyle(
                              // color: AppColor.lightBlue,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Divider(color: Colors.grey[200]),
                        Text(
                          'اسم البضاعة المراد إضافتها: ${widget.request.categoryName!} ',
                          style: TextStyle(
                              // color: AppColor.lightBlue,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Divider(color: Colors.grey[200]),
                        Text(
                          'التسعير',
                          style: TextStyle(
                              // color: AppColor.lightBlue,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'اسم البضاعة',
                                  style: TextStyle(
                                    // color: Colors.white,
                                    fontSize: 19.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 350.w,
                              child: TextFormField(
                                // focusNode: focusNode,
                                // keyboardType: TextInputType.phone,
                                // initialValue: widget.initialValue,
                                controller: _nameController,
                                onTap: () {
                                  _nameController.selection =
                                      TextSelection.collapsed(
                                          offset: _nameController.text.length);
                                },
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 3) {
                                    return 'الرجاء ادخال اسم البضاعة';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _nameController.text = newValue!;
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
                                  hintText: "أدخل اسم البضاعة",
                                  // labelText: AppLocalizations.of(context)!
                                  //     .translate('username'),
                                  // floatingLabelStyle: TextStyle(
                                  //   color: AppColor.deepYellow,
                                  //   fontSize: 24.sp,
                                  //   fontWeight: FontWeight.bold,
                                  // ),
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
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "السعر",
                                  style: TextStyle(
                                    // color: Colors.white,
                                    fontSize: 19.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 350.w,
                              child: TextFormField(
                                controller: _priceController,
                                onTap: () {
                                  _priceController.selection =
                                      TextSelection.collapsed(
                                          offset: _priceController.text.length);
                                },
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 3) {
                                    return "الرجاء ادخال السعر";
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _priceController.text = newValue!;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19.sp,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 2.h),
                                  hintText: "أدخل السعر",
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
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "الصنف",
                                  style: TextStyle(
                                    // color: Colors.white,
                                    fontSize: 19.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 350.w,
                              child: BlocBuilder<SimpleCategoryListBloc,
                                  SimpleCategoryListState>(
                                builder: (context, state2) {
                                  if (state2
                                      is SimpleCategoryListLoadedSuccess) {
                                    return DropdownButtonHideUnderline(
                                      child: DropdownButton2<SimpleCategory>(
                                        isExpanded: true,
                                        hint: Text(
                                          "اختر نوع الصنف",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        items: state2.categories
                                            .map((SimpleCategory item) =>
                                                DropdownMenuItem<
                                                    SimpleCategory>(
                                                  value: item,
                                                  child: SizedBox(
                                                    width: 300.w,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          item.nameAr!,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 17,
                                                          ),
                                                        ),
                                                        Divider(
                                                          height: 5,
                                                          color:
                                                              Colors.grey[200],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        value: simplecategory,
                                        onChanged: (SimpleCategory? value) {
                                          setState(() {
                                            simplecategory = value;
                                          });
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          height: 50,
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 9.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.black26,
                                            ),
                                            color: Colors.white,
                                          ),
                                          // elevation: 2,
                                        ),
                                        iconStyleData: IconStyleData(
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down_sharp,
                                          ),
                                          iconSize: 20,
                                          iconEnabledColor: AppColor.deepYellow,
                                          iconDisabledColor: Colors.grey,
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: Colors.white,
                                          ),
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                                MaterialStateProperty.all(6),
                                            thumbVisibility:
                                                MaterialStateProperty.all(true),
                                          ),
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          height: 40,
                                        ),
                                      ),
                                    );
                                  } else if (state2
                                      is SimpleCategoryListLoadingProgress) {
                                    return const Center(
                                      child: LinearProgressIndicator(),
                                    );
                                  } else if (state2
                                      is SimpleCategoryListLoadedFailed) {
                                    return Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<
                                                      SimpleCategoryListBloc>(
                                                  context)
                                              .add(
                                                  SimpleCategoryListLoadEvent());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .translate('list_error'),
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                            const Icon(
                                              Icons.refresh,
                                              color: Colors.grey,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            )
                          ]),
                        ),
                        Divider(color: Colors.grey[200]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            BlocConsumer<CreateCategoryBloc,
                                CreateCategoryState>(
                              listener: (context, state) {
                                if (state is CreateCategoryLoadedSuccess) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ControlView(),
                                      ),
                                      (route) => false);
                                }
                                if (state is CreateCategoryLoadedFailed) {
                                  print(state.error);
                                }
                              },
                              builder: (context, state) {
                                if (state is CreateCategoryLoadingProgress) {
                                  return CustomButton(
                                    title: SizedBox(
                                        width: 350.w,
                                        child: LoadingIndicator()),
                                    onTap: () {},
                                  );
                                } else {
                                  return CustomButton(
                                    title: SizedBox(
                                        width: 350.w,
                                        child: const Center(
                                            child: Text("أضف صنف جديد"))),
                                    onTap: () {
                                      _formKey.currentState?.save();
                                      if (_formKey.currentState!.validate()) {
                                        KCommodityCategory category =
                                            KCommodityCategory();
                                        category.name = _nameController.text;
                                        category.nameAr = _nameController.text;
                                        category.price =
                                            int.parse(_priceController.text);
                                        category.category = simplecategory!.id!;

                                        BlocProvider.of<CreateCategoryBloc>(
                                                context)
                                            .add(
                                          CreateCategoryButtonPressedEvent(
                                              category: category),
                                        );
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
