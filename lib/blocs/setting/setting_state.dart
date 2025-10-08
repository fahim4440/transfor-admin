part of 'setting_bloc.dart';

sealed class SettingState extends Equatable {
  const SettingState();
}

final class SettingInitial extends SettingState {
  @override
  List<Object> get props => [];
}

final class SettingLoading extends SettingState {
  @override
  List<Object> get props => [];
}

final class SettingLoaded extends SettingState {
  final Setting setting;
  const SettingLoaded({required this.setting});

  @override
  List<Object> get props => [setting];
}

final class SettingFailure extends SettingState {
  final String message;
  const SettingFailure({required this.message});
  
  @override
  List<Object> get props => [message];
}