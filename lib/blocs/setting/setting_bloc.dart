import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transfor_admin_dashboard/services/settings_services.dart';

import '../../models/settings.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final SettingsServices _settingsServices = SettingsServices();
  SettingBloc() : super(SettingInitial()) {
    on<SettingLoadingInitiate>((event, emit) async {
      emit(SettingLoading());
      try {
        Setting? setting = await _settingsServices.fetchSettings('TRANS');
        if (setting != null) {
          emit(SettingLoaded(setting: setting));
        } else {
          emit(SettingFailure(message: ''));
        }
      } catch (e) {
        emit(SettingFailure(message: 'Something went wrong: $e'));
      }
    });

    on<SaveSetting>((event, emit) async {
      emit(SettingLoading());
      try {
        String? message = await _settingsServices.saveSettings(event.setting);
        Setting? setting = await _settingsServices.fetchSettings('TRANS');
        if (setting != null && message != null) {
          emit(SettingLoaded(setting: setting));
        } else {
          emit(SettingFailure(message: ''));
        }
      } catch (e) {
        emit(SettingFailure(message: 'Something went wrong: $e'));
      }
    });
  }
}
