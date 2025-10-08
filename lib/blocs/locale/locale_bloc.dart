import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleInitial(Locale('en'))) {
    on<ChangeLocale>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lang', event.locale.languageCode);
      emit(LocaleInitial(event.locale));
    });

    _loadSavedLocale();
  }

  void _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('lang') ?? 'en';
    add(ChangeLocale(Locale(lang)));
  }
}
