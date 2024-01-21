import 'package:flutter/material.dart' show Locale;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleState(const Locale('en')));
  void toArabic() => emit(LocaleState(const Locale('ar')));
  void toEnglish() => emit(LocaleState(const Locale('en')));
}
