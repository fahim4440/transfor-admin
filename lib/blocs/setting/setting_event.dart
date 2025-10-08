part of 'setting_bloc.dart';

sealed class SettingEvent extends Equatable {
  const SettingEvent();
}

final class SettingLoadingInitiate extends SettingEvent {
  @override
  List<Object?> get props => [];
}

final class SaveSetting extends SettingEvent {
  final Setting setting;
  const SaveSetting({required this.setting});

  @override
  List<Object?> get props => [setting];
}
